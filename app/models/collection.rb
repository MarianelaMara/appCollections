class Collection < ApplicationRecord
  include AASM

  aasm do
    state :started, initial: true
    state :in_review #esperando ser aprobada por el ingeniero que la revisa  
    state :approved  #aprobada por un ingenieros, es decir es viable y no debe redefinirse
    state :waiting_to_materials # esperando respuesta de los proveedores de materiales
    state :waiting_to_makers # esperando respuesta de los lugares de fabricacion
    state :waiting_to_be_completed #esperando ser compleda (que se cumplan todos los vencimientos de las reservas)
    state :redefine #cuando debe redefinirse
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

    event :redefine do
      transitions from: :in_review, to: :redefine
    end

    event :waiting_to_materials do
      transitions from: :approved, to: :waiting_to_materials
    end

    event :waiting_to_makers do
      transitions from: :waiting_to_materials, to: :waiting_to_makers
    end

    event :waiting_to_be_completed do
      transitions from:  :waiting_to_makers, to: :waiting_to_be_completed
    end

    event :finish do
      transitions form: :waiting_to_be_completed, to: :finished
    end
  end

  before_create :set_owner

  belongs_to :owner, foreign_key: :owner, class_name: "User", optional: true
  has_many :articles, dependent: :destroy
  scope :by_user, ->(user) { where(owner_id: user.id) }

  def owner
    @owner = User.find(self.owner_id).email
  end

  def enviar_a_revision
    
      in_review! if self.aasm_state == "started"
  end 

  def enviar_a_redefinir    
    redefine! if self.aasm_state == "in_review"
  end 

  def aprobar_coleccion 
    approved! if self.aasm_state == "in_review"
  end 

  def esperar_resultados_materiales
    waiting_to_materials! if self.aasm_state == "approved"
  end 

  def esperar_resultados_lugares
    waiting_to_makers! if self.aasm_state == "waiting_to_materials"
  end 

  def esperar_entregas
    waiting_to_be_completed! if self.aasm_state == "waiting_to_makers"
  end 

  private

  def set_owner
    self.owner_id = Current.user.id
  end
end
