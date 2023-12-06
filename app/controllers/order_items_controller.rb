class OrderItemsController < ApplicationController

    def index 
      
    end

    def new
      @order = Order.find(params[:order_id])
      @order_items = OrderItem.new 
    end
  
    def create

      @order = Order.find(params[:order_id])
      # Crear un nuevo pedido con los parámetros permitidos
      article_id = params[:order_item][:order_items][:article_id]
      quantity = params[:order_item][:order_items][:quantity]
      @order_item = OrderItem.new(article_id: article_id, quantity: quantity, order_id: @order.id)
      # Guardar el pedido en la base de datos
      if @order_item.save
        # Redirigir a la vista del pedido
        redirect_to @order 
      else
        # Mostrar un mensaje de error
        flash[:alert] = "No se pudo agregar el articulo al pedido"
        # Renderizar la vista new
        render :new
      end
    end
  
    def show
      # Obtener el pedido por su id
      @order = Order.find(params[:id])
      # Obtener los ítems del pedido
      @order_items = @order.order_items
    end
  
  
    private
  
  #  Definir los parámetros permitidos para el pedido
  #  def order_item_params    
  #   params.require(:order_items).permit(:order_id,:quantity, :article_id)
  #  end
  
    
  end
  