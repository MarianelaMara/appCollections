class Collection < ApplicationRecord
  include AASM

  aasm do
    state :started, initial: true
    state :in_review #esperando ser aprobada por el ingeniero que la revisa  
    state :approved  #ya dispone de los materiales,sus cantidades, el presupuesto de materiales y el de fabricacion
    state :waiting_to_be_completed #esperando ser compleda (que se cumplan todos los vencimientos de las reservas)
    state :finished

    event :in_review do
      transitions from: :started, to: :in_review
    end

    event :started do
      transitions from: :in_review, to: :started
    end

    event :approved do
      transitions from: :in_review, to: :approved
    end

    event :waiting_to_be_completed do
      transitions from:  :approved, to: :waiting_to_be_completed
    end

    event :finish do
      transitions form: :waiting_to_be_completed, to: :finished
    end
  end

  before_create :set_owner

  belongs_to :owner, foreign_key: :owner, class_name: "User", optional: true
  has_many :articles
  scope :by_user, ->(user) { where(owner_id: user.id) }

  def owner
    @owner = User.find(self.owner_id).email
  end

  def enviar_a_revision
    
      in_review! if self.aasm_state == "started"
  end 

  private

  def set_owner
    self.owner_id = Current.user.id
  end
end
