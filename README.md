
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Banana 🍌

<!-- badges: start -->

<!-- badges: end -->

The goal of banana is to measure everything in bananas. Using bananas to
measure things is on old meme that I still dearly love\[1\]. I still
sometimes take pictures with bananas for scale\!

But bananas are an interesting metric, and maybe show why the Brittish
and American people just can’t seem to let go of the feet: You are able
to intuitively understand how big a banana is.

A banana is a nice approximation when precision is just not that
important. And so in this package every banana vector has size bananas
and because I can’t imagine 1.23 banana, everything gets rounded up or
down to the nearest small or large banana.

First how to install it and than how to use it:

## Installation

You can install the released version of banana from
[CRAN](https://CRAN.R-project.org) with:

``` r
#install.packages("banana") # not on cran
devtools::install_github("RMHogervorst/banana")
```

## Examples 🍌

This is a basic example which shows you how to solve a common problem:
Turning ordinary sizes into banana approximations.

For instance I’m working on a macbook from early 2015 which is 13 inch
in diagonal, and according to a website the new models are 13.3 and 16
inches. As a european I don’t understand these sizes, but I do
understand bananas\!

``` r
library(banana)
library(units)
#> udunits system database from /Library/Frameworks/R.framework/Versions/3.6/Resources/library/units/share/udunits
```

``` r
# create unit size vector.
macbook <- set_units(c(13, 13.3, 16), "in")
macbook
#> Units: [in]
#> [1] 13.0 13.3 16.0
```

Let’s turn these non-intuitive inches (thumb size?) into something
recognizable: bananas\!

``` r
bananamac <- as_banana(macbook)
bananamac
#> <banana[3]>
#> [1] 2 small 2 small 2 large
```

The banana vector uses the {vctrs} package and tells us there are 3
items in this vector. Two are the size of 2 small bananas and one is the
size of 2 large bananas. Very clear what size that is\!

bananas are just like normal vectors: You can subset them.

``` r
bananamac[2:3]
#> <banana[2]>
#> [1] 2 small 2 large
```

Turn them into dataframes

``` r
data.frame(bananamac)
#>   bananamac
#> 1   2 small
#> 2   2 small
#> 3   2 large
```

Or look at their structure

``` r
str(bananamac)
#>  🍌 [1:3] 2 small, 2 small, 2 large
```

The interesting thing I’m trying to create here is a vector that behaves
just like normal double vectors but displays in bananas.

The values are still there, in centimeter or in units (cm)

``` r
as.numeric(bananamac)
#> [1] 33.02 33.78 40.64
to_units(bananamac)
#> Units: [cm]
#> [1] 33.02 33.78 40.64
```

But the values are displayed as whole bananas.

The underlying values are still there though:

``` r
bananamac2 <- 1.23 * bananamac
bananamac2
#> <banana[3]>
#> [1] 2 large 2 large 2 large
```

The first element has not turned into 1.23 \* 2 = 2.46 small bananas,
but into 2 large bananas.

``` r
bananamac[[1]]
#> <banana[1]>
#> [1] 2 small
bananamac2[[1]]
#> <banana[1]>
#> [1] 2 large
```

Because only the print method is changed not the underlying data.

``` r
as.numeric(bananamac[[1]])
#> [1] 33.02
as.numeric(bananamac2[[1]])
#> [1] 40.61
```

Have fun with this package\!

#### References 🍌

\[1\]: [The banana for scale meme started in 2005\!
\<https://knowyourmeme.com/memes/banana-for-scale\>](https://knowyourmeme.com/memes/banana-for-scale)

## Code of conduct

Please note that the ‘banana’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
