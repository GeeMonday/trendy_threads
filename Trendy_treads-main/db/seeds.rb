
# Seed products with stock information and sale prices
products_data = [
  { name: 'iPhone 13 Pro', description: 'The latest iPhone with advanced camera and performance.', price: 999.99, sale_price: 899.99, stock: 50, image_url: 'https://example.com/images/iphone_13_pro.jpg' },
  { name: 'MacBook Pro 2023', description: 'Powerful laptop for professionals with new M2 chip.', price: 1999.99, sale_price: 1799.99, stock: 30, image_url: 'https://example.com/images/macbook_pro_2023.jpg' },
  { name: 'Vivo X80 Pro', description: 'Flagship smartphone with Zeiss optics and powerful camera features.', price: 999.99, sale_price: 949.99, stock: 22, image_url: 'https://example.com/images/vivo_x80_pro.jpg' },
  { name: 'HP Envy x360', description: 'Convertible laptop with AMD Ryzen processor and long battery life.', price: 999.99, sale_price: 899.99, stock: 31, image_url: 'https://example.com/images/envy_x360.jpg' },
  { name: 'LIFX Color A19', description: 'Smart LED bulb with 16 million colors and app control.', price: 59.99, sale_price: 49.99, stock: 37, image_url: 'https://example.com/images/lifx_color_a19.jpg' },
  { name: 'Nintendo Switch Joy-Con', description: 'Pair of Joy-Con controllers for Nintendo Switch with motion control.', price: 79.99, sale_price: 69.99, stock: 17, image_url: 'https://example.com/images/joy_con.jpg' },
  { name: 'Apple Watch Series 8', description: 'Latest smartwatch with advanced health monitoring features.', price: 399.99, sale_price: 349.99, stock: 40, image_url: 'https://example.com/images/apple_watch_series_8.jpg' },
  { name: 'Samsung Galaxy Watch 5', description: 'Feature-rich smartwatch with health tracking and AMOLED display.', price: 299.99, sale_price: 259.99, stock: 35, image_url: 'https://example.com/images/galaxy_watch_5.jpg' },
  { name: 'Dell Inspiron 14', description: 'Versatile laptop with a balance of performance and affordability.', price: 749.99, sale_price: 699.99, stock: 45, image_url: 'https://example.com/images/dell_inspiron_14.jpg' },
  { name: 'JBL Flip 6', description: 'Portable Bluetooth speaker with powerful sound and waterproof design.', price: 129.99, sale_price: 109.99, stock: 55, image_url: 'https://example.com/images/jbl_flip_6.jpg' },
  { name: 'Sonos Arc', description: 'High-end soundbar with Dolby Atmos support for immersive audio.', price: 799.99, sale_price: 749.99, stock: 25, image_url: 'https://example.com/images/sonos_arc.jpg' },
  { name: 'Google Pixel Buds Pro', description: 'Wireless earbuds with active noise cancellation and Google Assistant integration.', price: 199.99, sale_price: 179.99, stock: 30, image_url: 'https://example.com/images/pixel_buds_pro.jpg' },
  { name: 'Anker PowerCore 10000', description: 'Compact power bank with 10,000mAh capacity for on-the-go charging.', price: 29.99, sale_price: 24.99, stock: 60, image_url: 'https://example.com/images/anker_powercore_10000.jpg' },
  { name: 'Kindle Paperwhite', description: 'E-reader with high-resolution display and built-in light for reading anywhere.', price: 139.99, sale_price: 119.99, stock: 40, image_url: 'https://example.com/images/kindle_paperwhite.jpg' },
  { name: 'Apple AirPods Pro', description: 'Wireless earbuds with noise cancellation and transparency mode.', price: 249.99, sale_price: 229.99, stock: 45, image_url: 'https://example.com/images/airpods_pro.jpg' },
  { name: 'Oculus Quest 2', description: 'Standalone VR headset with a wide range of games and applications.', price: 299.99, sale_price: 279.99, stock: 25, image_url: 'https://example.com/images/oculus_quest_2.jpg' },
  { name: 'Corsair K95 RGB Platinum', description: 'Mechanical gaming keyboard with customizable RGB lighting and macro keys.', price: 199.99, sale_price: 179.99, stock: 20, image_url: 'https://example.com/images/corsair_k95_rbg_platinum.jpg' },
  # ... Add more products as needed
]

products_data.each do |product_data|
  Product.find_or_create_by(name: product_data[:name]) do |p|
    p.description = product_data[:description]
    p.price = product_data[:price]
    p.sale_price = product_data[:sale_price] if product_data[:sale_price]
    p.stock = product_data[:stock]
    p.image_url = product_data[:image_url]
  end
  
  puts "Product created: #{product_data[:name]}"
end
