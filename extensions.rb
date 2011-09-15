module ChunkyPNG::Color
  # See http://en.wikipedia.org/wiki/Hue#Computing_hue_from_RGB
  def self.hue(pixel)
    r, g, b = r(pixel), g(pixel), b(pixel)
    return 0 if r == b and b == g 
    ((180 / Math::PI * Math.atan2((2 * r) - g - b, Math.sqrt(3) * (g - b))) - 90) % 360
  end

  # The modular distance, as the hue is circular
  def self.distance(pixel, poxel)
    hue_pixel, hue_poxel = hue(pixel), hue(poxel)
    [(hue_pixel - hue_poxel) % 360, (hue_poxel - hue_pixel) % 360].min
  end
end

module SelectiveColor
  # Really simple, just change the pixels to grayscale if their distance to a
  # reference hue is larger than a delta value.
  def to_selective_color!(reference, delta)
    pixels.map!{|pixel| ChunkyPNG::Color.distance(pixel, reference) > delta ? ChunkyPNG::Color.to_grayscale(pixel) : pixel}
    self
  end
end
