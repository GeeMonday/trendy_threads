# lib/tasks/fetch_laptops.rake

require 'net/http'
require 'json'

namespace :fetch_laptops do
  desc "Fetch laptops data from Best Buy API and process it"
  task process_and_save: :environment do
    # Fetch laptops data from Best Buy API
    def fetch_laptops_category
      url = URI("https://bestbuy14.p.rapidapi.com/getCategoryByURL?url=https%3A%2F%2Fwww.bestbuy.com%2Fsite%2Flaptop-computers%2Fall-laptops%2Fpcmcat138500050001.c%3Fid%3Dpcmcat138500050001")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-key"] = 'b4f4373bfemshe112a626d9e075bp17ba2ejsn3404677af025'
      request["x-rapidapi-host"] = 'bestbuy14.p.rapidapi.com'

      response = http.request(request)
      data = JSON.parse(response.read_body)

      # Print detailed structure
      puts "API Response Data: #{data.inspect}" # Print response for debugging
      puts "Data class: #{data.class}" # Check the class of the data

      data
    rescue JSON::ParserError => e
      puts "Failed to parse JSON response: #{e.message}"
      nil
    rescue StandardError => e
      puts "HTTP Request failed: #{e.message}"
      nil
    end

    # Process and save laptops data to the database
    def process_and_save_laptops_data(data)
      return if data.nil?

      puts "Processing Data: #{data.inspect}"

      products = data['products']

      unless products.is_a?(Array)
        puts "Expected products to be an array, got #{products.class}."
        products = []
      end

      if products.empty?
        puts "Products data is missing in the response."
        puts "Response data: #{data.inspect}"
        return
      end

      # Process products
      products.each do |product_data|
        if product_data.is_a?(Hash)
          # Use name as a unique identifier
          Product.find_or_create_by(name: product_data['name']) do |product|
            product.description = product_data['description']
            product.price = product_data['price']
            product.stock = product_data['stock']
            product.image_url = product_data['image_url']
          end
        else
          puts "Unexpected format for product data: #{product_data.inspect}"
        end
      end
    end

    data = fetch_laptops_category
    process_and_save_laptops_data(data)
  end
end
