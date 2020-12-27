class MeasurementFilesController < ApplicationController
  before_action :set_measurement_file, only: [:destroy]

  def upload_for_measurement
    @file = MeasurementFile.new(measurement_file: params[:file])
    @file.token = params[:authenticity_token]
    if @file.save!
      respond_to do |format|
        format.json{ render :json => @file }
      end
    end
  end

  def destroy
    @measurement_file.destroy!
  end
  
  private

  def set_measurement_file
    @measurement_file = MeasurementFile.find_by(id: params[:id])
    if @measurement_file.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego pliku!"
    end
  end
end
