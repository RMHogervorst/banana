
<!-- README.md is generated from README.Rmd. Please edit that file -->

# banana

<!-- badges: start -->

<!-- badges: end -->

The goal of banana is to measure everything in bananas. Using bananas to
measure things is on old meme that I still dearly love. At my recent
trip to New Zealand I took pictures with bananas to measure things all
the time. WEIRD SENTANCE

But bananas are an interesting metric, and maybe show why the Brits and
Americans just can’t let go of the feet: You are able to intuitively
understand how big a banana is.

It is a nice approximation. and so in this package everything returns in
bananas and because I can’t imagine 1.23 banana, everything gets rounded
up or down to the nearest small or large banana.

## Installation

You can install the released version of banana from
[CRAN](https://CRAN.R-project.org) with:

``` r
#install.packages("banana")
```

## Example

This is a basic example which shows you how to solve a common problem:
Turning ordinary sizes into banana approximations.

``` r
library(banana)
library(units)
#> udunits system database from /Library/Frameworks/R.framework/Versions/3.6/Resources/library/units/share/udunits
macbook <- set_units(c(13, 13.3, 16), "in")
macbook
#> Units: [in]
#> [1] 13.0 13.3 16.0
```

``` r
bananamac <- as_banana(macbook)
bananamac
#> <banana[3]>
#> [1] 2 small 2 small 2 large
data.frame(bananamac)
#>   bananamac
#> 1   2 small
#> 2   2 small
#> 3   2 large
str(bananamac)
#>  🍌 [1:3] 2 small, 2 small, 2 large
```

The interesting thing I’m trying to create here is a vector that behaves
just like normal double vectors but displays in bananas.

The values are still there, in metrics.

``` r
as.numeric(bananamac)
#> [1] 33.02 33.78 40.64
to_units(bananamac)
#> Units: [cm]
#> [1] 33.02 33.78 40.64
```

#### References

  - The banana for scale meme started in 2005\!
    <https://knowyourmeme.com/memes/banana-for-scale>
