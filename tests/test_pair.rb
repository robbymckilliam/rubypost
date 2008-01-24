require 'test/unit'

#code to generate a plot of the data in metapost format
require 'rubypost'


include RubyPost


class TestPair < Test::Unit::TestCase
  def testcompare
    assert_equal(Pair.new(1,2), Pair.new(1,2))
  end
  def testadd
    assert_equal(Pair.new(3,5), Pair.new(1,2)+Pair.new(2,3))
  end
  def testsubtract
    assert_equal(Pair.new(3,5), Pair.new(4,4)-Pair.new(1,-1))
  end
  def testmultiply
    assert_equal(Pair.new(2,2), Pair.new(4,4)*0.5)
  end
  def testdivide
    assert_equal(Pair.new(2,2), Pair.new(4,4)/2)
  end
end
