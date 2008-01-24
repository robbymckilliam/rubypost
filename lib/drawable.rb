require 'matrix'
#require 'vector'


module RubyPost

#rubypost drawable
#base class for anything that actually gets drawn on a figure
class Drawable < Object
  
  attr_reader :draw_type
  
  def initialize
    @options = Array.new
    @draw_type = 'draw'
  end
  
  #normal path draw
  def draw
    @draw_type = 'draw'
    self
  end
  
  #fill the path
  def fill
    @draw_type = 'fill'
    self
  end
  
  #arrowhead at end of the path
  def arrow
    @draw_type = 'drawarrow'
    self
  end
  
  #arrowhead at both ends
  def dblarrow
    @draw_type = 'drawdblarrow'
    self
  end
  
  def add_option(o)
    @options.push(o)
    self
  end
  
  #utility function to compile all the options
  def compile_options
    str = String.new
    @options.each { |o| str = str + ' ' + o.compile }
    return str
  end
  
  #macro for setting the colour of a drawable
  def colour(r,g,b)
    add_option(Colour.new(r,g,b))
    self
  end
  
  #macro for setting the colour of a drawable.
  #Spelt incorrectly.
  def color(r,g,b)
    colour(r,g,b)
  end
  
  #macro for scaling a drawable.  This is the
  #same as using add_option(Scale.new(s))
  def scale(s)
    add_option(Scale.new(s))
    self
  end
  
  #macro for translating a drawable.  This is the
  #same as using add_option(Translate.new(x,y))
  def translate(x,y)
    add_option(Translate.new(x,y))
    self
  end
  
  #macro for rotating a drawable.  This is the
  #same as using add_option(Rotate.new(a))
  def rotate(a)
    add_option(Rotate.new(a))
    self
  end
  
end

#wrapper for the metapost picture
#pictures are collection of drawables
class Picture < Drawable
  
  attr_writer :name
  
  #store a unique picture name unless incase it was not specified.
  @@default_name = 0
  
  #intialise a picture with it's name, use a string!
  def initialize(name="picture_number" + @@default_name.to_s)
    super()
    @name = name
    @drawables = Array.new
    @@default_name = @@default_name + 1
    @@picture_precompiler.add_picture(self)
  end
  
  def add_drawable(d)
    @drawables.push(d)
  end
  
  #creates the definition of the picture that goes
  #at the start of the file
  def precompile
    str = "picture " + @name + ";\n"
    @drawables.each do |d| 
      str = str + d.draw_type + ' ' + d.compile +  "\n"
    end
    str = str + @name + " := currentpicture; currentpicture := " + @@org_picture + ";\n"
  end
  
  def compile
    @name.compile + compile_options + ";\n"
  end
  
end

#A custom drawable.  Send it a metapost string
class CustomDrawable < Drawable
  
  attr_writer :command
  
  def initialize(c=String.new)
    super()
    @command = c
  end
  
  def compile
    @command.compile + compile_options + ";\n"
  end
  
end

#Cartesion point.
class Pair < Drawable
  
  attr  :x
  attr  :y
  
  #Can set the value and individual scales of the x and y point 
  def initialize(x=0,y=0)
    super()
    @x = x
    @y = y
  end
  
  def compile
    '(' + @x.compile + ', ' + @y.compile  + ')'
  end
  
  #returns the addition of the pairs
  def +(p)
    Pair.new(@x + p.x, @y + p.y)
  end
  
  #returns the subtraction of the pairs
  def -(p)
    Pair.new(@x - p.x, @y - p.y)
  end
  
  #returns the pair multiplied by a scalar
  def *(n)
    Pair.new(@x*n, @y*n)
  end
  
  #returns the pair divided by a scalar
  def /(n)
    Pair.new(@x/n, @y/n)
  end
    
  #returns true if the pairs are equal
  def ==(p)
    @x == p.x && @y == p.y 
  end
  
end

#sequence of pairs connected as a metapost path
class Path < Drawable
  
  def initialize
    super
    @p = Array.new
    straight
  end
  
  def add_pair(p)
    @p.push(p)
  end
  
  #returns a pair that is the centroid of the pairs
  #of this path
  def center(p)
    ret = Pair.new
    @p.each { |p| ret = ret + p }
    return ret/p.length
  end
  
  #reverse the path. <br> 
  #Note, this reverses the pairs that have so far
  #been added.  Anything added after calling reverse
  #will be appended to the end of the array as usual
  def reverse
    @p = @p.reverse
    self
  end
  
  #set the path to have straight line segments
  def straight
    @line_type = '--'
    self
  end
  
  #set the path to have curved line segments
  def curved
    @line_type = '..'
    self
  end
  
  def compile
    str = '('
    (@p.length-1).times do |i|
      str = str + @p[i].compile + @line_type
    end
    str = str + @p[-1].compile + ')'
    str = str + compile_options + ";"
    str
  end

end

#Wraps teh metapost unitsquare command
class Square < Path
  
  def initialize
    super
    @p.push(Pair.new(-0.5,-0.5))
    @p.push(Pair.new(-0.5,0.5))
    @p.push(Pair.new(0.5,0.5))
    @p.push(Pair.new(0.5,-0.5))
    @p.push('cycle')
  end
  
end

#Wraps the metapost fullcircle command
class Circle < Drawable
  
  def initialize
    super
  end
  
  def compile
    'fullcircle ' + compile_options + ";\n"
  end
  
end

end