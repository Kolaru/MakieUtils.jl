"""
    banderror!(ax, xx, yy, err ; band_alpha, color = :gray)

Plot the data `(xx, yy)` as a line, with the error `err` represented by a band.

The error is of the form `yy ± err`, so that the width of the band is `2 * err`.
"""
function banderror!(ax, xx, yy, err ; band_alpha = 0.5, color = :gray, band_kwargs = (;), kwargs...)
    band!(ax, xx, yy - err, yy + err ;
        alpha = band_alpha,
        color,
        band_kwargs...
    )
    lines!(ax, xx, yy ; color, kwargs...)
end