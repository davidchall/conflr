# conflr 0.0.5.9000

* Added a `NEWS.md` file to track changes to the package.

* conflr now works outside RStudio (e.g. Emacs/Vim) thanks to the power of
  askpass package (#10).

* conflr addin now has "Use original image sizes" option to control whether to resize
  the image (default) or not (#21).

* `confl_create_post_from_Rmd()` gets `interactive` argument. When it's `FALSE`
  it doesn't show Shiny popups, which is suitable for console use (#32, @ndiquattro).

# conflr 0.0.5

* Initial release on GitHub