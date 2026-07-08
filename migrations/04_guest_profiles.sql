-- =========================================================================
-- Migration 04 — Guest Profiles & Pincode 
-- =========================================================================

-- 1. Remove the foreign key constraint from profiles to auth.users
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_id_fkey;

-- 2. Add pincode to profiles
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS pincode text;

-- 3. Update RLS Policies for public access (Guests)
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;

CREATE POLICY "Allow anon select on profiles" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Allow anon insert on profiles" ON public.profiles FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update on profiles" ON public.profiles FOR UPDATE USING (true);

-- 4. Update Orders RLS for public access
DROP POLICY IF EXISTS "Users can view their own orders." ON public.orders;
DROP POLICY IF EXISTS "Users can insert their own orders." ON public.orders;

CREATE POLICY "Allow anon select on orders" ON public.orders FOR SELECT USING (true);
CREATE POLICY "Allow anon insert on orders" ON public.orders FOR INSERT WITH CHECK (true);
