class ProvidersController < ApplicationController
    require 'json'
    before_action :authenticate_user!

    def index
        BonitaApi.login
        @collection = Collection.find(params[:collection_id])
        @materiales = BonitaApi.get_variable('respuestaMateriales', @collection.id_i_bonita)

        if @materiales["value"] == "null"
            @providers = nil
        else
 
            @hash_result = JSON.parse(@materiales["value"])
            @providers = @hash_result["data"]["provedores"]
            respond_to do |format|
                format.html # busca la plantilla index.html.erb
                format.json { render json: @providers } # busca la plantilla index.json.erb
            end
            render locals: { collection: @collection }
        end        
      end

    def booking_canceled
        BonitaApi.login
        @collection = Collection.find(params[:collection_id])
        @materiales = BonitaApi.get_variable('nuevaRespuestaMateriales', @collection.id_i_bonita)
        @provider_id_canceleded = BonitaApi.get_variable('providerId', @collection.id_i_bonita)
        @hash_result = JSON.parse(@materiales["value"])
        @filtered_hash = @hash_result["data"]["provedores"].reject { |provedor| provedor["id"] == @provider_id_canceleded["value"].to_i }
        render :template => "providers/indexDos", :format => :html, :locals => {:providers =>  @filtered_hash, :collection => @collection}
    end

    def booking_delayed
        BonitaApi.login
        @collection = Collection.find(params[:collection_id])
        @nuevaReserva = BonitaApi.get_variable('estaApi', @collection.id_i_bonita)
        @booking = JSON.parse(@nuevaReserva["value"])
        render :template => "providers/reservaDelay", :format => :html, :locals => {:booking =>  @booking, :collection => @collection}
    end

    def continuar_provedor
        @collection = Collection.find(params[:collection_id])
        #DateTime.now.advance(days: 5).to_s
        body = {
            "new_date": DateTime.now.advance(minutes: 2).to_s
        }.to_json 
        #seteo la variable con la nueva fecha de entrega
        BonitaApi.login

        BonitaApi.set_variable("fechaActualizada", "#{body}", "java.lang.String", @collection.id_i_bonita) 
        BonitaApi.set_variable("sigue", "true", "java.lang.Boolean", @collection.id_i_bonita)
        @search_task = BonitaApi.search_task(@collection.id_i_bonita, 'Analiza si sigue con el provedor')
        BonitaApi.assigned_task(@search_task)
        BonitaApi.complete_task(@search_task)
        redirect_to root_path , notice: "Se envio la nueva fecha de entrega"  
    end 

    def cambiar_provedor
        @collection = Collection.find(params[:collection_id])
        BonitaApi.login
        BonitaApi.set_variable("sigue", "false", "java.lang.Boolean", @collection.id_i_bonita)
        @search_task = BonitaApi.search_task(@collection.id_i_bonita, 'Analiza si sigue con el provedor')
        BonitaApi.assigned_task(@search_task)
        BonitaApi.complete_task(@search_task)
        redirect_to root_path , notice: "Se vuelve a consultar materiales a la API" 
    end 

end
  