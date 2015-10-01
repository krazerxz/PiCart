class AddBarcodeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :barode, :string
  end
end
