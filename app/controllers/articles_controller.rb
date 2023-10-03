class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1 or /articles/1.json
  def show
    @collection = Collection.find(params[:collection_id])
  end

  # GET /articles/new
  def new
    @collection = Collection.find(params[:collection_id])
    @article = Article.new 
  end

  # GET /articles/1/edit
  def edit
    @collection = Collection.find(params[:collection_id])
    @article = @collection.articles.find(params[:id])
  end

  # POST /articles or /articles.json
  def create
    @collection = Collection.find(params[:collection_id])
    @article = @collection.articles.build(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to collection_url(@collection), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    @collection = Collection.find(params[:collection_id])    
    respond_to do |format|
      if @article.update(article_params)
        #@article.photos.append(article_params[:photos])
        format.html { redirect_to collection_article_path(@collection, @article), notice: "Se modifico exitosamente." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    @collection = Collection.find(params[:collection_id])
    respond_to do |format|
      format.html { redirect_to collection_url(@collection), notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

  def article_params
    params.require(:article).permit(:model, :description, :category_id, :collection_id, material_ids: [], photos: [])
  end
end
