
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{participationSearch}`

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/bjdugan/participationSearch/graph/badge.svg)](https://app.codecov.io/gh/bjdugan/participationSearch)
<!-- badges: end -->

## Installation

You can install the development version of `{participationSearch}` like
so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Run

You can launch the application by running:

``` r
participationSearch::run_app()
```

## About

You are reading the doc about version : 0.0.0.9000

This README has been compiled on the

``` r
Sys.time()
#> [1] "2026-02-09 21:50:42 EST"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ══ Documenting ═════════════════════════════════════════════════════════════════
#> ℹ Installed roxygen2 version (7.3.3) doesn't match required (7.1.1)
#> ✖ `check()` will not re-document this package
#> ── R CMD check results ───────────────────── participationSearch 0.0.0.9000 ────
#> Duration: 33.4s
#> 
#> ❯ checking for missing documentation entries ... WARNING
#>   Undocumented code objects:
#>     'participation'
#>   Undocumented data sets:
#>     'participation'
#>   All user-level objects in a package should have documentation entries.
#>   See chapter 'Writing R documentation files' in the 'Writing R
#>   Extensions' manual.
#> 
#> ❯ checking package subdirectories ... NOTE
#>   Problems with news in 'NEWS.md':
#>   No news entries found.
#> 
#> ❯ checking R code for possible problems ... NOTE
#>   app_server: no visible binding for global variable 'participation'
#>   app_server: no visible global function definition for 'filter'
#>   app_server: no visible binding for global variable 'OBEREG'
#>   app_server: no visible binding for global variable 'CONTROL'
#>   app_server: no visible binding for global variable 'admin_year'
#>   app_server: no visible global function definition for 'renderLeaflet'
#>   app_server: no visible global function definition for 'mutate'
#>   app_server: no visible global function definition for 'summarize'
#>   app_server: no visible binding for global variable 'unitid'
#>   app_server: no visible binding for global variable 'INSTNM'
#>   app_server: no visible binding for global variable 'CITY'
#>   app_server: no visible binding for global variable 'STABBR'
#>   app_server: no visible binding for global variable 'LONGITUD'
#>   app_server: no visible binding for global variable 'LATITUDE'
#>   app_server: no visible global function definition for 'n'
#>   app_server: no visible binding for global variable 'BCSSE'
#>   app_server: no visible binding for global variable 'FSSE'
#>   app_server: no visible binding for global variable 'module1label'
#>   app_server: no visible binding for global variable 'cons_full'
#>   app_server: no visible global function definition for 'str_replace_all'
#>   app_server: no visible binding for global variable 'module1'
#>   app_server: no visible binding for global variable 'consortium'
#>   app_server: no visible global function definition for
#>     'addCircleMarkers'
#>   app_server: no visible global function definition for 'addTiles'
#>   app_server: no visible global function definition for 'leaflet'
#>   app_server: no visible global function definition for 'renderDT'
#>   app_server: no visible global function definition for 'datatable'
#>   app_ui: no visible global function definition for 'page_sidebar'
#>   app_ui: no visible global function definition for 'sidebar'
#>   app_ui: no visible global function definition for 'card'
#>   app_ui: no visible global function definition for 'card_header'
#>   app_ui: no visible binding for global variable 'participation'
#>   app_ui: no visible global function definition for 'navset_card_tab'
#>   app_ui: no visible global function definition for 'nav_panel'
#>   app_ui: no visible global function definition for 'leafletOutput'
#>   app_ui: no visible global function definition for 'DTOutput'
#>   Undefined global functions or variables:
#>     BCSSE CITY CONTROL DTOutput FSSE INSTNM LATITUDE LONGITUD OBEREG
#>     STABBR addCircleMarkers addTiles admin_year card card_header
#>     cons_full consortium datatable filter leaflet leafletOutput module1
#>     module1label mutate n nav_panel navset_card_tab page_sidebar
#>     participation renderDT renderLeaflet sidebar str_replace_all
#>     summarize unitid
#>   Consider adding
#>     importFrom("stats", "filter")
#>   to your NAMESPACE file.
#> 
#> 0 errors ✔ | 1 warning ✖ | 2 notes ✖
#> Error: R CMD check found WARNINGs
```

``` r
covr::package_coverage()
#> participationSearch Coverage: 50.17%
#> R/app_config.R: 0.00%
#> R/app_server.R: 0.00%
#> R/app_ui.R: 0.00%
#> R/run_app.R: 0.00%
#> R/golem_utils_server.R: 100.00%
#> R/golem_utils_ui.R: 100.00%
```
