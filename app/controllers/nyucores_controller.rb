class NyucoresController < ApplicationController
  #needed to get current_per_page value for destroy method redirect
  include Blacklight::CatalogHelperBehavior
  include Blacklight::ConfigurationHelperBehavior
  
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
    respond_with(@item, location: catalog_path(@item))
  end

  def destroy
    authorize! :destroy, params[:id]
    @item = Nyucore.find(params[:id])
    @item.destroy
    flash[:notice] = "Item was successfully deleted."
    unless session[:search].nil? 
     get_query_params_from_session
    end
    redirect_to root_url @query_params
  end

  private

  # Whitelist attrs
  def item_params
    params.require(:nyucore).permit(:identifier, :restrictions, title: [], creator: [], publisher: [], type: [], available: [], description: [], edition: [], series: [], version: [], date: [], format: [], language: [], relation: [], rights: [], subject: [], citation: [])
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

  private
  
  #if the search parameters are saved in session return to the search results page
  def get_query_params_from_session
    begin
      unless  searches_from_history.find(session[:search]['id'].to_i).nil?
        @query_params = searches_from_history.find(session[:search]['id'].to_i).query_params
        get_page_number
      end
    rescue => e
      logger.error "Unable to restore search from session due to the following error: #{e}"
    end
  end


  #Calculates on what page of the search reults we should return.
  # To calculate the landing page number we need 2 parameters: order number of the deleted document
  #and the number of results per page. If any of this parameters is not defined we will return to the first page.
  def get_page_number
    if page_parameters_defined?
      @query_params[:page] = params[:document_counter].to_i==1 ? 1 : ((params[:document_counter].to_f-1)/current_per_page).ceil
    end
 end
 
  #If parameters needed to calculate the landing page are not defined- return to the search results page
  def page_parameters_defined?
   if params[:document_counter].nil? || current_per_page==0
        @query_params[:page]=1
        logger.warn "document_counter or current_per_page parameters are not defined, return to the first search page"
        false
    else
        true
    end
  end
  binding.pry
end
