require "chunky_png"
require "./extensions.rb"

image = ChunkyPNG::Image.from_file("input.png")

image.extend(SelectiveColor)

#keep = ChunkyPNG::Color.rgb(221,57,42)
#keep = ChunkyPNG::Color.rgb(152,216,56)
keep = ChunkyPNG::Color.rgb(0,125,209)

image.to_selective_color!(keep, 15)

image.save("output.png")
