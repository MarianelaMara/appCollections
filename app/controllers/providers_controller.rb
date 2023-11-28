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


end
  