class MakersController < ApplicationController
    before_action :authenticate_user!

    def index
        file = File.read(Rails.root.join("public", "makers.json"))
        @makers = JSON.parse(file)["data"]["Makers"]
        respond_to do |format|
            format.html # busca la plantilla index.html.erb
            format.json { render json: @makers } # busca la plantilla index.json.erb
          end
      end


end
  