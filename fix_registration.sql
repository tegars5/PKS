-- Fix for User Registration Issues in PalmShell Tracker
-- Run this script in Supabase SQL Editor

-- Step 1: Check if profiles table exists and has the right structure
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID NOT NULL,
  full_name TEXT,
  email TEXT,
  phone_number TEXT,
  address TEXT,
  role TEXT DEFAULT 'buyer',
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT profiles_pkey PRIMARY KEY (id)
);

-- Step 2: Add missing columns if they don't exist
DO $$
BEGIN
  -- Add email column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name='profiles' AND column_name='email'
  ) THEN
    ALTER TABLE profiles ADD COLUMN email TEXT;
  END IF;
  
  -- Add phone_number column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name='profiles' AND column_name='phone_number'
  ) THEN
    ALTER TABLE profiles ADD COLUMN phone_number TEXT;
  END IF;
  
  -- Add address column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name='profiles' AND column_name='address'
  ) THEN
    ALTER TABLE profiles ADD COLUMN address TEXT;
  END IF;
  
  -- Add is_verified column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name='profiles' AND column_name='is_verified'
  ) THEN
    ALTER TABLE profiles ADD COLUMN is_verified BOOLEAN DEFAULT FALSE;
  END IF;
END $$;

-- Step 3: Disable RLS temporarily
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Step 4: Create a simple function to handle user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email, role, created_at, updated_at)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'Unknown User'),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'role', 'buyer'),
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    email = EXCLUDED.email,
    role = EXCLUDED.role,
    updated_at = NOW();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 5: Drop existing trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Step 6: Create trigger for new user registration
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Step 7: Sync existing users
DO $$
DECLARE
    user_record RECORD;
BEGIN
    FOR user_record IN 
        SELECT auth.users.id, 
               auth.users.email,
               COALESCE(auth.users.raw_user_meta_data->>'full_name', 'Unknown User') as full_name,
               COALESCE(auth.users.raw_user_meta_data->>'role', 'buyer') as role
        FROM auth.users
        LEFT JOIN public.profiles ON auth.users.id = public.profiles.id
        WHERE public.profiles.id IS NULL
    LOOP
        INSERT INTO public.profiles (id, full_name, email, role, created_at, updated_at)
        VALUES (
            user_record.id,
            user_record.full_name,
            user_record.email,
            user_record.role,
            NOW(),
            NOW()
        )
        ON CONFLICT (id) DO NOTHING;
    END LOOP;
END $$;

-- Step 8: Re-enable RLS with simple policies
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;

-- Create simpler policies
CREATE POLICY "Users can view their own profile" ON profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Step 9: Verify the fix
SELECT 'Profiles count: ' || COUNT(*) as result FROM public.profiles;
SELECT 'Auth users count: ' || COUNT(*) as result FROM auth.users;
SELECT 'Users without profiles: ' || COUNT(*) as result 
FROM auth.users 
LEFT JOIN public.profiles ON auth.users.id = public.profiles.id 
WHERE public.profiles.id IS NULL;

-- Show recent profiles
SELECT id, full_name, email, role, created_at 
FROM public.profiles 
ORDER BY created_at DESC 
LIMIT 5;