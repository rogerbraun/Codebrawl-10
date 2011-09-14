module ChunkyPNG::Color
  def self.hue(pixel)
    r, g, b = r(pixel), g(pixel), b(pixel)
    return 0 if r == b and b == g 
    180 / Math::PI * Math.atan2((2 * r) - g -b, Math.sqrt(3) * (g - b)) 
  end

  def self.distance(pixel, poxel)
    (hue(pixel) - hue(poxel)).abs
  end
end

module SelectiveColor
  def to_selective_color!(reference, delta)
    pixels.map!{|pixel| ChunkyPNG::Color.distance(pixel, reference) > delta ? ChunkyPNG::Color.to_grayscale(pixel) : pixel}
    self
  end
end
