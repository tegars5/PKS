-- Complete Database Schema for PalmShell Tracker
-- Run this script in Supabase SQL Editor

-- 1. Profiles Table (Already exists, but we'll ensure it's complete)
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

-- 2. Products Table
CREATE TABLE IF NOT EXISTS public.products (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  supplier_id UUID NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  price_per_kg DECIMAL(10,2) NOT NULL,
  stock_in_kg DECIMAL(10,2) NOT NULL,
  location TEXT NOT NULL,
  image_urls TEXT[],
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.profiles(id) ON DELETE CASCADE
);

-- 3. Orders Table
CREATE TABLE IF NOT EXISTS public.orders (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  buyer_id UUID NOT NULL,
  supplier_id UUID NOT NULL,
  driver_id UUID,
  product_id UUID NOT NULL,
  quantity_in_kg DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  shipping_address TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  confirmed_at TIMESTAMP WITH TIME ZONE,
  shipped_at TIMESTAMP WITH TIME ZONE,
  delivered_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.profiles(id) ON DELETE CASCADE,
  CONSTRAINT orders_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.profiles(id) ON DELETE CASCADE,
  CONSTRAINT orders_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.profiles(id) ON DELETE SET NULL,
  CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE
);

-- 4. Tracking Table
CREATE TABLE IF NOT EXISTS public.tracking (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  order_id UUID NOT NULL,
  driver_id UUID NOT NULL,
  latitude DECIMAL(10,8) NOT NULL,
  longitude DECIMAL(11,8) NOT NULL,
  status_message TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT tracking_pkey PRIMARY KEY (id),
  CONSTRAINT tracking_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE,
  CONSTRAINT tracking_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.profiles(id) ON DELETE CASCADE
);

-- 5. Chats Table
CREATE TABLE IF NOT EXISTS public.chats (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  participant1_id UUID NOT NULL,
  participant2_id UUID NOT NULL,
  last_message TEXT,
  last_message_sender_id UUID,
  last_message_at TIMESTAMP WITH TIME ZONE,
  is_read BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT chats_pkey PRIMARY KEY (id),
  CONSTRAINT chats_participant1_id_fkey FOREIGN KEY (participant1_id) REFERENCES public.profiles(id) ON DELETE CASCADE,
  CONSTRAINT chats_participant2_id_fkey FOREIGN KEY (participant2_id) REFERENCES public.profiles(id) ON DELETE CASCADE,
  CONSTRAINT chats_last_message_sender_id_fkey FOREIGN KEY (last_message_sender_id) REFERENCES public.profiles(id) ON DELETE SET NULL
);

-- 6. Chat Messages Table
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  chat_id UUID NOT NULL,
  sender_id UUID NOT NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT chat_messages_pkey PRIMARY KEY (id),
  CONSTRAINT chat_messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE,
  CONSTRAINT chat_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE
);

-- 7. Articles Table
CREATE TABLE IF NOT EXISTS public.articles (
  id UUID DEFAULT gen_random_uuid() NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  author TEXT NOT NULL,
  category TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT articles_pkey PRIMARY KEY (id)
);

-- Enable Row Level Security (RLS) for all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;

-- Create Policies for Profiles Table
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
DROP POLICY IF EXISTS "Suppliers can view buyer profiles" ON public.profiles;

CREATE POLICY "Users can view their own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Suppliers can view buyer profiles" ON public.profiles
    FOR SELECT USING (
        auth.uid() IN (
            SELECT supplier_id FROM public.orders 
            WHERE buyer_id = public.profiles.id
        )
    );

-- Create Policies for Products Table
DROP POLICY IF EXISTS "Suppliers can manage their products" ON public.products;
DROP POLICY IF EXISTS "All users can view active products" ON public.products;

CREATE POLICY "Suppliers can manage their products" ON public.products
    FOR ALL USING (auth.uid() = supplier_id);

CREATE POLICY "All users can view active products" ON public.products
    FOR SELECT USING (is_active = true);

-- Create Policies for Orders Table
DROP POLICY IF EXISTS "Buyers can view their orders" ON public.orders;
DROP POLICY IF EXISTS "Suppliers can view their orders" ON public.orders;
DROP POLICY IF EXISTS "Drivers can view assigned orders" ON public.orders;

CREATE POLICY "Buyers can view their orders" ON public.orders
    FOR SELECT USING (auth.uid() = buyer_id);

CREATE POLICY "Suppliers can view their orders" ON public.orders
    FOR SELECT USING (auth.uid() = supplier_id);

CREATE POLICY "Drivers can view assigned orders" ON public.orders
    FOR SELECT USING (auth.uid() = driver_id);

-- Create Policies for Tracking Table
DROP POLICY IF EXISTS "Order participants can view tracking" ON public.tracking;
DROP POLICY IF EXISTS "Drivers can manage tracking" ON public.tracking;

CREATE POLICY "Order participants can view tracking" ON public.tracking
    FOR SELECT USING (
        auth.uid() IN (
            SELECT buyer_id FROM public.orders WHERE id = public.tracking.order_id
            UNION
            SELECT supplier_id FROM public.orders WHERE id = public.tracking.order_id
            UNION
            SELECT driver_id FROM public.orders WHERE id = public.tracking.order_id
        )
    );

CREATE POLICY "Drivers can manage tracking" ON public.tracking
    FOR ALL USING (auth.uid() = driver_id);

-- Create Policies for Chats Table
DROP POLICY IF EXISTS "Chat participants can view their chats" ON public.chats;
DROP POLICY IF EXISTS "Chat participants can manage their chats" ON public.chats;

CREATE POLICY "Chat participants can view their chats" ON public.chats
    FOR SELECT USING (
        auth.uid() = participant1_id OR auth.uid() = participant2_id
    );

CREATE POLICY "Chat participants can manage their chats" ON public.chats
    FOR ALL USING (
        auth.uid() = participant1_id OR auth.uid() = participant2_id
    );

-- Create Policies for Chat Messages Table
DROP POLICY IF EXISTS "Chat participants can view messages" ON public.chat_messages;
DROP POLICY IF EXISTS "Chat participants can insert messages" ON public.chat_messages;

CREATE POLICY "Chat participants can view messages" ON public.chat_messages
    FOR SELECT USING (
        auth.uid() IN (
            SELECT participant1_id FROM public.chats WHERE id = public.chat_messages.chat_id
            UNION
            SELECT participant2_id FROM public.chats WHERE id = public.chat_messages.chat_id
        )
    );

CREATE POLICY "Chat participants can insert messages" ON public.chat_messages
    FOR INSERT WITH CHECK (
        auth.uid() = sender_id AND
        auth.uid() IN (
            SELECT participant1_id FROM public.chats WHERE id = public.chat_messages.chat_id
            UNION
            SELECT participant2_id FROM public.chats WHERE id = public.chat_messages.chat_id
        )
    );

-- Create Policies for Articles Table
DROP POLICY IF EXISTS "All users can view articles" ON public.articles;
DROP POLICY IF EXISTS "Admins can manage articles" ON public.articles;

CREATE POLICY "All users can view articles" ON public.articles
    FOR SELECT USING (true);

CREATE POLICY "Admins can manage articles" ON public.articles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Create Functions for Real-time Updates
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

-- Create Trigger for New User Registration
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Create Function to Update Chat Last Message
CREATE OR REPLACE FUNCTION public.update_chat_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.chats
  SET 
    last_message = NEW.content,
    last_message_sender_id = NEW.sender_id,
    last_message_at = NEW.created_at,
    updated_at = NOW()
  WHERE id = NEW.chat_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create Trigger for Chat Message
DROP TRIGGER IF EXISTS on_chat_message_created ON public.chat_messages;
CREATE TRIGGER on_chat_message_created
  AFTER INSERT ON public.chat_messages
  FOR EACH ROW EXECUTE FUNCTION public.update_chat_last_message();

-- Insert Sample Data for Testing
INSERT INTO public.products (supplier_id, name, description, price_per_kg, stock_in_kg, location, image_urls) VALUES
('00000000-0000-0000-0000-000000000000', 'Cangkang Sawit Kualitas A', 'Cangkang sawit kualitas terbaik dengan kandungan minyak tinggi', 1500.00, 1000.50, 'Medan, Sumatera Utara', ARRAY['https://example.com/image1.jpg', 'https://example.com/image2.jpg']),
('00000000-0000-0000-0000-000000000000', 'Cangkang Sawit Kualitas B', 'Cangkang sawit kualitas standar', 1200.00, 2500.75, 'Palembang, Sumatera Selatan', ARRAY['https://example.com/image3.jpg']),
('00000000-0000-0000-0000-000000000000', 'Cangkang Sawit Kualitas C', 'Cangkang sawit untuk pengolahan industri', 1000.00, 5000.00, 'Jakarta, DKI Jakarta', ARRAY['https://example.com/image4.jpg']);

INSERT INTO public.articles (title, content, author, category, image_url) VALUES
('Tips Memilih Cangkang Sawit Berkualitas', 'Cangkang sawit yang berkualitas memiliki ciri-ciri seperti berikut...', 'Tim Ahli PalmShell', 'education', 'https://example.com/article1.jpg'),
('Harga Cangkang Sawit Hari Ini', 'Update harga cangkang sawit per hari ini di berbagai wilayah...', 'Admin PalmShell', 'news', 'https://example.com/article2.jpg'),
('Proses Pengolahan Cangkang Sawit', 'Berikut adalah proses pengolahan cangkang sawit dari awal hingga akhir...', 'Tim Ahli PalmShell', 'training', 'https://example.com/article3.jpg');

-- Create Indexes for Better Performance
CREATE INDEX IF NOT EXISTS idx_products_supplier_id ON public.products(supplier_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON public.products(is_active);
CREATE INDEX IF NOT EXISTS idx_orders_buyer_id ON public.orders(buyer_id);
CREATE INDEX IF NOT EXISTS idx_orders_supplier_id ON public.orders(supplier_id);
CREATE INDEX IF NOT EXISTS idx_orders_driver_id ON public.orders(driver_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);
CREATE INDEX IF NOT EXISTS idx_tracking_order_id ON public.tracking(order_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants ON public.chats(participant1_id, participant2_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_chat_id ON public.chat_messages(chat_id);
CREATE INDEX IF NOT EXISTS idx_articles_category ON public.articles(category);

-- Verify the schema
SELECT 'Products count: ' || COUNT(*) as result FROM public.products;
SELECT 'Orders count: ' || COUNT(*) as result FROM public.orders;
SELECT 'Articles count: ' || COUNT(*) as result FROM public.articles;
SELECT 'Chats count: ' || COUNT(*) as result FROM public.chats;