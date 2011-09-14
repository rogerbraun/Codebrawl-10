module ChunkyPNG::Color
  def self.to_rg(pixel)
    r, g, b = r(pixel), g(pixel), b(pixel)
    [r / (r + g + b).to_f, g / (r + b + g).to_f]
  end

  def self.hue(pixel)
    r, g, b = r(pixel), g(pixel), b(pixel)
    return 0 if r == b and b == g 
    180 / Math::PI * Math.atan2(2 * r - g -b, Math.sqrt(3) * (g - b)) 
  end

  def self.distance(pixel, poxel)
    # x, y = to_rg(pixel), to_rg(poxel)
    #a, b = x[0] - y[0], x[1] - y[1]

    # Divide by 1.41 to get results from 0 to 1
    #Math.sqrt((a * a) + (b * b)) / Math.sqrt(2)
    (hue(pixel) - hue(poxel)).abs
  end
end

module Neighbors
  def neighbors(x, y = nil)
    unless y
      y = x / width
      x = x - y * width
    end
    candidates = ((x - 1)..(x + 1)).to_a.product(((y - 1)..(y + 1)).to_a)    
    candidates.select{|el| include_point? el} - [[x, y]]
  end
end

module SelectiveColor
  def to_selective_color(color, avoid = nil, spread = nil)
    colored = pixels.map do |pixel| 
      too_far = color.inject(false){|r, (c, d)| r or (ChunkyPNG::Color.distance(c, pixel) > d)}
      too_close = avoid && avoid.inject(false){|r, (c, d)| r or (ChunkyPNG::Color.distance(c, pixel) < d)}
      if too_far or too_close
        false
      else
        true
      end
    end

    if spread then
      modified = true
      while modified do
        modified = false
        pixels.each_with_index do |pixel, i|
          if colored[i]
            neighbors(i).each do |(x,y)|
              unless colored[x + (y * width)]
                other_pixel = get_pixel(x, y)
                if ChunkyPNG::Color.distance(pixel, other_pixel) < spread
                  modified = (modified || 0) + 1
                  colored[x + (y * width)] = true
                end
              end
            end
          end
        end    
        puts "Modified #{modified} pixels"
      end 
    end

    colored.each_with_index do |color, i|
      pixels[i] = ChunkyPNG::Color.to_grayscale(pixels[i]) unless color
    end

    return self
  end
end
