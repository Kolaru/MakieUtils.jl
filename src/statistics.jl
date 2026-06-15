"""
    banderror!(ax, xx, yy, err ; band_alpha, color = :gray)

Plot the data `(xx, yy)` as a line, with the error `err` represented by a band.

The error is of the form `yy ± err`, so that the width of the band is `2 * err`.
"""
function banderror!(ax, xx, yy, err ;
        band_alpha = 0.7,
        color = palette[1],
        band_kwargs = (;),
        line_kwargs = (;),
        scatter_kwargs = (;),
        double_error = false, 
        marker = nothing,
        label = "Average")

    if double_error
        band!(ax, xx, yy - 2err, yy - err ;
            alpha = band_alpha / 2,
            color,
            label,
            band_kwargs...
        )

        band!(ax, xx, yy + err, yy + 2err ;
            alpha = band_alpha / 2,
            color,
            label,
            band_kwargs...
        )
    end

    band!(ax, xx, yy - err, yy + err ;
        alpha = band_alpha,
        color,
        label,
        band_kwargs...
    )
    lines!(ax, xx, yy ; color = :black, label, line_kwargs...)

    if !isnothing(marker)
        scatter!(ax, xx, yy ; color = :black, label, marker, scatter_kwargs...)
    end
end