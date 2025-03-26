
function calculate_rgba(rgb1, rgb2, rgba_bg)::RGBAf
    rgb1 == rgb2 && return RGBAf(rgb1.r, rgb1.g, rgb1.b, 1)
    c1 = Float64.((rgb1.r, rgb1.g, rgb1.b))
    c2 = Float64.((rgb2.r, rgb2.g, rgb2.b))
    alphas_fg = 1 .+ c1 .- c2
    alpha_fg = clamp(sum(alphas_fg) / 3, 0, 1)
    alpha_fg == 0 && return rgba_bg
    rgb_fg = clamp.((c1 ./ alpha_fg), 0, 1)
    rgb_bg = Float64.((rgba_bg.r, rgba_bg.g, rgba_bg.b))
    alpha_final = alpha_fg + (1 - alpha_fg) * rgba_bg.alpha
    rgb_final = @. 1 / alpha_final * (alpha_fg * rgb_fg + (1 - alpha_fg) * rgba_bg.alpha * rgb_bg)
    return RGBAf(rgb_final..., alpha_final)
end

function alpha_colorbuffer(figure ; px_per_unit = 1)
    scene = figure.scene
    bg = scene.backgroundcolor[]
    scene.backgroundcolor[] = RGBAf(0, 0, 0, 1)
    b1 = copy(colorbuffer(scene ; px_per_unit))
    scene.backgroundcolor[] = RGBAf(1, 1, 1, 1)
    b2 = colorbuffer(scene ; px_per_unit)
    scene.backgroundcolor[] = bg
    return map(b1, b2) do b1, b2
        calculate_rgba(b1, b2, bg)
    end
end

"""
    save_gl_transparent(name, figure ; kwargs...)

Save a GLMakie figure with transparent background.

Particularly useful for detouring 3D images.

Additional key word arguments are passed to `Makie.save`.
"""
function save_gl_transparent(name, figure ; px_per_unit = 1, kwargs...)
    buffer = rotr90(alpha_colorbuffer(figure ; px_per_unit))
    fig = Figure(;
        size = size(buffer),
        figure_padding = 0,
        backgroundcolor = (:white, 0)
    )
    ax = Axis(fig[1, 1] ; backgroundcolor = (:white, 0))
    hidespines!(ax)
    hidedecorations!(ax)

    image!(ax, buffer)
    save(name, fig ;
        backend = CairoMakie,
        kwargs...
    )
end

"""
    save_cairo_transparent(name, figure ; kwargs...)

Save a CairoMakie figure with a transparent background.

Useful as setting the background to transparent at figure creation
sometimes causes some display problem for the figure.

Additional key word arguments are passed to `Makie.save`.
"""
function save_transparent(name, figure ; kwargs...)
    scene = figure.scene
    bg = scene.backgroundcolor[]
    scene.backgroundcolor[] = to_color(:transparent)
    ret = save(name, figure ; kwargs...)
    scene.backgroundcolor[] = bg
    return ret
end