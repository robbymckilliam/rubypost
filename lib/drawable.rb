require 'matrix'
#require 'vector'


module RubyPost

  #rubypost drawable
  #base class for anything that actually gets drawn on a figure
  class Drawable < Object
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
      @draw_commands = Array.new
      @@default_name = @@default_name + 1
      @@picture_precompiler.add_picture(self)
    end
  
    def add_drawable(d)
      @draw_commands.push(d)
    end
  
    #creates the definition of the picture that goes
    #at the start of the file
    def precompile
      str = "picture " + @name + ";\n"
      @draw_commands.each do |d| 
        str = str + d.compile +  "\n"
      end
      str = str + @name + " := currentpicture; currentpicture := " + @@org_picture + ";\n"
    end
  
    def compile
      @name.compile
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
      @command.compile
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
  
    attr_writer :line_type
    
    def initialize
      super()
      @p = Array.new
      straight
    end
  
    def add_pair(p)
      @p.push(p)
      self
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
      str + @p[-1].compile + ')'
    end
    
    def clone
      c = Path.new
      @p.each{ |i| c.add_pair(i) }
      c.line_type = @line_type
      c
    end

  end

  #Wraps teh metapost unitsquare command
  class Square < Path
  
    def initialize
      super()
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
      super()
    end
  
    def compile
      'fullcircle'
    end
  
  end

end