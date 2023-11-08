class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only: %i[ show edit update destroy ]

  # GET /collections or /collections.json
  def index 
    if Current.user.engineer?
      @collections = Collection.where(aasm_state: "in_review")
    elsif Current.user.designer?
      @collections = Collection.where(owner_id: current_user.id, aasm_state: "started")
    end 
  end

  # GET /collections/1 or /collections/1.json
  def show
    #@collections = Collection.where(owner_id: current_user.id)

    @collection = Collection.find(params[:id]) # Busca la colección por su id 
   #@materials = Material.find_by_sql(["SELECT materials.name, SUM(article_materials.quantity) AS total_quantity FROM materials JOIN article_materials ON materials.id = article_materials.material_id JOIN articles ON article_materials.article_id = articles.id JOIN collections ON articles.collection_id = collections.id WHERE collections.id = ? GROUP BY materials.name", @collection.id]) # Ejecuta la consulta y guarda el resultado en @materials 
    @materials = Material.find_by_sql(["SELECT materials.name, SUM(article_materials.quantity) AS total_quantity, MAX(article_materials.presupuesto) AS max_presupuesto FROM materials JOIN article_materials ON materials.id = article_materials.material_id JOIN articles ON article_materials.article_id = articles.id JOIN collections ON articles.collection_id = collections.id WHERE collections.id = ? GROUP BY materials.name", @collection.id])
  end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections or /collections.json
  def create
    #Se loguea en bonita
    BonitaApi.login
    #pide a bonita el id del proceso que esta corriendo en su servidor llamado 'coleccion'
    #este nombre es el que tiene en el diagrama de procesos
    process_id = BonitaApi.get_process_id('colection')
    #con el id inicia una instancia de proceso o caso
    @process_instance = BonitaApi.start_process(process_id)
    #pide la proxima tarea del caso
    @current_task = BonitaApi.current_task(@process_instance)
    # asigna la tarea 
    BonitaApi.assigned_task(@current_task)
    # @collection = Collection.new(collection_params.merge(process_id: process_id, instance_id: @process_instance['id']))
    @collection = Collection.new(collection_params)
    @collection.id_i_bonita = @process_instance["caseId"]
   # @collection.save

    respond_to do |format|
      if @collection.save
      #  BonitaApi.login
      #  process_id = BonitaApi.get_process_id('coleccion')
      #  @process_instance = BonitaApi.start_process(process_id)
        format.html { redirect_to collection_url(@collection), notice: "Collection was successfully created." }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1 or /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to collection_url(@collection), notice: "Collection was successfully updated." }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1 or /collections/1.json
  def destroy
    @collection.destroy

    respond_to do |format|
      format.html { redirect_to collections_url, notice: "Collection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

 def all_user
      @collection = Collection.find_by(owner_id: Current.user.id)
 end

 def end_collections  
  BonitaApi.login
 # id_task = BonitaApi.get_task(process_instance)
 # BonitaApi.end_collections(id_task)
  @collection = Collection.find( params[:collection_id])
  @collection.enviar_a_revision
  #como sabe que esta pendiente la tarea de definir pide la siguiente task del case
  BonitaApi.current_task(@collection.id_i_bonita)
  BonitaApi.complete_task(@res)
  redirect_to @collection
 end

 def end_revision
  BonitaApi.login
  @collection = Collection.find( params[:collection_id])
  @current_task = BonitaApi.current_task(@collection.id_i_bonita)
  BonitaApi.assigned_task(@current_task)
  #seteo variables del proceso
  # BonitaApi.set_variable("viable", "true", "java.lang.Boolean", @collection.id_i_bonita)
  # BonitaApi.set_variable("redefinir", "false", "java.lang.Boolean", @collection.id_i_bonita)
  @materials = Material.find_by_sql(["SELECT materials.name, SUM(article_materials.quantity) AS total_quantity, MAX(article_materials.presupuesto) AS max_presupuesto FROM materials JOIN article_materials ON materials.id = article_materials.material_id JOIN articles ON article_materials.article_id = articles.id JOIN collections ON articles.collection_id = collections.id WHERE collections.id = ? GROUP BY materials.name", @collection.id])
  debugger
  #finalizo la tarea 
  #@res = BonitaApi.complete_task(@current_task)

  redirect_to @collection

 end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.find(params[:id])
    end
   # ...

    # Only allow a list of trusted parameters through.
    def collection_params
      params.require(:collection).permit(:name, :owner_id, :manufacturing_lead_time, :estimated_release_date, :budget, articles_attributes: [:id, :model, :category_id, :description]) # permite los atributos de los artículos anidados
    end

end
