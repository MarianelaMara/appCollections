class Order < ApplicationRecord
  # Una orden pertenece a una colección
  belongs_to :collection
  # Una orden tiene muchos items
  has_many :order_items , dependent: :destroy
  # Una orden tiene muchos artículos a través de los items
  has_many :articles, through: :order_items 

  accepts_nested_attributes_for :order_items
  
end
