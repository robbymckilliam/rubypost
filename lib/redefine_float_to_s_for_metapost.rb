
#metapost cannot handle expoential notation for float
#strings.  This redefines the Float#to_s so that it is
#compatible with metapost.
class Float
  alias_method :orig_to_s, :to_s
  def to_s
    sprintf("%.#{5}f", self)
  end
end

#metapost cannot handle the way ruby prints Rational.
#This redefines the Rational#to_s so that it is
#compatible with metapost.
class Rational
  alias_method :orig_to_s, :to_s
  def to_s
    sprintf("%.#{5}f", self.to_f)
  end
end
