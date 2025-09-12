struct TitledFigure
    title::String
    description::String
    fig::Figure
    layout::GridLayout
end

"""
    TitledFigure([title, description] ; kwargs...)

Create a TitledFigure, with an optional title and description. 

It has a `layout` field where the content of the figure should be placed.
The title and description are not included in this layout.

Keyword arguments are passed to `Makie.Figure`.

When a TitledFigure is saved using the `save` function,
the filename is constructed from the title.
"""
function TitledFigure(
        title::Union{AbstractString, Nothing} = nothing,
        description::Union{AbstractString, Nothing} = nothing ;
        kwargs...)

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
    else
        title = "untitled"
    end

    if !isnothing(description)
        Label(fig[k, 1] ;
            tellwidth = false,
            text = description,
            justification = :left,
            halign = :left
        )
        k += 1
    else
        description = ""
    end

    return TitledFigure(title, description, fig, GridLayout(fig[k, 1]))
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
"""
function TitledFigure(
        f!::Function,
        title::Union{Nothing, AbstractString} = nothing,
        description::Union{Nothing, AbstractString} = nothing ;
        kwargs...)

    figure = TitledFigure(title, description ; kwargs...)
    f!(figure.layout)
    resize_to_layout!(figure.fig)
    return figure
end

"""
    save(figure::TitledFigure, folder::String = "plots", extension::String = "png"))

Save a TitledFigure.
The filename is the title of the figure,
lowercase and with spaces replaced by underscores.

The figure is saved in `folder`,
using the filetype corresponding to `extension`.
"""
function Makie.save(
        figure::TitledFigure ;
        folder::String = "plots",
        extension::String = "png",
        backend = Makie.current_backend(),
        kwargs...)

    mkpath(folder)
    filename = replace(lowercase(figure.title), " " => "_")
    path = joinpath(folder, "$filename.$extension")
    save(path, figure.fig ; backend, kwargs...)
    return path
end

Base.display(figure::TitledFigure) = display(figure.fig)

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
        strokewidth = 1.0,
        zorder = -2,
        nrows = 1,
        ncols = 1,
        kwargs...)
    box = Box(figpos ; cornerradius, color = backgroundcolor, strokecolor = color, strokewidth)
    translate!(box.blockscene, 0, 0, zorder)

    return GridLayout(figpos, nrows, ncols ; alignmode = Outside(padding...), kwargs...)
end