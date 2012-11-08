class UsersController < ApplicationController

  def index
    # get all users in the table locations
    @coordenadas=GpsSamples.all
    @Json=@coordenadas.to_json
    @users = User.all
    
  end


  def new
    # default: render ’new’ template (\app\views\locations\new.html.haml)
  end


  def create
    # create a new instance variable called @user that holds a Location object built from the data the user submitted
    @user = User.new(params[:user])
    # if the object saves correctly to the database
    if @user.save
      # redirect the user to index
      redirect_to users_path, notice: 'Usuario creado satisfactoriamente'
    else
      # redirect the user to the new method
      render action: 'new'
    end
  end



  def show
    # default: render ’show’ template (\app\views\locations\show.html.haml)
    @user = User.find(params[:id])
    @coordenadas=GpsSamples.find_all_by_iduser(params[:id])
    @Json=@coordenadas.to_json
  end


  def destroy
    # find only the location that has the id defined in params[:id]
    @user = User.find(params[:id])
    # delete the location object and any child objects associated with it
    @user.destroy
    # redirect the user to index
    redirect_to users_path, notice: 'Usuario borrado satisfactoriamente'
  end



end




