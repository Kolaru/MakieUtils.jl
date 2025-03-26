function BareAxis3(figpos ;
        hidespines = true,
        hidedecorations = true,
        kwargs...)

    ax = Axis3(figpos ;
        aspect = :data,
        alignmode = Inside(),
        viewmode = :fitzoom,
        protrusions = 0,
        azimuth = 3.77,
        elevation = 0.52,
        kwargs...
    )
    if hidespines
        hidespines!(ax)
    end

    if hidedecorations
        hidedecorations!(ax)
    end
    return ax
end

function BareAxis(figpos ; kwargs...)
    ax = Axis(figpos ; kwargs...)

    hidedecorations!(ax)
    hidespines!(ax)

    return ax
end

function PanelLabel(figpos, text::AbstractString ;
        padding = nothing,
        padding_left = 2,
        padding_top = 2,
        padding_right = 2,
        padding_bottom = 2,
        tellheight = false,
        tellwidth = false,
        halign = :left,
        valign = :top,
        kwargs...)


    if !isnothing(padding)
        padding_left = padding
        padding_top = padding
        padding_right = padding
        padding_bottom = padding
    end
    
    label = Label(figpos, text ;
        font = :bold,
        fontsize = 10,
        tellheight,
        tellwidth,
        halign,
        valign,
        padding = (padding_left, padding_right, padding_bottom, padding_top),
        kwargs...
    ) 

    translate!(label.blockscene, 0, 0, 1000)
    return label
end

PanelLabel(figpos ; text = "(?)", kwargs...) = PanelLabel(figpos, text ; kwargs...)
PanelLabel(figpos, label ; kwargs...) = PanelLabel(figpos, string(label) ; kwargs...)
