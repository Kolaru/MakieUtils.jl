"""
    draw_angle!(ax, rA, r0, rB ; kwargs...)

Draw the angle ∠(rA, r0, rB) as a section of disk.

Keyword arguments
=================
- alpha (default 0.3): transparency of the interior of the angle.
- angle_step (default π / 180): separation between each points on the disk section (in radian).
- color (default :black): color of the angle.
- label
- linewidth (default 5)
- strokecolor (default `color`)
- tipsize (default 5 * π/180): size of the tip of the arrow representing a directed angle (in radian).
- tipwidth = (default 1.3linewidth): width of the tip of the arrow.
"""
function draw_angle!(ax, rA, r0, rB ;
        angle_step = π / 180,
        color = :black,
        strokecolor = color,
        linewidth = 5,
        alpha = 0.3,
        tipsize = 5 * π/180,
        tipwidth = 1.3linewidth,
        label = "",
        kwargs...)

    uA = rA - r0    
    uB = rB - r0

    uB = normalize(uB) * norm(uA)

    theta = angle(float.(uA), float.(uB)) - tipsize

    axis = normalize(uA × uB)    
    pts = map(0:angle_step:theta) do a
        r0 + RotationVec((axis * a)...) * uA
    end

    pts = vcat(pts)

    lines!(ax, Point3f.(pts) ;
        color = strokecolor,
        linewidth,
        label,
        kwargs...
    )

    # Draw an arrow tip at the end of the angle
    tipend = r0 + uB
    tipstart = pts[end]

    arrows2d!(ax, [tipstart], [tipend - tipstart] ;
        color = strokecolor,
        minshaftlength = 0,
        maxshaftlength = 0,
        tipwidth = tipwidth,
        overdraw = true,
        kwargs...
    )

    poly!(ax, Point3f.(vcat(pts, [r0 + uB, r0])) ;
        color,
        alpha,
        label,
        kwargs...
    )
end