require 'net/http'
require 'json'

class SearchUPCWrapper
  API_TOKEN = Rails.application.secrets.search_upc_api_key
  SEARCH_UPC_API_URL = "http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=#{API_TOKEN}&upc="

  def self.get_product_for(upc_code)
    url = "#{SEARCH_UPC_API_URL}#{upc_code}"
    uri = URI(url)
    raw_response = Net::HTTP.get(uri)
    response = JSON.parse(raw_response)['0']
    generate_product_using response, upc_code
  end

  def self.generate_product_using(response, upc_code)
    return Product.new(barcode: upc_code) if response.nil? || response['imageurl'] == 'N/A'
    title = response['productname']
    url = response['imageurl']
    Product.new(name: title, image: url, barcode: upc_code)
  end

  private_class_method :generate_product_using
end
