# MakieUtils.jl

A set of utilities for Makie, for my personal use and needs.

Currently, I have the following:

## Blocks

- `BareAxis` and `BareAxis3`: Alternative to `Axis` and `Axis3` where
  all decorations are disabled by default.

- `boxed_layout`: A `GridLayout` framed with a roudned box.

- `PanelLabel`: Bold label with some utilies to place it using padding in
  all directions relative to the figure position.

- `TitledFigure`: A figure with a title and optionnaly a description.
  Return two outputs, the figure itself, and a layout over the useable area
  (i.e. this layout does not contain the title and the description).

- `OverflowLayout`: A layout defined by its number of columns.
  Is linearly indexed, and rows are automatically added if the number
  of blocks in the layout increase above the number of columns.

- `Layout`: A system of layouting as a lazy tree.
  Terribly confusing, and I should probably use the new-ish SpecApi instead.

## Color

- `transparent_colormap`: Return colormap that goes from
  the given color to transparency.

- `palette`: Just an alias for `Makie.DEFAULT_PALETTES.color[]`.

## Statistics plots

- `scatter_density`: A scatter plot that color the point according
  to the estimated density of points.
  Useful for plotting point clouds in 3D while retaining some
  idea of density.

- `banderror!`: A line plot with error represented as a band.

## Rendering

- `out_backend!`: A utility to plot an image with GLMakie in a
  CairoMakie figure. Allow to have publication quality pdf figures
  containing 3D render from GLMakie.

- `save_gl_transparent`: Save a `GLMakie` figure with a transparent background,
  using a trick from Julius Krumbiegel.
  I also define `save_cairo_transparent`, but it should normally not be useful.

## Themes

- `science_theme`: A `Theme` that follows the guideline of the journal Science.

- `thesis_theme`: The `Theme` I used in my PhD thesis.
  Awesome stuff if you aske me.

## Other

- `Diamond3`: Return a mesh shaped like a 3D diamond by staking two
  pyramids.