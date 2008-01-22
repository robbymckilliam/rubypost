module RubyPost

#base class for rubypost
class Object
  #returns the string of metapost commmands
  def compile
    '%compile not implemented for ' + self.class.to_s
  end
end

#stores the macros that particular drawbles need.
#This should really be a private class.
class Macros < Object
  
  def initialize
    @inputs = Hash.new
  end
  
  #uses hash to make sure we never input same thing twice 
  def add_input(s)
    @inputs[s] = nil
  end
  
  def compile
    str = String.new
    @inputs.each_key do
      |k| str = str + "input " + k + ";\n"
    end
    str
  end
  
end

#global module variable to be altered by drawables that
#need a particular metapost macro input.  
$Inputs = Macros.new

#metapost file
#A metapost file can contain many figures.
#Notes: Filenames cannot contain underscores for view to work! <br>
#compile_to_str has a dodgy backspace handler.
class File < Object
  
  attr_writer :fname
  
  @@start_of_file = "prologues := 2;\n"
  
  #input 'sarith' so that metapost can read exponential notation
  def initialize(fname = nil)
     @figures = Array.new
     @fname = fname
  end
  
  #add a new figure to this mpost file
  def add_figure(f)
    @figures.push(f)
  end
  
  #returns the mp file as a str
  def compile_to_string
    str = @@start_of_file + $Inputs.compile
    @figures.each_index do
      |i| str = str + 'beginfig(' + (i+1).to_s + ");\n" + @figures[i].compile + "\n"
    end
    str = str + "end;\n"
    #remove the backspaces
    strback = str.gsub(/.[\b]/, '')
    if (strback==nil) 
      return str
    else 
      return strback 
    end
  end
  
  #writes the string of metapost commands to a file named 'fname.mp'
  def compile_to_file(fname=@fname)
    @fname = fname
    IO::File.open(fname + '.mp','w') { |f| f.puts self.compile_to_string }
  end
  
  #calls compile_to_file and writes the
  #and copmiles the metapost commands if mpost is in the path
  def compile(fname=@fname)
    compile_to_file(fname)
    system('mpost -quiet ' + fname + '.mp')
  end
  
  #default view command is view_dvi
  def view
    view_dvi
  end
  
  #assumes that the file has already been compiled by metapost.  ie compile_to_ps
  #has already been called.  This assumes that the yap viewer and tex is in your path. Install
  #miktex to get these by default. <p>
  #Notes: Filenames cannot contain underscores for view_dvi to work.  The "tex mproof" will
  #not work with underscores
  def view_dvi
    str = 'tex mproof'
    @figures.each_index { |i| str = str + ' ' + @fname + '.' + (i+1).to_s }
    system(str)
    system('yap mproof.dvi')
  end
  
end

#wrapper for the metapost figure
#Figures actually become the figures that will to be viewed
class Figure < Object
  
  def initialize
    @drawables = Array.new
  end
  
  def add_drawable(d)
    @drawables.push(d)
  end
  
  def compile
     str = String.new
    @drawables.each do |d| 
      str = str + d.draw_type + ' ' + d.compile +  "\n"
    end
    str = str + "endfig;\n"
    return str
  end
  
end

end

#Add the compile functionality to Ruby Numeric.  Calling
#compile will add the cm, inch, bp metapost sizes to the
#to_s 
class Numeric
  def cm
    @mpsize = 'cm'
    self
  end
  def inch
    @mpsize = 'inch'
    self
  end
  def bp
    @mpsize = 'bp'
    self
  end
  #A nifty thing here is that if you dont specify the size
  #if wont print anything
  def compile
    to_s + @mpsize.to_s
  end
end

#Add the compile functionality to Ruby String class
#it just calls to_s
class String
  def compile
    to_s
  end
end
