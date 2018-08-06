class AccessoriesController < ApplicationController
  before_action :set_accessory, except: [:new, :create, :index]

  def index
    if !params[:category].blank?
      @accessories = current_user.accessories.category(params[:category])
    else
      @accessories = current_user.accessories
    end
  end

  def new
    @firearm = Firearm.find(params[:firearm_id])
    @accessory = Accessory.new
  end

  def create
    @firearm = Firearm.find(params[:accessory][:firearm_id])
    @accessory = @firearm.accessories.create(accessory_params)
    if @accessory.save
      redirect_to firearm_path(@firearm)
    else
      params[:firearm_id] = @firearm.id
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    @accessory.update(accessory_params)

    redirect_to @accessory
  end

  def destroy
    @accessory.destroy

    redirect_to firearms_path
  end

  private

  def set_accessory
    @accessory = Accessory.find(params[:id])
  end

  def accessory_params
    params.require(:accessory).permit(:name, :category, :price, :purchase_date)
  end
end
