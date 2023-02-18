class SensorsController < ApplicationController
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]

  def index
    @sensors = current_user.sensors
  end

  def new
    @sensor = Sensor.new
  end

  def edit
  end

  def show
    @tab_content = params[:tab_content] || 'charts'
    respond_to do |format|
      format.html
      format.json do
        start_date = params[:timestamp_start].blank? ? Time.current.yesterday : Time.at(params[:timestamp_start].to_i)
        end_date   = params[:timestamp_end].blank?  ? Time.current : Time.at(params[:timestamp_end].to_i)

        sensor_data = @sensor.sensor_data.where("created_at >= ? AND created_at <= ?", start_date, end_date ).order(created_at: :asc)
        render json: SerializeSensorData.new(@sensor, sensor_data).serialize
      end
    end
  end

  def update
    if @sensor.update(sensor_params)
      redirect_to @sensor, notice: t('successful.messages.updated', model: Sensor.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @sensor = Sensor.new(sensor_params)

    if @sensor.save
      redirect_to @sensor, notice: t('successful.messages.created', model: Sensor.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Sensor.transaction do
      @sensor.sensor_data.delete_all
      @sensor.destroy
    end
    redirect_to sensors_path, notice: t('successful.messages.destroyed', model: Sensor.model_name.human)
  end

  private
  def set_sensor
    @sensor = Sensor.find(params[:id])
    authorize_resource(@sensor)
  end

  def sensor_params
    params.require(:sensor).permit(:name, :description, :sensor_type).merge(user: current_user)
  end
end
