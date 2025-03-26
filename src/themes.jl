## Themes
# For Science according to
# https://www.science.org/do/10.5555/page.2385607/full/author_figure_prep_guide_2022-1700144203893.pdf

inside_ticks(size = 4) = (; xticksize = -size, yticksize = -size)

function inchsize(ncols, ratio = 0.68)
    widths = Dict(
        1 => 2.24,
        2 => 4.76,
        3 => 7.24
    )

    w = widths[ncols]
    return round(Int, 72*w), round(Int, 72*w*ratio)
end

function science_theme(; ncols = 3, aspect = 0.66, kwargs...)
    widths = Dict(
        1 => 2.25,
        2 => 4.75,
        3 => 7.25
    )

    width = widths[ncols] * 72
    return Theme(
        colormap = Reverse(:nuuk),
        fontsize = 9,
        figure_padding = 2,
        font = "Helvetica",
        size = (width, width * aspect),
        Axis = (;
            titlesize = 8,
            xticklabelsize = 7,
            yticklabelsize = 7,
            xticksize = 4,
            yticksize = 4
        ),
        Colorbar = (;
            size = 8,
            ticklabelsize = 6,
            ticksize = -4,
            ticklabelpad = 1,
            labelpadding = 1,
            labelsize = 7
        ),
        Hexbin = (;
            rasterize = 2
        ),
        GLMakie = (;
            scalefactor = 1
        )
    )
end

function thesis_theme(; aspect = 1.3, kwargs...)
    width = 330
    theme = Theme(
        colormap = Reverse(:nuuk),
        fontsize = 10,
        figure_padding = 10,
        size = (width, width / aspect),
        Axis = (;
            titlesize = 11,
            xticklabelsize = 8,
            yticklabelsize = 8,
            xticksize = 4,
            yticksize = 4
        ),
        Colorbar = (;
            size = 8,
            ticklabelsize = 8,
            ticksize = -4,
            ticklabelpad = 1,
            labelpadding = 1,
            labelsize = 10
        ),
        GLMakie = (;
            scalefactor = 1
        )
    )
    return merge(theme_latexfonts(), theme)
end
