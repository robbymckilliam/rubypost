#puts Float#to_s back to it's original state
class Float
  def to_s
    orig_to_s
  end
end

#puts Rational#to_s back to it's original state
class Rational
  def to_s
    orig_to_s
  end
end
