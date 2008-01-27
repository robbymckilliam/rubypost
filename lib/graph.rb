
module RubyPost

  #wrapper for the metapost graphing macro
  #multiple coordinate systems in a single graph is not yet supported
  #May require pre and post options for graph data which doesn't have
  #a neat solution.  You can ofcourse, still do this with a CustomDrawable.
  class Graph < Drawable

    #automattically sets the size of the graph to 10cm x 10cm 
    def initialize
      super()
      @options = Array.new
      @dati  = Array.new
      @@Inputs.add_input('graph')
      @@Inputs.add_input('sarith')
      self.set_size(10,10)
    end
  
    def add_data(d)
      @dati.push(d)
    end
    
    #set the size of the graph in cm  
    def set_size(w,h)
      @width = w
      @height = h
    end
  
    #add a graph option such as it Title, Xlabel etc.
    def add_graph_option(o)
      @options.push(o)
    end
  
    #utility function to compile all the graph options
    def compile_options
      str = String.new
      @options.each { |o| str = str + ' ' + o.compile }
      return str
    end
  
    def compile
      str = "begingraph(" + @width.to_s + "cm, " + @height.to_s + "cm);\n"
      str = str + compile_options + "\n"
      @dati.each do |d| 
        str = str + d.compile_pre_commands + "gdraw " + d.compile + d.compile_post_commands + "\n"
      end
      str = str + "endgraph"
      str
    end

  end

  #Base class for all graph data.  There are some commands, such as autogrid
  #that must be called after the data is entered with gdraw.  There are others that
  #must be set before the call, such as setcoords.  These macro ensure that order
  #is maintained
  class BaseGraphData < BaseDrawCommand
  
    def initialize
      super()
      @pre_commands = Array.new
      @post_commands = Array.new
    end
  
    def add_pre_command(c)
      @pre_commands.push(c)
    end
  
    def add_post_command(c)
      @post_commands.push(c)
    end
  
    def compile_pre_commands
      str = String.new
      @pre_commands.each { |c| str = str + c.compile }
      return str
    end
  
    #add a grid to the graph.  This is always done as a post command
    #in metapost
    def add_grid(grid)
      add_post_command(grid)
    end
  
    def add_range(range)
      add_pre_command(range)
    end
  
    def add_coords(coords)
      add_pre_command(coords)
    end
  
    def compile_post_commands
      str = String.new
      @post_commands.each { |c| str = str + c.compile }
      return str
    end
  
  end

  #Implements the graph data filename macro
  class GraphFile < BaseGraphData
  
    attr_writer :filename
  
    def initialize(filename=nil)
      super()
      @filename = filename
    end
   
    def compile
      "\"" + @filename + "\" " + compile_options + ";"
    end
   
  end
 
  #set the x and y coordinates arrays independently
  #This uses temp files in order to store and create
  #the graph.  Graphs created with this type of data
  #need to be compiled directly to postscript using
  #RubyPost::File#compile_to_ps unless you want to
  #copy all of the temporay files too!
  class GraphData < GraphFile
  
    attr_writer :x, :y
  
    #class variable to store the number of the temporary
    #files used and keep the filenames separate
    @@graph_data_temp_file = 0
  
    #must make a copy of the arrays as it will be compiled
    #at some latter time and the referenced memory may not
    #be around then!
    def initialize(x=Array.new,y=Array.new)
      super()
      @x = Array.new(x)
      @y = Array.new(y)
      @filename = 'temp_graph_data_' + @@graph_data_temp_file.to_s + '.txt'
      @@graph_data_temp_file = @@graph_data_temp_file+1
    end
  
    #creates the tempory file with the graph data and send this to the
    #metapost file.  Also note that we force scientific notation for the
    #number format as it is ,most compatible with metapost graph.
    def compile
      min = [@x.length, @y.length].min
      IO::File.open(@filename, 'w') do |f|
        min.times { |i| f.puts sprintf("%e", @x[i]) + ' ' + sprintf("%e", @y[i]) }
      end
      "\"" + @filename + "\" " + compile_options + ";"
    end
  
  end


  #class for the special options related to graph paths
  class GraphDataOption < PathOption
  end

  #wraps the plot option for the graph macro
  class Plot < GraphDataOption
  
    attr_writer :dot_type
  
    #default is a latex bullet
    def initialize(p='btex $\bullet$ etex')
      @dot_type = p
    end
  
    def compile
      'plot ' + @dot_type.compile
    end
  
  end

  #Option extention for graphs
  class GraphOption < Option
  end

  #set the axis coords, can be log or linear scale
  class Coords < GraphOption

    def initialize(x='linear',y='linear')
      @x = x
      @y = y
    end
  
    def loglog
      @x = 'log'
      @y = 'log'
    end
  
    def linearlinear
      @x = 'log'
      @y = 'log'
    end
  
    def linearlog
      @x = 'linear'
      @y = 'log'
    end
  
    def loglinear
      @x = 'log'
      @y = 'linear'
    end
  
    def compile
      'setcoords(' + @x + ',' + @y + ");\n"
    end
  
  end


  #wraps the setrange function in metapost
  #can use strings or numbers.
  class Range < GraphOption
  
    attr_writer :xmin, :xmax, :ymin, :ymax
  
    def initialize(xmin='whatever', ymin='whatever', xmax='whatever', ymax='whatever')
      @xmin = xmin
      @xmax = xmax
      @ymin = ymin
      @ymax = ymax
    end
  
    def compile
      'setrange(' + @xmin.to_s + ', ' + @ymin.to_s + ', ' + @xmax.to_s + ', ' + @ymax.to_s + ");\n"
    end
  
  end


  #set the position and type of grid tick marks and labels
  class AutoGrid < Drawable

    attr_writer :x, :y

    def initialize(x=String.new, y=String.new)
      super()
      @x = x
      @y = y
    end
  
    def compile
      'autogrid(' + @x + ', ' + @y + ")" + compile_options + ";\n"
    end
  
  end

  #base class for graph labels
  class GraphLabel < GraphOption
  
    attr_writer :label
  
    def initialize(label=nil)
      @label = label
    end
  
  end

  #place an x label on the graph
  class XLabel < GraphLabel
  
    def compile
      'glabel.bot(' + @label + ", OUT);\n"
    end

  end

  #place an y label on the graph
  class YLabel < GraphLabel
  
    def compile
      'glabel.lft(' + @label + ", OUT);\n"
    end

  end

  #place an y label on the right hand side of the graph
  class YLabelRight < GraphLabel
  
    def compile
      'glabel.rt(' + @label + ", OUT);\n"
    end

  end

  #place a title on the top of the graph
  class GraphTitle < GraphLabel
  
    def compile
      'glabel.top(' + @label + ", OUT);\n"
    end
  
  end

end