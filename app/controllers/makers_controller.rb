class MakersController < ApplicationController
    before_action :authenticate_user!

    def index
        BonitaApi.login
        @collection = Collection.find(params[:collection_id])
        @makers = BonitaApi.get_variable('respuestaLugares', @collection.id_i_bonita)
        if @makers["value"] == "null"
            @makers = nil
        else
            @hash_result = JSON.parse(@makers["value"])
            @makers = @hash_result["data"]["makers"]
            respond_to do |format|
                format.html # busca la plantilla index.html.erb
                format.json { render json: @makers } # busca la plantilla index.json.erb
            end
            render locals: { collection: @collection }
        end        
      end


end
  