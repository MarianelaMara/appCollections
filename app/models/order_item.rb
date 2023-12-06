class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :article 

  accepts_nested_attributes_for :article
end
