require "chunky_png"
require "./extensions.rb"
require "pry"


image = ChunkyPNG::Image.from_file("input.png")

image.extend(SelectiveColor, Neighbors)


keep = [[ChunkyPNG::Color.rgb(221,57,42), 10]]#[[ChunkyPNG::Color.rgb(152,216,56), 0.1]]

avoid = nil #[[ChunkyPNG::Color.rgb(255,229,62), 0.05]]

image.to_selective_color(keep)

image.save("output.png")
