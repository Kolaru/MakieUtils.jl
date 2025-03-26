
function render_plot(plot!, bbox ; scalefactor = 5, backend = GLMakie)
    fig = Figure(;
        size = bbox.widths * scalefactor,
        figure_padding = 0
    )
    plot!(fig[1, 1])

    return rotr90(Makie.colorbuffer(fig ; backend))
end

function out_backend!(plot!, figpos ;
        backend = GLMakie,
        frontend = CairoMakie,
        scalefactor = 5,
        alignmode = Outside(),
        refit_observable = nothing,
        kwargs...)

    backend == frontend && return plot!(figpos)

    # Extra layout to infer the bounding box
    layout = GridLayout(figpos)
    bbox = layout.layoutobservables.computedbbox

    img = Observable(render_plot(plot!, bbox[] ; scalefactor, backend))

    if !isnothing(refit_observable)
        on(refit_obs) do _
            img[] = render_plot(plot!, bbox[] ; scalefactor, backend)
        end
    end

    ax = Axis(layout[1, 1] ; aspect = DataAspect(), alignmode, kwargs...)
    hidedecorations!(ax)
    hidespines!(ax)
    image!(ax, img)
    translate!(ax.scene, 0, 0, -1)
    return ax
end