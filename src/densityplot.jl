"""
    scatter_density!(ax, data::Matrix ;
        npoints = 10_000, bandwidth = 1,
        color = :black, colormap = transparent_colormap(color),
        kwargs...)

Scatter plot where the color of each point is determined by the estimated density of points.

The data matrix must be of dimension (ndims, npoints),
where `ndims` is the dimension (2 or 3) and `npoints` the number of data points.

The density is estimated by counting the number of other points in a radius of
`bandwidth`.

By default, the colormap used for the points goes from transparent to a single color
determind by the `color` keyword argument.
This is useful in 3D, so that the low density regions do not hide the high density one.

`npoints` determine how many points of the data are plotted,
while all of them are used for the density estimation.
"""
function scatter_density!(ax, data::Observable ;
        npoints = 1000,
        threshold = 0.1,
        bandwidth = 1, 
        color = :black,
        colormap = transparent_colormap(color),
        kwargs...)

    # shown_data = @lift($data[:, shuffle(1:size($data, 2))[1:min(npoints, size($data, 2))]])
    # kdtree = @lift(KDTree($data))
    # density = @lift(inrangecount($kdtree, $shown_data, bandwidth))

    processed = lift(data) do dat
        N = min(npoints, size(dat, 2))
        selected = dat[:, shuffle(1:size(dat, 2))[1:N]]

        kdtree = KDTree(dat)
        density = inrangecount(kdtree, selected, bandwidth)
        
        mask = density ./ maximum(density) .< threshold
        density[mask] .= 0

        # selected = allowmissing(selected)
        # selected[:, mask] .= missing

        return (;
            x = selected[1, :],
            y = selected[2, :],
            z = selected[3, :],
            density
        )
    end

    scatter!(ax,
        @lift($processed.x),
        @lift($processed.y),
        @lift($processed.z) ;
        color = @lift($processed.density),
        colormap,
        kwargs...
    )
end

scatter_density!(ax, data::Matrix ; args...) = scatter_density!(ax, Observable(data) ; args...)

function scatter_density!(ax, xx::AbstractVector, yy::AbstractVector, zz::AbstractVector ; kwargs...)
    scatter_density!(ax, permutedims(hcat(xx, yy, zz)) ; kwargs...)
end

function scatter_density!(ax, xx::Observable, yy::Observable, zz::Observable ; kwargs...)
    scatter_density!(ax, @lift(permutedims(hcat($xx, $yy, $zz))) ; kwargs...)
end