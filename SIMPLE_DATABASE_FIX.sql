-- SIMPLE DATABASE FIX - Jalankan langkah demi langkah
-- Copy dan jalankan satu section pada satu waktu

-- =====================================================
-- LANGKAH 1: Cek dan buat tabel profiles yang sederhana
-- =====================================================

-- Drop tabel profiles jika ada masalah
DROP TABLE IF EXISTS public.profiles CASCADE;

-- Buat ulang tabel profiles yang sederhana
CREATE TABLE public.profiles (
  id UUID NOT NULL PRIMARY KEY,
  full_name TEXT,
  email TEXT,
  role TEXT NOT NULL DEFAULT 'buyer',
  phone_number VARCHAR(20),
  address TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- LANGKAH 2: Buat trigger yang sederhana
-- =====================================================

-- Drop function dan trigger yang lama
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Buat function trigger yang sederhana
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'Unknown User'),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'role', 'buyer')
  );
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Jika gagal, tetap lanjut
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Buat trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- LANGKAH 3: Sync user yang sudah ada
-- =====================================================

-- Sync user yang sudah ada tanpa error handling
INSERT INTO public.profiles (id, full_name, email, role)
SELECT 
  auth.users.id,
  COALESCE(auth.users.raw_user_meta_data->>'full_name', 'Unknown User'),
  auth.users.email,
  COALESCE(auth.users.raw_user_meta_data->>'role', 'buyer')
FROM auth.users
LEFT JOIN public.profiles ON auth.users.id = public.profiles.id
WHERE public.profiles.id IS NULL
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- LANGKAH 4: Buat user test (opsional)
-- =====================================================

-- Uncomment untuk membuat user test
-- INSERT INTO auth.users (
--   id, 
--   email, 
--   encrypted_password, 
--   email_confirmed_at,
--   raw_user_meta_data
-- ) VALUES (
--   gen_random_uuid(),
--   'test@palmshell.com',
--   crypt('test123456', gen_salt('bf')),
--   NOW(),
--   '{"full_name": "Test User", "role": "buyer"}'
-- );

-- =====================================================
-- LANGKAH 5: Verifikasi
-- =====================================================

-- Cek jumlah profiles
SELECT 'Total profiles: ' || COUNT(*) as result FROM public.profiles;

-- Cek user tanpa profile
SELECT 'Users without profiles: ' || COUNT(*) as result 
FROM auth.users 
LEFT JOIN public.profiles ON auth.users.id = public.profiles.id 
WHERE public.profiles.id IS NULL;

-- Tampilkan 5 profiles terbaru
SELECT id, full_name, email, role, created_at 
FROM public.profiles 
ORDER BY created_at DESC 
LIMIT 5;

-- =====================================================
-- LANGKAH 6: Setup RLS yang sederhana
-- =====================================================

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Drop policies lama
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;

-- Buat policies sederhana
CREATE POLICY "Users can view their own profile" ON profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Selesai! Database sudah siap digunakan