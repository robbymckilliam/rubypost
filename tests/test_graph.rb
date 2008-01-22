#code to generate a plot of the data in metapost format
require 'rubypost'
require 'drawable'
require 'options'
require 'graph'

include RubyPost

file = RubyPost::File.new
fig = Figure.new
file.add_figure(fig)

graph = Graph.new
graph.add_option(XLabel.new(latex('x label')))
graph.add_option(GraphTitle.new(latex('A graph title')))
graph.add_option(YLabel.new(latex('the y label')))
graph.add_option(YLabelRight.new(latex('the y label on the right')))
fig.add_drawable(graph)

#plot y = x^2
x = (1..20).to_a
y = Array.new
x.each { |v| y.push(v**2) }
gd = GraphData.new(x, y)
gd.add_option(RubyPost::Colour.new(0.0,1.0,0.0))
graph.add_data(gd)

file.compile('figures')

file.view