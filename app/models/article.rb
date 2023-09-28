class Article < ApplicationRecord

  belongs_to :category, optional: true
  has_and_belongs_to_many :materials, join_table: "article_materials"
  belongs_to :collection, optional: true
  accepts_nested_attributes_for :materials 

end
