class BarcodeException < Exception; end

class Product < ActiveRecord::Base
  has_many :lists
end
