module RubyPost
  
  #Base class for labels in rubypost
  class BaseLabel < Object
    
    attr_writer :text, :position
  
    #You can set the text in the constructor.
    #At the moment you must use etex/btex for the
    #string to display correct.  This can be achieve
    #using latex("string").
    def initialize(t=nil, p=nil)
      @options = Array.new
      @text = t
      @position = p
      top
      self
    end
  
    def add_option(o)
      @options.push(o)
      self
    end
  
    #set the text for this label.  You can also use BaseLabel.text=
    def set_text(d)
      @text = d
      self
    end
    
    #set the text for this label.  You can also use BaseLabel.position=
    def set_position(d)
      @position = d
      self
    end
  
    #utility function to compile all the options
    def compile_options
      str = String.new
      @options.each { |o| str = str + ' ' + o.compile }
      return str
    end
  
    #macro for setting the colour of the draw command
    def colour(r,g,b)
      add_option(Colour.new(r,g,b))
      self
    end
  
    #macro for setting the colour of the draw command.
    #Spelt incorrectly.
    def color(r,g,b)
      colour(r,g,b)
    end
  
    #macro for scaling the draw command.  This is the
    #same as using add_option(Scale.new(s))
    def scale(s)
      add_option(Scale.new(s))
      self
    end
  
    #macro for translating the label.  This is the
    #same as using add_option(Translate.new(x,y))
    def translate(x,y)
      add_option(Translate.new(Pair.new(x,y)))
      self
    end
  
    #macro for rotating the label.  This is the
    #same as using add_option(Rotate.new(a))
    def rotate(a)
      add_option(Rotate.new(a))
      self
    end
    
    #place the text bellow the position.  Wraps the metapost
    #bot command for labels
    def bottom
      @place = "bot"
      self
    end
    def bot
      bottom
    end
    
    #place the text above the position.  Wraps the metapost
    #bot command for labels
    def top
      @place = "top"
      self
    end
    
    #place the text to the right of the position.  Wraps the metapost
    #bot command for labels
    def right
      @place = "rt"
      self
    end
    def rt
      right
    end
    
    #place the text to the left the position.  Wraps the metapost
    #bot command for labels
    def left
      @place = "lft"
      self
    end
    def lft
      left
    end
    
    #place the text to the upper left of the position.  Wraps the metapost
    #bot command for labels
    def top_left
      @place = "ulft"
      self
    end
    def ulft
      top_left
    end
    
    #place the text to the bottom left the position.  Wraps the metapost
    #bot command for labels
    def bottom_left
      @place = "llft"
      self
    end
    def llft
      bottom_left
    end
    
    #place the text to the upper right the position.  Wraps the metapost
    #bot command for labels
    def top_right
      @place = "urt"
      self
    end
    def urt
      top_right
    end
    
    #place the text to the bottom right the position.  Wraps the metapost
    #bot command for labels
    def bottom_right
      @place = "lrt"
      self
    end
    def lrt
      bottom_right
    end
    
  end
  

  #Wraps the metapost label command
  class Label < BaseLabel

    def compile
      'label.' + @place + '(' + @text.compile + ', ' + @position.compile + ') ' + compile_options + ";\n"
    end

  end

  #Wraps the metapost dotlabel command.  Places a dot a the position of the text
  #aswell as the text.
  class DotLabel < BaseLabel

    def compile
      'label.' + @place + '(' + @text.compile + ', ' + @position.compile + ') ' + compile_options + ";\n"
    end

  end

end
