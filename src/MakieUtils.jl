module MakieUtils

using Colors
using ColorSchemes
using LaTeXStrings
using Makie


include("blocks.jl")
export BareAxis, BareAxis3, boxed_layout, PanelLabel

include("layouts.jl")
export TitledFigure, OverflowLayout

include("rendering.jl")
export out_backend!

include("themes.jl")
export science_theme, thesis_theme, till_colormap

include("transparency.jl")
export save_gl_transparent, save_cairo_transparent

include("tree_layout.jl")
export TreeLayout, Layout

export palette, @sans_str, Diamond3, side

const palette = Makie.DEFAULT_PALETTES.color[]

macro sans_str(tex)
    return L"\fontfamily{TeXGyreHeros}%$tex"
end

function Diamond3()
    top = Pyramid(Point(0.0, 0.0, 0.0), 1.0, 1.0)
    bot = Pyramid(Point(0.0, 0.0, -1.0), 1.0, 1.0)
    return GeometryBasics.Mesh(
        union(GeometryBasics.mesh(top), GeometryBasics.mesh(bot))
    )
end

side(figpos, S) = GridPosition(figpos.layout, figpos.span, S)

end # module MakieUtils
