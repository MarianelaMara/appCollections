class BookingsController < ApplicationController
require 'json'

    def create
        @collection = Collection.find(params["collection_id"])
        @materials = Material.find_by_sql(["SELECT materials.name, SUM(article_materials.quantity) AS total_quantity, MAX(article_materials.presupuesto) AS max_presupuesto FROM materials JOIN article_materials ON materials.id = article_materials.material_id JOIN articles ON article_materials.article_id = articles.id JOIN collections ON articles.collection_id = collections.id WHERE collections.id = ? GROUP BY materials.name", params["collection_id"]])
        materiales_seleccionados = params["selected_provisions"].map { |string| JSON.parse(string) }
        #eligio todos los materiales que tiene que reservar
        if @materials.all? { |material| materiales_seleccionados.any? { |hash| hash["material"]["name"] == material.name.downcase } }
            #saca el material que va a tardar mas en ser entregado
            mayor = JSON.parse(materiales_seleccionados.max_by { |hash| hash["delivery_time"] }.to_json)
            #saca el material que va a tardar menos en ser entregado
            menor = JSON.parse(materiales_seleccionados.min_by { |hash| hash["delivery_time"] }.to_json)
            start_date = Date.today + menor["delivery_time"]
            end_date = (Date.today + mayor["delivery_time"]) + @collection.manufacturing_lead_time
            jsonLugares = {
                "start_date": start_date,
                "end_date": end_date
            }.to_json  
            #---------------------------------------------------------------
            BonitaApi.login
            #seteo la variable "elegioMateriales"
            BonitaApi.set_variable("eligioMateriales", "true", "java.lang.Boolean", @collection.id_i_bonita)
            #seteo la variable "consultaLugares" con las fechas para que consulte los lugares de fabricacion
            BonitaApi.set_variable("consultaLugares", "#{jsonLugares}", "java.lang.String", @collection.id_i_bonita)
            @current_task = BonitaApi.current_task(@collection.id_i_bonita)
            BonitaApi.assigned_task(@current_task)
            BonitaApi.complete_task(@current_task) 
            #----------------------------------------------------------
            #seteo la variable "reservarMateriales" con el json para reservar en la api

            materials = Material.find_by_sql(["SELECT materials.name, SUM(article_materials.quantity) AS total_quantity FROM materials JOIN article_materials ON materials.id = article_materials.material_id JOIN articles ON article_materials.article_id = articles.id JOIN collections ON articles.collection_id = collections.id WHERE collections.id = ? GROUP BY materials.name", params["collection_id"]])
            json = {
                "materials": materiales_seleccionados.map do |m|
                    resp = @materials.find { |e| e.name.downcase == m["material"]["name"] }
                    {
                        "provider_type": "provider",
                        "provider_id": m["provider_id"],
                        "start_date": Date.today + m["delivery_time"] ,
                        "end_date": Date.today + m["delivery_time"] ,
                        "quantity": resp.total_quantity,
                        "material": m["material"]["name"],
                        "delivery_place":  ""
                    }
                end
            }.to_json  
            BonitaApi.set_variable("reservarMateriales", "#{json}", "java.lang.String", @collection.id_i_bonita)
            #setear una variable con las fecha de entrega para el Timer
            delivery_times = materiales_seleccionados.map { |m| Date.today + m["delivery_time"] }

            fechas = {
                "fecha": {
                "bonita": @collection.id_i_bonita,
                "arreglo": delivery_times
                }
            }.to_json 
            BonitaApi.set_variable("fechaEntrega", "#{delivery_times.min}", "java.lang.String", @collection.id_i_bonita) 
            BonitaApi.set_variable("fechasTimer", "#{fechas}", "java.lang.String", @collection.id_i_bonita)   
            BonitaApi.set_variable("id", "#{@collection.id_i_bonita}", "java.lang.Integer", @collection.id_i_bonita)         
          

            @collection.esperar_resultados_lugares
            redirect_to root_path , alert: "Debes elegir un lugar de fabricación para completar la reserva"
        else
            @collection.enviar_a_revision
            redirect_to root_path , alert: "No se seleccionaron todos los materiales solicitados, se vuelve a enviar la colección a revisión para cambiar parámetros de búsqueda"
        end 
    end 

    def create_bookings_makers

        @collection = Collection.find(params[:collection_id])
        #busco en bonita la fechas consulto de lugares para reservar
        @consultaLugares = BonitaApi.get_variable('consultaLugares', @collection.id_i_bonita)
        consultaLugaresValue = JSON.parse(@consultaLugares["value"])
        #obtengo los datos del lugar que selecciono
        maker = JSON.parse(params["selected_makers "][0])

        reservaLugares = {
            "provider_type": "maker",
            "provider_id": maker["id"],
            "start_date": consultaLugaresValue["start_date"] ,
            "end_date": consultaLugaresValue["end_date"] 
        }.to_json 
        #seteo la variable "reservarLugar" para que reserve el lugar bonita
        BonitaApi.set_variable("reservarLugar", "#{reservaLugares}", "java.lang.String", @collection.id_i_bonita)
        #seteo la variable "hayDisponibilidad" ya que eligio lugar      
        BonitaApi.set_variable("hayDisponibilidad", "true", "java.lang.Boolean", @collection.id_i_bonita)
        #seteo la variable "reservarMateriales" para hacer la reserva final de los materiales pero lo hago modificando la que esta en bonita que faltaba el lugar de fabricacion de donde deben entregarse los materiales
        @reservarMateriales = BonitaApi.get_variable('reservarMateriales', @collection.id_i_bonita)
        reservarMaterialesValue = JSON.parse(@reservarMateriales["value"])
        reservarMaterialesValue["materials"].map do |reserva|
            reserva["delivery_place"] = maker["address"]
        end
        BonitaApi.set_variable("reservarMateriales", "#{reservarMaterialesValue.to_json}", "java.lang.String", @collection.id_i_bonita)
        #pido la tarea pendiente y la finalizo 
        @current_task = BonitaApi.current_task(@collection.id_i_bonita)
        BonitaApi.assigned_task(@current_task)
        BonitaApi.complete_task(@current_task) 
        #pasar de estado  la colecion
        @collection.esperar_entregas
        redirect_to root_path
    end
end
  