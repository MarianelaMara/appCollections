class Material < ApplicationRecord
    has_many :article_materials
    has_many :articles, through: :article_materials
end
