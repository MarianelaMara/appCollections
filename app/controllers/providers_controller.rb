class ProvidersController < ApplicationController
    before_action :authenticate_user!

    def index
        file = File.read(Rails.root.join("public", "providers.json"))
        @providers = JSON.parse(file)["data"]["provedores"]
        respond_to do |format|
            format.html # busca la plantilla index.html.erb
            format.json { render json: @providers } # busca la plantilla index.json.erb
          end
      end


end
  