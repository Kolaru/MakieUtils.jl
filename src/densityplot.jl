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
function scatter_density!(ax, data::Matrix ;
        npoints = min(1000, size(data, 2)),
        bandwidth = 1, 
        color = :black,
        colormap = transparent_colormap(color),
        kwargs...)

    shown_data = data[:, shuffle(1:size(data, 2))[1:npoints]]
    kdtree = KDTree(data)
    density = inrangecount(kdtree, shown_data, bandwidth)

    scatter!(ax,
        eachrow(shown_data)... ;
        color = density,
        colormap,
        kwargs...
    )
end