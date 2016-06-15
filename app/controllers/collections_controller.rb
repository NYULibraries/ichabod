class CollectionsController < ApplicationController
  include Blacklight::CatalogHelperBehavior
  include Blacklight::ConfigurationHelperBehavior

  respond_to :html, :json
  # Convert blank values to nil in params when creating and updating
  # in order to not save empty array values when field is not nil but is an empty string (i.e. "")
  before_action  :blank_to_nil_params, :only => [:create, :update]


  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.all
    respond_with(@collections)
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    authorize! :show, params[:id]
    @collection = Collection.find(params[:id])
    respond_with(@collection)
  end

  # GET /collections/new
  def new
    @collection = Collection.new
    authorize! :new, @collection
    respond_with(@collection)
  end

  # GET /collections/1/edit
  def edit
    authorize! :edit, params[:id]
    @collection = Collection.find(params[:id])
    respond_with(@collection)
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(collection_params)
    ensure_default_editors
    authorize! :create, @collection
    flash[:notice] = 'Collection was successfully created.' if @collection.save
    respond_with(@collection)
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    authorize! :update, params[:id]
    @collection = Collection.find(params[:id])
    flash[:notice] = 'Collection was successfully updated.' if @collection.update(collection_params)
    respond_with(@collection)
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  # can tighten up logic a bit, and require that collection size is exactly zero
  def destroy
    authorize! :destroy, params[:id]
    @collection = Collection.find(params[:id])
    if @collection.nyucores.size == 0
      @collection.destroy
      msg = 'Collection was successfully deleted.'
    else
      msg = 'Collection has associated records and can not be deleted'
    end
    flash[:notice] = msg
    redirect_to collections_url
  end

  def blank_to_nil_params
    params[:collection].merge!(params[:collection]){|k, v| v.blank? ? nil : v.is_a?(Array) ? v.reject{|c| c.empty? } : v}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:title, :identifier, :description, :discoverable, :rights, creator: [], publisher: [])
    end

     def ensure_default_editors
      @collection.set_edit_groups(["admin_group"],[]) if @collection.edit_groups.blank?
  end
end
