class NyucoresController < ApplicationController
  respond_to :html, :json
  # Convert blank values to nil in params when creating and updating
  # in order to not save empty array values when field is not nil but is an empty string (i.e. "")
  before_action :blank_to_nil_params, :only => [:create, :update]

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
    # Ensure that there are default editors before you create the item
    ensure_default_editors
    authorize! :create, @item
    flash[:notice] = 'Item was successfully created.' if @item.save
    respond_with(@item)
  end

  def update
    authorize! :update, params[:id]
    @item = Nyucore.find(params[:id])
    flash[:notice] = 'Item was successfully updated.' if @item.update(item_params)
    redirect_to(catalog_url(:id=>@item.id))
  end

  def destroy
    authorize! :destroy, params[:id]
    @item = Nyucore.find(params[:id])
    @item.destroy
    search_params=request.params['search_params']
    flash[:notice] = 'Item was successfully deleted.'
    redirect_to(search_action_url  search_params) 
  end

  private

  # Whitelist attrs
  def item_params
    params.require(:nyucore).permit(:identifier, title: [], creator: [], publisher: [], type: [], available: [], description: [], edition: [], series: [], version: [], date: [], format: [], language: [], relation: [], rights: [], subject: [], citation: [])
  end

  def ensure_default_editors
    @item.set_edit_groups(["admin_group"],[]) if @item.edit_groups.blank?
  end

  # Convert blank values to nil values in params
  # in order to not save empty array values when field is not nil but is an empty string (i.e. "")
  # Added the reject statement to get rid of blank values for array params
  def blank_to_nil_params
    params[:nyucore].merge!(params[:nyucore]){|k, v| v.blank? ? nil : v.is_a?(Array) ? v.reject{|c| c.empty? } : v}
  end
end
