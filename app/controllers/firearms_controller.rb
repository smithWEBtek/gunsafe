class FirearmsController < ApplicationController
  before_action :require_login
  before_action :set_firearm, except: [:index, :new, :create]

  def index
    if @current_user.firearms.count == 0
      redirect_to new_firearm_path
    end
    
    # if !params[:category].blank?
    #   @firearms = @current_user.firearms.category(params[:category])
    # else
    #   @firearms = @current_user.firearms
    # end

    @rifles = @current_user.firearms.category("Rifle")
    @pistols = @current_user.firearms.category("Pistol")
    @shotguns = @current_user.firearms.category("Shotgun")
  end

  def new
    @firearm = Firearm.new
    @firearm.accessories.build
  end

  def create
    @firearm = current_user.firearms.build(firearm_params)
    if @firearm.save
      redirect_to firearms_path
    else
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    @firearm.update(firearm_params)
    if @firearm.save
      redirect_to @firearm
    else
      render :edit
    end
  end

  def destroy
    @firearm.destroy

    redirect_to firearms_path
  end

  def info
    firearm = Firearm.find(params[:id])
    render json: firearm.to_json
  end

  private

    def firearm_params
      params.require(:firearm).permit(
        :make, 
        :model, 
        :caliber, 
        :category, 
        :serial_number, 
        :price, 
        :purchase_date, 
        accessory_ids: [],
        accessories_attributes: [
          :name,
          :price,
          :purchase_date,
          :category
          ]
        )
    end

    def set_firearm
      @firearm = Firearm.find(params[:id])
      if @firearm.user != current_user
        redirect_to firearms_path
      end 
    end
end
