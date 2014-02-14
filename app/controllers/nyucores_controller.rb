class NyucoresController < ApplicationController
  respond_to :html, :json
  before_action :set_nyucore, only: [:edit, :update, :destroy]

  def index
    @nyucores = Nyucore.all
  end

  def show
    #authorize! :show, params[:id]
    @nyucore = Nyucore.find(params[:id])

    respond_with(@nyucore)
  end

  def new
    @nyucore = Nyucore.new
    respond_with(@nyucore)
  end


  def edit
    respond_with(@nyucore)
  end

  def create
    @nyucore = Nyucore.new(nyucore_params)

    flash[:notuce] = 'Item was successfully created.' if @nyucore.save
    respond_with(@nyucore)
  end

  def update
    #authorize! :update, params[:id]
    
    flash[:notuce] = 'Item was successfully updated.' if @nyucore.update(nyucore_params)
    respond_with(@nyucore)
  end

  def destroy
    #authorize! :destroy, params[:id]
    @nyucore.destroy
    respond_with(@nyucore) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nyucore
      @nyucore = Nyucore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nyucore_params
      params.require(:nyucore).permit(:title, :author => [])
    end
end
