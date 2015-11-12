require 'rails_helper'

describe SearchUPCWrapper do
  describe 'get_product_for' do
    let(:url)          { 'http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=test_upc_key&upc=123' }
    let(:uri)          { URI(url) }
    let(:raw_response) { '{"0":{"productname":"a_name","imageurl":"example.com/img.jpg"}}' }

    before do
      allow(Net::HTTP).to receive(:get).and_return(raw_response)
    end

    it 'fetches information about a UPC code from the search_upc api' do
      expect(Net::HTTP).to receive(:get).with(uri)
      SearchUPCWrapper.get_product_for(123)
    end

    context 'could resolve product' do
      let(:expected_product) { Product.new(name: 'a_name', image: 'example.com/img.jpg', barcode: 123) }

      it 'returns a product with details from the api' do
        product = SearchUPCWrapper.get_product_for(123)
        expect(product.attributes).to eq expected_product.attributes
      end
    end

    context 'product not resolved' do
      let(:empty_product) { Product.new(barcode: 999) }

      it 'returns an empty product if the response was empty' do
        allow(Net::HTTP).to receive(:get).and_return('{}')
        product = SearchUPCWrapper.get_product_for(999)
        expect(product.attributes).to eq empty_product.attributes
      end

      it 'returns an empty product if the response fields are N/A' do
        raw_response = '{"0":{"productname":"N/A","imageurl":"N/A"}}'
        allow(Net::HTTP).to receive(:get).and_return(raw_response)
        product = SearchUPCWrapper.get_product_for(999)
        expect(product.attributes).to eq empty_product.attributes
      end
    end
  end
end
