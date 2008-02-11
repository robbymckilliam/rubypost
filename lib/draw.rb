module RubyPost
  
  #base class for the commands that draw drawables.
  #ie. draw, fill, drawarrow and drawdblarrow
  class BaseDrawCommand < Object
  
    attr_writer :drawable
  
    #You can set the drawable in the constructor
    def initialize(d=nil)
      @options = Array.new
      @drawable = d
      self
    end
  
    def add_option(o)
      @options.push(o)
      self
    end
  
    #set the drawble to for this draw command.
    #There is only one drawable per command.
    #You can alternatively use BaseDrawCommand::drawable=
    def set_drawable(d)
      @drawable = d
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
  
    #macro for translating the draw command.  This is the
    #same as using add_option(Translate.new(x,y))
    def translate(x,y)
      add_option(Translate.new(Pair.new(x,y)))
      self
    end
  
    #macro for rotating the draw command.  This is the
    #same as using add_option(Rotate.new(a))
    def rotate(a)
      add_option(Rotate.new(a))
      self
    end
  
  end

  #implements the metapost draw command
  class Draw < BaseDrawCommand
  
    def compile
      'draw ' + @drawable.compile + ' ' + compile_options + ";\n"
    end
  
  end

  #implements the metapost fill command
  class Fill < BaseDrawCommand
  
    def compile
      'fill ' + @drawable.compile + ' ' + compile_options + ";\n"
    end
  
  end

  #implements the metapost drawarrow command
  class Arrow < BaseDrawCommand
  
    def compile
      'drawarrow ' + @drawable.compile + ' ' + compile_options + ";\n"
    end
  
  end

  #implements the metapost drawdblarrow command
  class DoubleArrow < BaseDrawCommand
  
    def compile
      'drawdblarrow ' + @drawable.compile + ' ' + compile_options + ";\n"
    end
  
  end

  #alias DoubleArrow, implements the metapost drawdblarrow command
  class DblArrow < DoubleArrow
  end
  
  
  #This wraps the metapost clipping command.  This needs
  #to be used with a little care.  It will clip everything that
  #has been previously added to the picture when you add it.
  #Anything that gets drawn after clipping, wont be clipped.
  #This is in keeping with the way that metapost works,
  #however most other objects in rubypost the order inwhich
  #they are added has no effect (other than overlay).
  # <\br>
  #Clip only kind of fits as a draw command.  It's doesn't need colours
  #and stuff.  This is the best place to put it at the moment, but it
  #probably should inheret something else.
  class Clip < BaseDrawCommand
	
	attr_writer :path, :picture
  
	def initialize(path=nil, pic='currentpicture')
		super()
		@picture = pic
		@path = path
	end
	
	#set the clipping path
	def set_path(p)
		@path = p
	end
	
	#set the picture to clip.  Defaults to 'currentpicture' see a metapost guide
	def set_picture(p='currentpicture')
		@picture = p
	end
	
	def compile
		"clip " + @picture.compile + " to " + @path.compile + ' ' + compile_options + ";\n"
	end
	
  end


end
