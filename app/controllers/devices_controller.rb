class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  def index
    @devices = current_user.devices.includes(:sensors)
  end

  def new
    @device = Device.new
  end

  def edit
  end

  def show
    @sensors = @device.sensors.includes(:sensor_data)
    @sensor_to_show = params[:sensor_to_show].present? ? Sensor.find(params[:sensor_to_show]) : @sensors.first
  end

  def update
    if @device.update(device_params)
      redirect_to @device, notice: t('successful.messages.updated', model: Device.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @device = Device.new(device_params)

    if @device.save
      redirect_to @device, notice: t('successful.messages.created', model: Device.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @device.destroy
    redirect_to devices_path, notice: t('successful.messages.deleted', model: Device.model_name.human)
  end

  private
  def set_device
    @device = Device.find(params[:id])
    authorize_resource(@device)
  end

  def device_params
    params.require(:device).permit(:name, :description, sensors: [:name, :sensor_type, :charts]).merge(user: current_user)
  end
end
