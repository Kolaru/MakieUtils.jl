struct TreeLayout
    val
    children::Dict
end

TreeLayout(val) = TreeLayout(val, Dict())

Base.getindex(layout::TreeLayout) = layout.val
Base.getindex(layout::TreeLayout, i, j) = layout.val[i, j]
Base.display(layout::TreeLayout ; kwargs...) = display(layout[] ; kwargs...)

function Base.getindex(layout::TreeLayout, symbol)
    child = layout.children[symbol]
    !isempty(child.children) && return child
    return child[]
end

struct Layout
    figpos::Vector
    children
    constructor
    kwargs
end

function Layout(::Type{Figure}, children... ; kwargs...)
    tree = TreeLayout(Figure(; kwargs...))

    for (key, child) in children
        tree.children[key] = tree_layout(tree[], child)
    end

    return tree
end

function Layout(fig::Figure, children...)
    tree = TreeLayout(fig)

    for (key, child) in children
        tree.children[key] = tree_layout(tree[], child)
    end

    return tree
end

function Layout(::Nothing, children...)
    Layout([], children, nothing, Dict())
end

function Layout(constructor::Union{Type, Function}, figpos, children... ; kwargs...)
    Layout(figpos, children, constructor, kwargs)
end

function tree_layout(parent, child)
    if isnothing(child.constructor)
        node = TreeLayout(parent)
    else
        node = TreeLayout(child.constructor(parent[child.figpos...] ; child.kwargs...))
    end

    for (key, grandchild) in child.children
        node.children[key] = tree_layout(node[], grandchild)
    end

    return node
end