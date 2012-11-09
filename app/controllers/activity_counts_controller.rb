class ActivityCountsController < ApplicationController
  def create
    archivo = params[:file]
    ac = JSON.parse(archivo.read)
    ac.each do |a|
      actcount = ActivityCount.new
      actcount.count = a["count"]
      actcount.time = a["time"]
      actcount.userid = params[:id]
      actcount.save
    end
    redirect_to user_path(params[:id]), notice: 'JSON subido exitosamente'
  end
end
