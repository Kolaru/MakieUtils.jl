function transparent_colormap(color ; length = 200)
    c = parse(Color, color)
    return range(RGBA(c, 0.0), c ; length)
end