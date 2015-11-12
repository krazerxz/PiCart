require 'rails_helper'

describe ProductsController, type: :controller do
  describe '#create' do
    it 'should raise a BarcodeException if the barcode contains a word character' do
      expect do
        post :create, product: { barcode: '54321_text' }
      end.to raise_error(BarcodeException)
    end

    context 'a product with the given barcode exists in the local database' do
      let(:product) { double(:product, save: nil) }

      before do
        allow(Product).to receive(:find_by).with(barcode: '87654321').and_return product
      end

      it 'should check the local product database for the given barcode' do
        expect(Product).to receive(:find_by).with(barcode: '87654321')
        post :create, product: { barcode: '87654321' }
      end
    end

    context 'a product with the given barcode could not be found in the local database' do
      let(:resolved_product) { double(:product, save: nil) }

      before do
        allow(Product).to receive(:find_by).with(barcode: '87654321').and_return nil
        allow(SearchUPCWrapper).to receive(:get_product_for).with('87654321').and_return(resolved_product)
      end

      it 'should strip leading zeros' do
        expect(SearchUPCWrapper).to receive(:get_product_for).with('87654321')
        post :create, product: { barcode: '0087654321' }
      end

      it 'should resolve the product for the given barcode' do
        expect(SearchUPCWrapper).to receive(:get_product_for).with('87654321')
        post :create, product: { barcode: '87654321' }
      end

      it 'saves the resolved product' do
        expect(resolved_product).to receive(:save)
        post :create, product: { barcode: '87654321' }
      end
    end
  end
end
