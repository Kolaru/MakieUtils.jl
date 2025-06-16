# MakieUtils.jl

A set of utilities for Makie, for my personal use and needs.

Currently, I have the following:

- `BareAxis` and `BareAxis3`: Alternative to `Axis` and `Axis3` where
  all decorations are disabled by default.

- `PanelLabel`: Bold label with some utilies to place it using padding in
  all directions relative to the figure position.

- `boxed_layout`: A `GridLayout` framed with a roudned box.

- `TitledFigure`: A figure with a title and optionnaly a description.
  Return two outputs, the figure itself, and a layout over the useable area
  (i.e. this layout does not contain the title and the description).

- `OverflowLayout`: A layout defined by its number of columns.
  Is linearly indexed, and rows are automatically added if the number
  of blocks in the layout increase above the number of columns.

- `out_backend!`: An utility to plot an image with GLMakie in a
  CairoMakie figure. Allow to have publication quality pdf figures
  containing 3D render from GLMakie.

- `science_theme`: A `Theme` that follows the guideline of the journal Science.

- `thesis_theme`: The `Theme` I used in my PhD thesis.
  Awesome stuff if you aske me.

- `save_gl_transparent`: Save a `GLMakie` figure with a transparent background,
  using a trick from Julius Krumbiegel.
  I also define `save_cairo_transparent`, but it should normally not be useful.

- `Layout`: A system of layouting as a lazy tree.
  Terribly confusing, and I should probably use the new-ish SpecApi instead.

- `Diamond3`: Return a mesh shaped like a 3D diamond by staking two
  pyramids.

- `palette`: Just an alias for `Makie.DEFAULT_PALETTES.color[]`.