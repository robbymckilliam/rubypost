
module RubyPost

#return the string s wrapped in btex etex
def latex(s)
  'btex ' + s + ' etex'
end

#options for rubypost drawables.  These wrap metapose commands 
#such as 'withpen', 'scaled' and etc
class Option < Object
end

#Can insert pure metapost option commands here.
class CustomOption < Option
  def initialize
    @command = String.new
  end
  
  def initialize(c=Sting.new)
    @command = c
  end
  
  def compile
    @command.compile
  end
  
end

#wrapper for the metapost withcolor command
#Except colour is now spelt correctly.
class Colour < Option
  
  attr :r
  attr :g
  attr :b
  
  def initialize(r=0,g=0,b=0)
    @r = r
    @g = g
    @b = b
  end
  
  def compile
    'withcolor' + '(' + @r.to_s + ',' + @g.to_s + ',' + @b.to_s + ')'
  end
  
end

#incorrectly spelt Colour alias
class Color < Colour
end


#wraps the metapost withpen command
class Pen < Option
  
  attr_writer :pen_type, :scale
  
  def initialize(pt='pencircle', scale  = 1)
    @pen_type = pt
    @scale = scale
  end
  
  def compile
    'withpen ' + @pen_type + ' scaled ' + @scale.compile
  end
  
end

#base class for options related to paths
class PathOption < Option
end

#dased path
#there are a plethora of dashing options.  Only implemented
#evenly at present.
class Dashed < PathOption
  
  def initialize(t='evenly')
      @type = t
  end
  
  #evenly dashed line
  def evenly
    @type = 'evenly'
    self
  end
  
  #dahed line with dots inbetween dashes
  def withdots
    @type = 'withdots'
    self
  end
  
  #set the type with the metapost command s.
  def type(s)
    @type = s
    self
  end
  
  def compile
    'dashed ' + @type
  end
  
end

#Wrapped the scaled metapost command.
#Resizes the drawable.
class Scale < Option
  
  attr_writer :scale
  
  def initialize(scale=1)
    @scale = scale
  end
  
  def compile
    'scaled ' + @scale.compile
  end
  
end

#Scale alias
class Scaled < Scale
end

#Wraps the rotated metapost command
class Rotate < Option
  
  attr_writer :degrees
  
  def initialize(degrees=0)
    @degrees = degrees
  end
  
  #set the angle in radiians
  def radians=(rads)
    @degrees = 180.0*rads/Math::PI
    self
  end
  
  def compile
    'rotated ' + @degrees.to_s
  end
  
end

#Rotate alias
class Rotated < Rotate
end

#Wraps the metapose shifted command. <br>
#The translation @t is specifed by a Pair
class Translate < Option
  
  attr_writer :t
  
  def initialize(p=Pair.new)
    @t = p
  end
  
  def compile
    'shifted ' + @t.compile
  end
  
end

#Translate alias
class Shifted < Translate
end
  
#Translate alias
class Shift < Translate
end

end