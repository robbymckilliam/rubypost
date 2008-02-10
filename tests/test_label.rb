require '../lib/objects'
require '../lib/drawable'
require '../lib/draw'
require '../lib/options'
require '../lib/label'

include RubyPost


file = RubyPost::File.new('testlabel')

#draw a circle
fig1 = Figure.new
file.add_figure(fig1)

p = Pair.new(0,0)

fig1.add_drawable(Draw.new(p).scale(0.5.cm))

fig1.add_drawable(Label.new(latex("test label"), p))
fig1.add_drawable(Label.new(latex("test label bottom"), p).bottom)

p2 = Pair.new(0,-5.cm)
fig1.add_drawable(Draw.new(p2))

fig1.add_drawable(Label.new(latex("test right"), p2).right)
fig1.add_drawable(Label.new(latex("test left"), p2).left)

puts file.compile_to_string
file.compile
file.view

