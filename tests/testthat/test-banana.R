test_that("bananas are correctly defined",{
  expect_equal(names(banana_size),c("small", "large"))
  expect_equal(banana_size, units::set_units(c(small=17.78,large=22.86),"cm"))
})

test_that("banana chooser works", {
    sizes = units::set_units(c(17.5, 23, 35.56, 45.5),"cm")
    bananas <- data.frame(
      stringsAsFactors = FALSE,
      size =c("small", "large", "small", "large"),
      amount =c(1,1,2,2)
      )
    expect_equal(
      best_banana_fit(sizes),
      bananas
    )
})

test_that("lenghts are set to cm",{
  input1 <- units::set_units(c(1, 1.4, 0.02), "m")
  input2 <- units::set_units(c(1, 1.4, 0.02), "in")
  expect_equal(
    suppressWarnings(force_to_cm(input1)),
    c(100, 140, 2)
  )
  expect_equal(suppressWarnings(force_to_cm(input2)),
               c(2.5400, 3.5560, 0.0508))
  expect_warning(force_to_cm(input2),regexp = "converting double to units")
})


test_that("non lengths will error",{
  input <- units::set_units(c(1, 1.4, 0.02), "s")
  expect_error(force_to_cm(input))
  input <- units::set_units(c(1, 1.4, 0.02), "kg")
  expect_error(force_to_cm(input), regexp = "cannot convert kg into cm")
})

test_that("warning is given on no units",{
  expect_warning(force_to_cm(c(1,1,1)))
})

test_that("bananas are correctly matched",{
  input <- c(seq(16, 60, 3))
  expected <- data.frame(
    stringsAsFactors = FALSE,
    vec = input,
    large = input/22.86,
    small= input/17.78
  )
  expect_equal(
    match_banana_sizes(input), expected
  )
})

test_that("banana_size_picker",{
  input <- match_banana_sizes(c(16, 22, 50))
  expected <- data.frame(
    stringsAsFactors = FALSE,
    size = c("small", "large", "large"),
    amount = c(1,1,2)
  )
  expect_equal(banana_size_picker(input), expected)
})

test_that("banana size picker handles NA",{
  input <- match_banana_sizes(c(17, 45.5, 0, NA))
  expected <- data.frame(
    stringsAsFactors = FALSE,
    size = c("small", "large", "large", NA),
    amount = c(1,2,0, NA)
  )
  expect_equal(banana_size_picker(input), expected)
})

test_that("plural works", {
  expect_equal(banana_plural(c(1, 2)), c("banana","bananas"))
})


test_that("print banana works",{
  expect_equal(
    print_bananas(c(17, 45.5, 0, NA)),
    c("1 small", "2 large", "0", NA)
  )
})

test_that("basic functionality of vector works",{
  nothing <- banana()
  expect_true(is_banana(nothing))
})

test_that("new banana works",{
  input_vec<-  units::set_units(c(17.5, 23, 35.56, 45.5),"cm")
  result <- new_banana(input_vec)
  expect_true(is_banana(result))
})


# all the conversions are tested
# basicly, it should always behave as units, only the print method is different.
test_that("casting are correct",{
  # explicit changes
  # coercion: as.double, as.numeric() return underlying length in cm without unit
  expect_equal(vec_ptype2(integer(), banana()), banana())
  expect_true(is.double(vec_cast(banana(21), double())))
  #expect_equal(class(vec_cast(banana(21), as_units())), "units")
  expect_true(is_banana(vec_cast(units::set_units(21, "cm"), banana())))
  expect_true(is_banana(vec_cast(3L, banana())))
  expect_equal(class(vec_cast(banana(c(1,2,3)), integer())), "integer")
  #
})

test_that("coercions are correct",{
  # implicit changes
  # units::as_units() should return in cm with unit cm.
  expect_equal(vec_ptype2(banana(), banana()), banana())
  expect_equal(vec_ptype2(banana(), double()), banana())
  expect_equal(vec_ptype2(double(), banana()), banana())
})

test_that("math works",{
  vec <- c(20, 0, NA, 50)
  banana_vec <- as_banana(vec)
  expect_equal(
    vec * 2, as.double(banana_vec * 2)
  )
  expect_equal(
    vec + 1, as.double(banana_vec + 1)
  )
  expect_equal(
    -vec, as.double(-banana_vec)
  )
  expect_equal(
    vec*2, as.double(banana_vec*2)
  )
  expect_equal(
    sqrt(vec), as.double(sqrt(banana_vec))
  )
})
