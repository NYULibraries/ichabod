class NyucoresController < ApplicationController
  respond_to :html, :json
  # Convert blank values to nil in params when creating and updating
  # in order to not save empty array values when field is not nil but is an empty string (i.e. "")
  before_filter :blank_to_nil_params, :only => [:create, :update]

  def index
    @items = Nyucore.all
    respond_with(@items)
  end

  def show
    authorize! :show, params[:id]
    @item = Nyucore.find(params[:id])
    respond_with(@item)
  end

  def new
    @item = Nyucore.new
    authorize! :new, @item
    respond_with(@item)
  end

  def edit
    authorize! :edit, params[:id]
    @item = Nyucore.find(params[:id])
    respond_with(@item)
  end

  def create
    @item = Nyucore.new(item_params)
    authorize! :create, @item
    flash[:notice] = 'Item was successfully created.' if @item.save
    respond_with(@item)
  end

  def update
    authorize! :update, params[:id]
    @item = Nyucore.find(params[:id])
    flash[:notice] = 'Item was successfully updated.' if @item.update(item_params)
    respond_with(@item)
  end

  def destroy
    authorize! :destroy, params[:id]
    @item = Nyucore.find(params[:id])
    @item.destroy
    respond_with(@item, :location => nyucores_path)
  end

  private

  # Whitelist attrs
  def item_params
    params.require(:nyucore).permit(:title, :creator, :publisher, :identifier, :type, :available => [], :description=> [], :edition=> [], :series=> [], :version=> [], :date=> [], :format=> [], :language=> [], :relation=> [], :rights=> [], :subject=> [], :citation=> [])
  end

  # Convert blank values to nil values in params
  # in order to not save empty array values when field is not nil but is an empty string (i.e. "")
  def blank_to_nil_params
    params[:nyucore].merge!(params[:nyucore]){|k, v| v.blank? ? nil : v}
  end
end
