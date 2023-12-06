class OrdersController < ApplicationController

  def index 
    @orders = Order.where(collection_id: params[:collection_id])
  end 
  def new
    @collection_id = params[:collection_id]
  end

  def create
    # Crear un nuevo pedido con los parámetros permitidos
    @order = Order.new(order_params)
    # Guardar el pedido en la base de datos
    if @order.save
      # Redirigir a la vista del pedido
      redirect_to @order 
    else
      # Mostrar un mensaje de error
      flash[:alert] = "No se pudo crear el pedido"
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

  def finalizar_pedido
    @order = Order.find(params[:order_id])
    @order.state = "finalizado"
    @order.save
    BonitaApi.login
    @collection = Collection.find( @order.collection_id)
    @search_task = BonitaApi.search_task(@collection.id_i_bonita, 'Recepción de pedidos')
    BonitaApi.assigned_task(@search_task)
    BonitaApi.complete_task(@search_task)
    redirect_to root_path
  end 

  def recepcion_lotes
    @collection = Collection.find( params[:collection_id])
    @collection.finalizar_coleccion
    @search_task = BonitaApi.search_task(@collection.id_i_bonita, 'Recepción verificación y asignacion  de lotes')

    BonitaApi.assigned_task(@search_task)
    BonitaApi.complete_task(@search_task)
    redirect_to root_path

  end

  private

  # Definir los parámetros permitidos para el pedido
 def order_params    
   params.permit(:date_delivery, :collection_id, :customer)
 end

  
end
