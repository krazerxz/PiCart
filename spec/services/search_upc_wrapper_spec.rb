describe SearchUPCWrapper do
  describe 'get_product_for' do
    let(:mechanize)    { double(:mechanize) }
    let(:field)        { double(:field).as_null_object }
    let(:search_form)  { double(:search_form, field_with: field).as_null_object }
    let(:page)         { double(:page, form_with: search_form).as_null_object }

    before do
      allow(Mechanize).to receive(:new).and_return(mechanize)
      allow(mechanize).to receive(:get).and_return(page)
    end

    it 'loads the searchupc website' do
      expect(mechanize).to receive(:get).with('http://www.searchupc.com')
      SearchUPCWrapper.new.get_product_for('1234')

    end

    it 'searches for the given upc code' do
      expect(field).to receive(:value=).with('1234')
      expect(search_form).to receive(:click_button) # which buttton?
      #upc_form.click_button(upc_form.button_with(name: 'search'))
      SearchUPCWrapper.new.get_product_for('1234')
    end

    context 'product found on search upc' do
      let(:result_data) { double(:result_data, images:[{name: 'Product Image'}], links:[nil,'a_product'])}

      before do
        allow(search_form).to receive(:click_button).and_return(result_data)
      end

      it 'creates product using found details' do
        product_details = {name: 'a_product', image: 'a_url', barcode: '1234'}
        expect(Product).to receive(:new).with(product_details)
        SearchUPCWrapper.new.get_product_for('1234')
      end

      it 'returns the product' do
        product = SearchUPCWrapper.new.get_product_for('1234')
        expect(product).to eq nil
      end
    end

    context 'product not found on search upc' do
      let(:result_data) { double(:result_data, images:[{name: 'nothing here'}])}

      before do
        allow(search_form).to receive(:click_button).and_return(result_data)
      end

      it 'creates a placeholder product' do
        expect(Product).to receive(:new).with(barcode: '1234')
        SearchUPCWrapper.new.get_product_for('1234')
      end

      it 'returns the placeholder product' do
        placeholder_product = SearchUPCWrapper.new.get_product_for('1234')
        expect(placeholder_product).to eq nil
      end
    end
  end
end
