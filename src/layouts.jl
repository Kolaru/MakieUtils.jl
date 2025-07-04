"""
    TitledFigure([title, description] ; kwargs...)

Create a figure with an optional title and description. 

Return the figure and a layout, which does not contain the title and
description and should be used to place the axes.

Keyword arguments are passed to `Makie.Figure`.
"""
function TitledFigure(
        title::Union{AbstractString, Nothing} = nothing,
        description::Union{AbstractString, Nothing} = nothing ; kwargs...)

    fig = Figure(; kwargs...)
    k = 1

    if !isnothing(title)
        Label(fig[1, 1],
            tellwidth = false,
            text = title,
            fontsize = 20,
            font = :bold,
            justification = :left,
            halign = :left
        )
        k += 1
    end

    if !isnothing(description)
        Label(fig[k, 1] ;
            tellwidth = false,
            text = description,
            justification = :left,
            halign = :left
        )
        k += 1
    end

    layout = GridLayout(fig[k, 1])

    return fig, layout
end

"""
    TitledFigure(f!::Function, [title, description] ; file_types = ["png"], save_folder = nothing, kwargs...)

Version of TitledFigure compatible with the `do`-syntax.

For example:

```julia
fig = TitledFigure("A Great Figure") do layout
    ax = Axis(layout[1, 1])
    scatter!(ax, rand(123))
end
```

The layout is passed to the function which can modify it.

If both a `title` and a `save_folder` are given, then the figure is automatically
saved in this folder with a normalized name.
One file is created for each file type in `file_types` (which must be a list of 
file extension understood by the active Makie backend).
"""
function TitledFigure(f!, title = nothing, description = nothing ;
        file_types = ["png"], save_folder = nothing, kwargs...)

    fig, layout = TitledFigure(title, description ; kwargs...)
    f!(layout)

    if !isnothing(save_folder) && !isnothing(title)
        filename = replace(lowercase(title), " " => "_")
        for ext in file_types
            save(joinpath(save_folder, "$filename.$ext"), fig)
        end
    end

    return fig
end

"""
    OverflowLayout(figpos, ncols ; kwargs...)

A layout with a given number of columns, that wraps when containing more
elements that columns.

Elements can either be placed by linear indexing the layout,
or by iterating over it.

Note that the iteration should be stop at some point, typically by
zipping the OverflowLayout with another vector of finite size.

Keywords arguments are passed to `Makie.GridLayout`.
"""
struct OverflowLayout
    layout::GridLayout
    ncols::Int

    function OverflowLayout(figpos, ncols ; initialize = true, kwargs...)
        if initialize
            layout = GridLayout(figpos, 1, ncols ; kwargs...)
        else
            layout = GridLayout(figpos, 1, 1 ; kwargs...)
        end
        return new(layout, ncols)
    end
end

function Base.iterate(ol::OverflowLayout, state = 1)
    state > 100 && throw("""
        100 iteration in an OverflowLayout, this is probably an infinite loop.
        Warning: OverflowLayout are infinite iterators.
        """)
    i, j = fldmod1(state, ol.ncols)
    return ol.layout[i, j], state + 1
end

function Base.getindex(ol::OverflowLayout, k)
    i, j = fldmod1(k, ol.ncols)
    return ol.layout[i, j]
end

Base.length(ol::OverflowLayout) = 100

function boxed_layout(figpos ;
        backgroundcolor = (:white, 0),
        padding = 5,
        cornerradius = 10,
        color = :black,
        zorder = -2,
        nrows = 1,
        ncols = 1,
        kwargs...)
    box = Box(figpos ; cornerradius, color = backgroundcolor, strokecolor = color)
    translate!(box.blockscene, 0, 0, zorder)

    return GridLayout(figpos, nrows, ncols ; alignmode = Outside(padding...), kwargs...)
end