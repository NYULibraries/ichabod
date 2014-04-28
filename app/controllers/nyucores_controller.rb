class NyucoresController < ApplicationController
  respond_to :html, :json
  before_action :set_item, only: [:edit, :update]

  def index
    @items = Nyucore.all
  end

  def show
    #authorize! :show, params[:id]
    @item = Nyucore.find(params[:id])

    respond_with(@item)
  end

  def new
    @item = Nyucore.new
    respond_with(@item)
  end

  def edit
    respond_with(@item)
  end

  def create
    @item = Nyucore.new(item_params)

    flash[:notice] = 'Item was successfully created.' if @item.save
    respond_with(@item)
  end

  def update
    #authorize! :update, params[:id]
    
    flash[:notice] = 'Item was successfully updated.' if @item.update(item_params)
    respond_with(@item)
  end

  def destroy
    #authorize! :destroy, params[:id]
    @item = Nyucore.find(params[:id])
    @item.destroy
    respond_with(@item, :location => nyucores_path) 
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Nyucore.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:nyucore).permit(:title, :creator, :publisher, :identifier, :available, :type, :description, :edition, :series, :version, :date, :format, :language, :relation, :rights, :subject, :citation)
  end
end
