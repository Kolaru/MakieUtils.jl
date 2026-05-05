"""
    banderror!(ax, xx, yy, err ; band_alpha, color = :gray)

Plot the data `(xx, yy)` as a line, with the error `err` represented by a band.

The error is of the form `yy ± err`, so that the width of the band is `2 * err`.
"""
function banderror!(ax, xx, yy, err ;
        band_alpha = 0.7,
        color = palette[1],
        band_kwargs = (;),
        double_error = false, 
        error_label = "1σ error",
        marker = nothing,
        kwargs...)

    if double_error
        band!(ax, xx, yy - 2err, yy - err ;
            alpha = band_alpha / 2,
            color,
            label = "2σ error",
            band_kwargs...
        )

        band!(ax, xx, yy + err, yy + 2err ;
            alpha = band_alpha / 2,
            color,
            label = "2σ error",
            band_kwargs...
        )
    end

    band!(ax, xx, yy - err, yy + err ;
        alpha = band_alpha,
        color,
        label = error_label,
        band_kwargs...
    )
    lines!(ax, xx, yy ; color = :black, label = "Average", kwargs...)

    if !isnothing(marker)
        scatter!(ax, xx, yy ; color = :black, label = "Average", marker, kwargs...)
    end
end