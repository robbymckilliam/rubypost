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

  #Defines all the pictures at the front of the file
  class PicturePrecompiler < Object
  
    def initialize
      @pictures = Array.new
    end
  
    def add_picture(s)
      @pictures.push(s)
    end
  
    def compile
      str = "picture " + @@org_picture + ";\n" + @@org_picture + " := currentpicture;\n"
      @pictures.each do
        |p| str = str + p.precompile + "\n"
      end
      str
    end
  
  end

  #module variable to be altered by drawables that
  #need a particular metapost macro input.  
  @@picture_precompiler = PicturePrecompiler.new

  #module variable to be altered by drawables that
  #need a particular metapost macro input.  
  @@Inputs = Macros.new

  #this is the origninal metapost picture that is
  #what actually gets displayed.  You shouldn't use
  #this name for any other picture!
  @@org_picture = "ORIGINAL_PICTURE"

  #metapost file
  #A metapost file can contain many figures.
  #Notes: Filenames cannot contain underscores for view to work! <br>
  #compile_to_str has a dodgy backspace handler.
  class File < Object
  
    attr_writer :fname, 
      #name of div viewer program to use
      :dvi_viewer,
       #option for metapost command line
      :metapost_options
  
@@start_of_file_string_default = <<END_OF_STRING
prologues := 2;
filenametemplate "%j-%c.mps";
verbatimtex
%&latex
\\documentclass{minimal}
\\begin{document}
etex
END_OF_STRING
  
    #input 'sarith' so that metapost can read exponential notation
    def initialize(fname = nil, start_of_file_string = @@start_of_file_string_default)
      @figures = Array.new
      @fname = fname
      @dvi_viewer = 'yap'
      @metapost_options = '-interaction=nonstopmode'
      @start_of_file_string = start_of_file_string
    end

    #add a new figure to this mpost file
    def add_figure(f)
      @figures.push(f)
    end
  
    #returns the mp file as a str
    def compile_to_string
      str = @start_of_file_string + @@Inputs.compile
      #save the original metapost picture
      str = str + @@picture_precompiler.compile
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
      system('mpost ' + @metapost_options + ' ' + fname + '.mp')
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
      @figures.each_index { |i| str = str + ' ' + @fname + '-' + (i+1).to_s + ".mps"  }
      system(str)
      system(@dvi_viewer + ' mproof.dvi')
    end
  
  end

  #wrapper for the metapost figure
  #Figures actually become the figures that will to be viewed
  class Figure < Object
  
    def initialize
      @draw_commands = Array.new
    end
  
    def add_drawable(d)
      @draw_commands.push(d)
    end
  
    def compile
      str = String.new
      @draw_commands.each do |d| 
        str = str + d.compile +  "\n"
      end
      str = str + "endfig;\n"
      return str
    end
  
  end

  #end module RubyPost
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
    #@mpsize='cm' if(@mpsize==nil)
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
