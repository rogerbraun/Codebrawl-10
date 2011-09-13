require "chunky_png"

module ChunkyPNG::Color
  def self.to_rg(pixel)
    r, g, b = r(pixel), g(pixel), b(pixel)
    [r / (r + g + b).to_f, g / (r + b + g).to_f]
  end

  def self.distance(pixel, poxel)
    x, y = to_rg(pixel), to_rg(poxel)
    a, b = x[0] - y[0], x[1] - y[1]

    # Divide by 1.41 to get results from 0 to 1
    Math.sqrt((a * a) + (b * b)) / Math.sqrt(2)
  end
end

module SelectiveColor
  def to_selective_color(color, avoid = nil)
    pixels.map! do |pixel| 
      too_far = color.inject(false){|r, (c, d)| r or (ChunkyPNG::Color.distance(c, pixel) > d)}
      too_close = avoid && avoid.inject(false){|r, (c, d)| r or (ChunkyPNG::Color.distance(c, pixel) < d)}
      if too_far or too_close
        ChunkyPNG::Color.to_grayscale(pixel)
      else
        pixel
      end
    end

    return self
  end
end

image = ChunkyPNG::Image.from_file("input.png")

image.extend(SelectiveColor)


keep = [[ChunkyPNG::Color.rgb(152,216,56), 0.1]]

avoid = [[ChunkyPNG::Color.rgb(255,229,62), 0.05]]

image.to_selective_color(keep, avoid)

image.save("output.png")
