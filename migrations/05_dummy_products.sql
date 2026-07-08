-- =========================================================================
-- Dummy Products Insertion
-- =========================================================================

-- Insert 5 Men's Products
INSERT INTO public.products (title, description, price, category, subcategory, images, material, sizes, stock) VALUES
('Premium Formal Shirt', 'A classic fit formal shirt perfect for office and evening wear.', 1499.00, 'mens', 'formal', '{}', 'Cotton', '{"M", "L", "XL"}', 50),
('Casual Denim Jacket', 'Rugged and stylish denim jacket for everyday casual looks.', 2499.00, 'mens', 'casual', '{}', 'Denim', '{"S", "M", "L", "XL"}', 30),
('Classic Chino Pants', 'Comfortable slim-fit chinos suitable for both work and casual outings.', 1799.00, 'mens', 'trousers', '{}', 'Cotton Spandex', '{"30", "32", "34", "36"}', 60),
('Linen Summer Kurta', 'Breathable traditional linen kurta, ideal for festive and summer occasions.', 1999.00, 'mens', 'traditional', '{}', 'Linen', '{"M", "L", "XL", "XXL"}', 40),
('Cotton Polo T-Shirt', 'Soft, breathable cotton polo with a tailored fit.', 899.00, 'mens', 'casual', '{}', 'Cotton', '{"S", "M", "L", "XL"}', 100);

-- Insert 5 Kids Products
INSERT INTO public.products (title, description, price, category, subcategory, images, material, sizes, stock) VALUES
('Boys Party Wear Suit', 'Elegant 3-piece suit for boys, perfect for weddings and parties.', 2199.00, 'kids', 'boys', '{}', 'Poly Viscose', '{"3-4Y", "5-6Y", "7-8Y"}', 25),
('Girls Floral Frock', 'Beautiful printed floral frock with a comfortable cotton inner lining.', 1599.00, 'kids', 'girls', '{}', 'Cotton Blend', '{"2-3Y", "4-5Y", "6-7Y"}', 45),
('Kids Winter Hooded Jacket', 'Warm and cozy winter jacket with fleece lining for kids.', 1899.00, 'kids', 'winterwear', '{}', 'Polyester/Fleece', '{"4-5Y", "6-7Y", "8-9Y"}', 35),
('Boys Casual Graphic T-Shirt', 'Fun and vibrant graphic print t-shirt for active boys.', 499.00, 'kids', 'boys', '{}', 'Cotton', '{"4-5Y", "6-7Y", "8-9Y", "10-12Y"}', 80),
('Girls Denim Overalls', 'Trendy and durable denim overalls with adjustable straps.', 1399.00, 'kids', 'girls', '{}', 'Denim', '{"5-6Y", "7-8Y", "9-10Y"}', 40);

-- Insert 5 Cloth Piece Products
INSERT INTO public.products (title, description, price, category, subcategory, images, material, sizes, stock) VALUES
('Pure Silk Fabric (Unstitched)', 'Luxurious pure silk fabric, perfect for creating designer ethnic wear.', 3200.00, 'cloth-piece', 'silk', '{}', 'Silk', '{"2.5 Meters", "5 Meters"}', 20),
('Fine Cotton Shirting Material', 'Premium quality breathable cotton fabric for custom tailored shirts.', 1100.00, 'cloth-piece', 'cotton', '{}', '100% Cotton', '{"1.6 Meters", "2 Meters"}', 150),
('Premium Linen Suiting', 'High-end linen fabric designed for custom blazers and suits.', 2800.00, 'cloth-piece', 'linen', '{}', 'Linen', '{"3 Meters"}', 40),
('Designer Velvet Fabric', 'Rich and plush velvet material for winter ethnic and party wear.', 4500.00, 'cloth-piece', 'velvet', '{}', 'Velvet', '{"2.5 Meters", "4 Meters"}', 15),
('Breathable Rayon Print', 'Soft and flowy rayon fabric with elegant floral prints.', 850.00, 'cloth-piece', 'rayon', '{}', 'Rayon', '{"2.5 Meters", "5 Meters"}', 100);
