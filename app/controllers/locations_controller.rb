class LocationsController < ApplicationController
  def index
    # get all locations in the table locations
    @locations = Location.all
    @locations_json = @locations.to_json
  end

  def new
    # default: render ’new’ template (\app\views\locations\new.html.haml)
  end

  def create
    # create a new instance variable called @location that holds a Location object built from the data the user submitted
    @location = Location.new(params[:location])

    # if the object saves correctly to the database
    if @location.save
      # redirect the user to index
      redirect_to locations_path, notice: 'Lugar creado satisfactoriamente'
    else
      # redirect the user to the new method
      render action: 'new'
    end
  end

  def buscar
  end

  def convexo
    @location = Location.all
    @res = ConvexHul.calculate(@location)
    @perimetro = 0;
    (0..@res.length-2).each do |i|
      @perimetro+=distance(@res[i],@res[i+1])
    end
    @perimetro+=distance(@res[0],@res[-1])
    a=[]
    @casa=Location.find_by_name('Casa')
    @location.each do |l|
      a.push(distance(@casa,l))
    end
    @max = a.index(a.max)
  end

  def coincide
    @location = Location.all
    @loc = Location.new(params[:loc])
    @resultado = "No se encuentra cerca de una localizacion"
    @location.each do |l|
       if inside?(l,@loc,100)
         @resultado = l.name
       end
    end

  end



  def edit
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])
  end

  def update
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])

    # if the object saves correctly to the database
    if @location.update_attributes(params[:location])
      # redirect the user to index
      redirect_to locations_path, notice: 'Location was successfully updated.'
    else
      # redirect the user to the edit method
      render action: 'edit'
    end
  end

  def destroy
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])

    # delete the location object and any child objects associated with it
    @location.destroy

    # redirect the user to index
    redirect_to locations_path, notice: 'Location was successfully deleted.'
  end

  def destroy_all
    # delete all location objects and any child objects associated with them
    Location.destroy_all

    # redirect the user to index
    redirect_to locations_path, notice: 'All locations were successfully deleted.'
  end

  def show
    # default: render ’show’ template (\app\views\locations\show.html.haml)
  end

# Funciones para la tarea
def toRadians(degree)
  return degree*Math::PI/180
end

def distance(l1,l2)
r = 6371
#distancia del radio de la tierra en km
deltaLat = toRadians (l2.latitude-l1.latitude)
deltaLon = toRadians (l2.longitude-l1.longitude)
lat1 = toRadians(l1.latitude)
lat2 = toRadians(l2.latitude)
a = Math.sin(deltaLat/2)*Math.sin(deltaLat/2)+Math.cos(lat1)*Math.cos(lat2)*Math.sin(deltaLon/2)*Math.sin(deltaLon/2)
c = 2*Math.atan2(Math.sqrt(a),Math.sqrt(1-a))
d = r*c*1000
end

def inside?(l1,l2,r)
  d=distance(l1,l2)
  if d.to_i <= r
    output=true
  else
    output=false
  end
  return output
end
 module ConvexHul
       # after graham & andrew
         def self.calculate(points)
            lop = points.sort_by { |p| p.latitude }
            left = lop.shift
            right = lop.pop
            lower, upper = [left], [left]
           lower_hull, upper_hull = [], []
           det_func = determinant_function(left, right)
           until lop.empty?
             p = lop.shift
             ( det_func.call(p) < 0 ? lower : upper ) << p
           end
           lower << right
           until lower.empty?
             lower_hull << lower.shift
            while (lower_hull.size >= 3) &&
                 !convex?(lower_hull.last(3), true)
               last = lower_hull.pop
               lower_hull.pop
               lower_hull << last
             end
           end
           upper << right
           until upper.empty?
             upper_hull << upper.shift
             while (upper_hull.size >= 3) &&
                !convex?(upper_hull.last(3), false)
               last = upper_hull.pop
               upper_hull.pop
               upper_hull << last
             end
           end
           upper_hull.shift
           upper_hull.pop
           lower_hull + upper_hull.reverse
         end
         
         private
      
         def self.determinant_function(p0, p1)
           proc { |p| ((p0.latitude-p1.latitude)*(p.longitude-p1.longitude))-((p.latitude-p1.latitude)*(p0.longitude-p1.longitude)) }
         end
         
         def self.convex?(list_of_three, lower)
           p0, p1, p2 = list_of_three
           (determinant_function(p0, p2).call(p1) > 0) ^ lower
         end
         
       end
end