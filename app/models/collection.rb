class Collection < ApplicationRecord

  before_create :set_owner

  belongs_to :owner, foreign_key: :owner, class_name: "User", optional: true
  has_many :articles
  scope :by_user, ->(user) { where(owner_id: user.id) }

  def owner
    @owner = User.find(self.owner_id).email
  end

  private

  def set_owner
    self.owner_id = Current.user.id
  end
end
