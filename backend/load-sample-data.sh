#!/bin/bash

# Script to insert sample data into Heaven's Door database

echo "Inserting sample properties..."

# Property 1 - Tokyo Luxury Penthouse
docker-compose exec -T db psql -U postgres -d heavens_door <<'EOF'
INSERT INTO properties (owner_id, title, description, property_type, listing_type, price, address, city, state, country, postal_code, latitude, longitude, bedrooms, bathrooms, area_sqft, status, images, amenities, views_count)
VALUES 
('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Luxury Penthouse in Roppongi', 'Stunning penthouse with panoramic city views, modern amenities, and proximity to entertainment district', 'apartment', 'sale', 4500000, '6-10-1 Roppongi', 'Tokyo', 'Tokyo', 'Japan', '106-0032', 35.6632, 139.7297, 3, 2.0, 1800, 'active', '["https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800", "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800"]'::jsonb, '["Parking", "Gym", "Pool", "24/7 Security", "Balcony", "City View"]'::jsonb, 45),

('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'Cozy Studio in Shibuya', 'Perfect for singles or couples. Walking distance to Shibuya crossing', 'apartment', 'sale', 850000, '2-24-12 Shibuya', 'Tokyo', 'Tokyo', 'Japan', '150-0002', 35.6595, 139.7004, 1, 1.0, 350, 'active', '["https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800"]'::jsonb, '["Furnished", "Internet", "Near Station"]'::jsonb, 23),

('c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'Traditional House in Asakusa', 'Beautiful traditional Japanese house with garden', 'house', 'sale', 3200000, '1-1-1 Asakusa', 'Tokyo', 'Tokyo', 'Japan', '111-0032', 35.7148, 139.7967, 4, 2.0, 1500, 'active', '["https://images.unsplash.com/photo-1480074568708-e7b720bb3f09?w=800", "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800"]'::jsonb, '["Garden", "Traditional", "Parking", "Renovated"]'::jsonb, 67),

('d4e5f6a7-b8c9-7d8e-1f2a-3b4c5d6e7f8a', 'Seafront Villa in Posillipo', 'Exclusive villa with private beach access and infinity pool', 'house', 'sale', 6800000, 'Via Posillipo 150', 'Naples', 'Campania', 'Italy', '80123', 40.8046, 14.1932, 5, 4.0, 3200, 'active', '["https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800", "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800"]'::jsonb, '["Pool", "Beach Access", "Garden", "Parking", "Sea View", "Luxury"]'::jsonb, 89),

('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Historic Apartment in Centro Storico', 'Restored apartment in historic center with original frescoes', 'apartment', 'sale', 1900000, 'Via San Biagio dei Librai 39', 'Naples', 'Campania', 'Italy', '80138', 40.8467, 14.2567, 2, 2.0, 950, 'active', '["https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800"]'::jsonb, '["Historic", "Renovated", "City Center", "Balcony"]'::jsonb, 34),

('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'Ocean Drive Art Deco Condo', 'Iconic Art Deco building on Ocean Drive with beach access', 'condo', 'sale', 3800000, '1200 Ocean Drive', 'Miami Beach', 'Florida', 'USA', '33139', 25.7907, -80.1300, 2, 2.0, 1200, 'active', '["https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800"]'::jsonb, '["Beach Access", "Pool", "Gym", "Concierge", "Ocean View"]'::jsonb, 56),

('c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'Modern Brickell High-Rise', 'Sleek modern apartment in Brickell financial district', 'apartment', 'sale', 1650000, '1100 S Miami Ave', 'Miami', 'Florida', 'USA', '33130', 25.7617, -80.1918, 2, 2.0, 1100, 'active', '["https://images.unsplash.com/photo-1502672260066-6bc2c9c4e7a4?w=800"]'::jsonb, '["Gym", "Pool", "Parking", "Concierge", "City View"]'::jsonb, 42),

('d4e5f6a7-b8c9-7d8e-1f2a-3b4c5d6e7f8a', 'Coral Gables Mediterranean Estate', 'Magnificent Mediterranean-style estate with pool and guesthouse', 'house', 'sale', 7500000, '1500 Anastasia Ave', 'Coral Gables', 'Florida', 'USA', '33134', 25.7465, -80.2681, 6, 5.0, 4500, 'active', '["https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800", "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800"]'::jsonb, '["Pool", "Guest House", "Garden", "Parking", "Security", "Luxury"]'::jsonb, 78),

('e5f6a7b8-c9d0-8e9f-2a3b-4c5d6e7f8a9b', 'Ginza Luxury Apartment', 'Prime location in Ginza shopping district with smart home technology', 'apartment', 'sale', 5200000, '4-1-1 Ginza', 'Tokyo', 'Tokyo', 'Japan', '104-0061', 35.6719, 139.7664, 3, 2.0, 1450, 'active', '["https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800"]'::jsonb, '["Smart Home", "Concierge", "Gym", "Shopping District"]'::jsonb, 91),

('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Shinjuku Modern Studio', 'Compact and efficient studio near Shinjuku Station', 'apartment', 'rent', 2500, '3-30-11 Shinjuku', 'Tokyo', 'Tokyo', 'Japan', '160-0022', 35.6896, 139.7006, 1, 1.0, 280, 'active', '["https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800"]'::jsonb, '["Furnished", "Near Station", "Security"]'::jsonb, 18),

('f6a7b8c9-d0e1-9f0a-3b4c-5d6e7f8a9b0c', 'Downtown Tokyo Office Space', 'Prime commercial space in Marunouchi business district', 'commercial', 'rent', 15000, '1-1-1 Marunouchi', 'Tokyo', 'Tokyo', 'Japan', '100-0005', 35.6812, 139.7671, 0, 4.0, 5000, 'active', '["https://images.unsplash.com/photo-1497366216548-37526070297c?w=800"]'::jsonb, '["Elevator", "24/7 Access", "Parking", "Conference Rooms"]'::jsonb, 103),

('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'Akihabara Tech Loft', 'Modern loft in tech district with industrial design', 'apartment', 'sale', 2100000, '1-15-9 Sotokanda', 'Tokyo', 'Tokyo', 'Japan', '101-0021', 35.6989, 139.7709, 2, 1.0, 850, 'pending', '["https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800"]'::jsonb, '["Loft Style", "High Speed Internet", "Near Station"]'::jsonb, 62),

('c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'Wynwood Art District Loft', 'Spacious loft in Miami art district with high ceilings', 'apartment', 'sale', 1450000, '2550 NW 2nd Ave', 'Miami', 'Florida', 'USA', '33127', 25.8009, -80.1990, 2, 2.0, 1300, 'sold', '["https://images.unsplash.com/photo-1600573472550-8090b5e0745e?w=800"]'::jsonb, '["High Ceilings", "Natural Light", "Art District", "Parking"]'::jsonb, 71),

('d4e5f6a7-b8c9-7d8e-1f2a-3b4c5d6e7f8a', 'Harajuku Designer Apartment', 'Trendy apartment in fashion district with designer fixtures', 'apartment', 'sale', 2800000, '1-10-37 Jingumae', 'Tokyo', 'Tokyo', 'Japan', '150-0001', 35.6702, 139.7026, 2, 1.0, 750, 'active', '["https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800"]'::jsonb, '["Designer", "Fashion District", "Balcony", "Modern"]'::jsonb, 38),

('e5f6a7b8-c9d0-8e9f-2a3b-4c5d6e7f8a9b', 'Naples Hilltop Villa', 'Stunning villa on Vomero hill with views of Vesuvius', 'house', 'sale', 4200000, 'Via Bernini 35', 'Naples', 'Campania', 'Italy', '80129', 40.8467, 14.2367, 4, 3.0, 2500, 'active', '["https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800"]'::jsonb, '["View", "Garden", "Parking", "Terrace"]'::jsonb, 54),

('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Key Biscayne Beach House', 'Beachfront property with private dock', 'house', 'sale', 8900000, '200 Ocean Lane Dr', 'Key Biscayne', 'Florida', 'USA', '33149', 25.6926, -80.1631, 5, 4.0, 3800, 'active', '["https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800"]'::jsonb, '["Beach Front", "Dock", "Pool", "Ocean View", "Luxury"]'::jsonb, 102),

('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'Odaiba Waterfront Condo', 'Modern condo with Tokyo Bay views', 'condo', 'sale', 3600000, '1-6-1 Daiba', 'Tokyo', 'Tokyo', 'Japan', '135-0091', 35.6267, 139.7754, 3, 2.0, 1250, 'active', '["https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800"]'::jsonb, '["Water View", "Mall Access", "Parking", "Balcony"]'::jsonb, 47),

('c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'South Beach Penthouse', 'Stunning penthouse with 360-degree views and rooftop terrace', 'apartment', 'sale', 12500000, '100 Lincoln Rd', 'Miami Beach', 'Florida', 'USA', '33139', 25.7903, -80.1376, 4, 4.0, 3500, 'active', '["https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800", "https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800"]'::jsonb, '["Penthouse", "Rooftop", "Private Elevator", "Ocean View", "Luxury"]'::jsonb, 125),

('d4e5f6a7-b8c9-7d8e-1f2a-3b4c5d6e7f8a', 'Design District Townhouse', 'Contemporary townhouse in Miami Design District', 'house', 'sale', 2950000, '150 NE 41st St', 'Miami', 'Florida', 'USA', '33137', 25.8134, -80.1918, 3, 3.0, 1850, 'active', '["https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800"]'::jsonb, '["Modern", "Rooftop", "Parking", "Design District"]'::jsonb, 59),

('e5f6a7b8-c9d0-8e9f-2a3b-4c5d6e7f8a9b', 'Ebisu Garden Place Residence', 'Upscale residence near Ebisu Garden Place', 'apartment', 'sale', 4100000, '4-20-3 Ebisu', 'Tokyo', 'Tokyo', 'Japan', '150-0013', 35.6467, 139.7101, 3, 2.0, 1400, 'active', '["https://images.unsplash.com/photo-1600573472550-8090b5e0745e?w=800"]'::jsonb, '["Quiet Area", "Near Park", "Concierge", "Parking"]'::jsonb, 36);

SELECT 'Properties inserted: ' || COUNT(*) FROM properties;
EOF

echo "Sample data loaded successfully!"
