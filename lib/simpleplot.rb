
module RubyPost


  class SimplePlot < Picture

    attr_writer :drawxaxis, :drawyaxis

    #initialise with height and width in centemeters
    def initialize(width, height)
      super()
      @plot_array = Array.new
      @height = height
      @width = width
      #axes set by default
      setaxes(-1,1,-1,1)
      @xtickstr = "\n"
      @ytickstr = "\n"
      @xlabel = "\n"
      @ylabel = "\n"
      @drawxaxis = true
      @drawyaxis = true
    end

    #the scale factors are decided by the very last plot you add
    #you can adjust it with the axes command
    def add_plot(plot)
      @plot_array.push(plot)
      setaxesfor(plot)
    end

    def setaxesfor(plot)
      puts plot.xmin
      puts plot.ymax
      setaxes(plot.xmin, plot.xmax, plot.ymin, plot.ymax)
    end

    def setaxes(xmin, xmax, ymin, ymax)
      @xmax = xmax
      @xmin = xmin
      @ymax = ymax
      @ymin = ymin

      @xscale = @width.to_f/(xmax - xmin)
      @yscale = @height.to_f/(ymax - ymin)
    end

    #set xtick marks, a is an array of tick position and label is the
    #text for each tick. func describes whether a tick should be put on
    #the top or the bottom.  func(x) should return positive for on the bottom
    #and negative for on the top.
    def xticks(x, label=nil, func = lambda {|v| 1} )
      if(label==nil) then label = x.map{|v| latex(v.to_s) } end
      lplace = x.map{ |v| if(func.call(v) < 0) then 'top' else 'bot' end }
      @xtickstr = ''
      x.each_index{ |i|
        @xtickstr = @xtickstr + 'draw ((0,-0.05cm)--(0,0.05cm)) shifted (' + (x[i]*@xscale).to_s + "cm, 0);\n"
        @xtickstr = @xtickstr + 'label.' + lplace[i].to_s + '(' + label[i] + ' ,(' + (x[i]*@xscale).to_s + "cm, 0));\n"
      }
    end

    #set ytick marks, a is an array of tick position and laebl is the text
    def yticks(y, label=nil )
      if(label==nil) then label = y.map{|v| latex(v.to_s) } end
      @ytickstr = ''
      y.each_index{ |i|
        @ytickstr = @ytickstr + 'draw ((-0.05cm,0)--(0.05cm,0)) shifted (0,' + (y[i]*@yscale).to_s + "cm);\n"
        @ytickstr = @ytickstr + 'label.rt(' + label[i] + ' ,(0,' + (y[i]*@yscale).to_s + "cm));\n"
      }
    end

    def xlabel(t)
      @xlabel = 'label.top(' + t + ', (' + (@xscale*@xmax + 0.6).to_s + "cm,0));\n"
    end

    def ylabel(t)
      @ylabel = 'label.rt(' + t + ', (0, ' + (@yscale*@ymax + 0.6).to_s + "cm));\n"
    end

    def precompile
      str = "picture " + @name + ";\n"

      #draw the axes
      str = str + "\n%draw the axes\n"
      str = str + 'draw ((' + (@xscale*@xmax + 0.6).to_s + 'cm,0)--('+ (@xscale*@xmin - 0.3).to_s + "cm,0));\n" if (@drawxaxis)
      str = str + 'draw ((0, ' + (@yscale*@ymin).to_s + 'cm)--(0, ' + (@yscale*@ymax + 0.6).to_s + "cm));\n" if (@drawyaxis)

      str = str + "\n%draw xticks\n"
      str = str + @xtickstr
      str = str + "\n%draw yticks\n"
      str = str + @ytickstr
      str = str + "\n%draw xticks\n"
      str = str + @xlabel
      str = str + "\n%draw yticks\n"
      str = str + @ylabel


      #draw each plot componenet.
      @plot_array.each{|p| 
        str = str + p.compilewithscale(@xscale, @yscale) }

      str = str + @name + " := currentpicture; currentpicture := " + @@org_picture + ";\n"
    end

  end

  class AbstractPlot < BaseDrawCommand

    attr_writer :x, :y

    def initialize()
      super()
    end

    def xmax
      @x.max
    end

    def xmin
      @x.min
    end

    def ymax
      @y.max
    end

    def ymin
      @y.min
    end

  end
  
  class LinePlot < AbstractPlot

    #Intitalise with two arrays of the same size.
    def initialize(x, y)
      super()
      @x = x
      @y = y
    end
    
    def compile
      @p = Path.new
      @x.each_index{ |i| @p.add_pair(Pair.new(@x[i].cm, @y[i].cm)) }
      'draw ' + @p.compile + ' ' + compile_options + ";\n"
    end

    def compilewithscale(xscale, yscale)
      @p = Path.new
      @x.each_index{ |i| @p.add_pair(Pair.new((@x[i]*xscale).cm, (@y[i]*yscale).cm)) }
      'draw ' + @p.compile + ' ' + compile_options + ";\n"
    end

  end

  class CurvedPlot < AbstractPlot

    #Intitalise with two arrays of the same size.
    def initialize(x, y)
      super()
      @x = x
      @y = y
    end

    def compile
      @p = Path.new.curved
      @x.each_index{ |i| @p.add_pair(Pair.new(@x[i].cm, @y[i].cm)) }
      'draw ' + @p.compile + ' ' + compile_options + ";\n"
    end

    def compilewithscale(xscale, yscale)
      @p = Path.new.curved
      @x.each_index{ |i| @p.add_pair(Pair.new((@x[i]*xscale).cm, (@y[i]*yscale).cm)) }
      'draw ' + @p.compile + ' ' + compile_options + ";\n"
    end

  end

  class ImpulsePlot < AbstractPlot

    #Intitalise with two arrays of the same size.
    def initialize(x, y)
      super()
      @x = x
      @y = y
    end

    def compile
      str = ''
      @x.each_index{ |i| 
        str = str + 'drawarrow (' + @x[i].to_s + 'cm, 0)--(' + @x[i].to_s + 'cm, ' + @y[i].to_s + 'cm) ' + compile_options + ";\n"
      }
      return str
    end

    def compilewithscale(xscale, yscale)
      str = ''
      @x.each_index{ |i|
        str = str + 'drawarrow (' + (@x[i]*xscale).to_s + 'cm, 0)--(' + (@x[i]*xscale).to_s + 'cm, ' + (@y[i]*yscale).to_s + 'cm) ' + compile_options + ";\n"
      }
      return str
    end

  end

  class StemPlot < AbstractPlot

    #Intitalise with two arrays of the same size.
    def initialize(x, y)
      super()
      @x = x
      @y = y
    end

    def compile
      str = ''
      @x.each_index{ |i|
        str = str + 'draw (' + @x[i].to_s + 'cm, 0)--(' + @x[i].to_s + 'cm, ' + @y[i].to_s + 'cm) ' + compile_options + ";\n"
        str = str + 'fill fullcircle scaled (0.1cm) shifted (' + @x[i].to_s + 'cm, ' + @y[i].to_s + 'cm) ' + compile_options + ";\n"
      }
      return str
    end

    def compilewithscale(xscale, yscale)
      str = ''
      @x.each_index{ |i|
        str = str + 'draw (' + (@x[i]*xscale).to_s + 'cm, 0)--(' + (@x[i]*xscale).to_s + 'cm, ' + (@y[i]*yscale).to_s + 'cm) ' + compile_options + ";\n"
        str = str + 'fill fullcircle scaled (0.1cm) shifted (' + (@x[i]*xscale).to_s + 'cm, ' + (@y[i]*yscale).to_s + 'cm) ' + compile_options + ";\n"
      }
      return str
    end

  end


end