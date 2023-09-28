class ArticleMaterial < ApplicationRecord
  belongs_to :article
  belongs_to :material
end
