class Article < ApplicationRecord

  has_many_attached :photos

  belongs_to :category, optional: true
  belongs_to :collection, optional: true

  has_many :article_materials
  has_many :materials, through: :article_materials, dependent: :destroy
  has_many :order_items , dependent: :destroy

  accepts_nested_attributes_for :materials 
  accepts_nested_attributes_for :article_materials



end
