# How to get the selective color effect

When I started to program for this Codebrawl, I had essentially two ideas how to do this: Try to detect each crayon as an object and keep one of them in color, or take a reference color and just keep the colors that are similar to it. The first idea would be more universal, but seems to me much harder to implement. I chose the second one, so I needed a way to measure the distance between to colors.

# How to measure the distance between colors

There are several ways to get a value that tells you how much colors are like each other. If you have an RGB pixel, you could just take these 3 values as coordinates in a three dimensional space and calculate the distance there. I did not actually implement this, as it does not represent similar colors in the way we would see them. For example, the color (255,0,0) and (127,0,0) would both be just red, but they would have the same distance as (255, 128, 0), which intruduces green to the color and looks pretty different.

This also tells us something about what kind of representation we want: One where only the color counts, but not the brightness (or luminance). I first looked at rg chromaticty space.

## rg chromacity

rg chromacity is a simple way to remove intensity information from your colors and only keep the proportions of red, green and blue. What you do is just normalize the values to be between 0 and 1, with r + g + b always adding up to one. It is called rg chromacity because only the red and green components are needed to describe a color, as the blue component is always b = 1 - (r + g). For example, rgb(255,0,0) is rg(1,0), as is rgb(200,0,0). 

You now have a 2d space, so distances can be easily calculated. This gives somewhat satisfactory results, at least for some of the crayons. But in the end, it just was not as good as I had hoped. Part of this surely is the how this color space actually looks. It is somewhat uneven, as the distance between pure red, rg(1,0) and pure blue, rg(0,0) is one. But between red and green, rg(0,1), it is the square root of two! By just measuring the distance, I am essentially cutting a circle of colors I want to keep, but colors in this space are not uniformly distributed.

I had a lot of ideas how to counter these problems: Make colors spread from a reference color if the neighbor are similar, make negative cuts in this space by specifying colors that should be always made gray, etc... 

What I really needed was a better distance function for my colors. 

# HSV

If you look at color space, you will find HSL and HSV pretty soon. They each use the hue, saturation and lightness or value to define a color. If you take a look at some pictures of this color space, you will quickly see that the hue component looks pretty much like what we need.

Now, calculating the hue is more complicated than calculating rg chromacity colors. If I understood it correctly, you make a hexagon, put red at 0°, green at 120° and blue at 240° and then calculate where your color lies. You can see the formula I used in the code. 

Calculating the distance is just subtracting one hue from the other. We have to do it two times, though, as hue is circular and has red on both ends. This gives good results for most colors. I could not get the yellow and red crayon to seperate perfectly... This may be because I did not find a good reference color, or just that the dark yellow in the tip of the crayon and the light red are actually too similar and this approach won't work at all. If other entries managed to get a perfect red crayon with no yellow using just the hue, you know which one it is ;-)

# Better color distances

There is a standard for measuring color difference by the International Commission on Illumination (sounds good, right?). It takes into account how humans perceive color, so it should give you the best results (if you are human, that is). I did not try it, though, as it seems somewhat complicated and I wanted to keep this entry short and to the point. Maybe you want to take a shot?

# BONUS: Javascript version

I also wrote a javascript version of the same algorithm which you can use to quickly check the effects of changing the reference color or the color distance. You can find it at http://severe-autumn-9391.heroku.com/index.html. 

Use the slider to set the color distance that will still be colored, and just click on any point in the image on the right to set it as reference. Have fun!
