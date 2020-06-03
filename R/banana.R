# an incredibly convoluted way to define a banana.
banana_size <- units::set_units(units::set_units(c(7, 9), "in"), "cm")
names(banana_size) <- c("small", "large")


banana_emoji <- c(loc= "1F34C", bytes="F0 9F 8D 8C", html_dec ="&#127820;", icon="🍌")



#' Find the best fitting banana
best_banana_fit <- function(numeric_vector) {
  banana_matches <- match_banana_sizes(numeric_vector)
  banana_decision <- banana_size_picker(banana_matches)
  banana_decision
}

force_to_cm <- function(numeric_vector){
  units(numeric_vector) <- with(units::ud_units, "cm")
  warning("converting double to units. This assumes the vector is in cm")
  numeric_vector_in_cm_unitless<- units::drop_units(numeric_vector)
  numeric_vector_in_cm_unitless
}

set_unit_to_cm <- function(unit_vector){
  units(unit_vector) <- with(units::ud_units, "cm")
  unit_vector
}
turn_into_units <- function(bananavec){
  units::as_units(as.double(bananavec), "cm")
}

units_to_banana <- function(unitvector){
  banana(set_unit_to_cm(unitvector))
}

to_units <- function(x) turn_into_units(x)

#' assumes in cm unitless
#' @noRd
match_banana_sizes <- function(vec) {
  vec <- vec_cast(vec, double())
  bananas <- units::drop_units(banana_size)
  frame <- data.frame(stringsAsFactors = FALSE, vec = vec, large = 0, small = 0)
  frame$large <- vec / bananas[["large"]]
  frame$small <- vec / bananas[["small"]]
  frame
}

banana_size_picker <- function(banana_size_frame) {
  r_large <- round(banana_size_frame$large, 0)
  r_small <- round(banana_size_frame$small, 0)
  abs_large <- abs(r_large - banana_size_frame$large)
  abs_small <- abs(r_small - banana_size_frame$small)
  result <- data.frame(
    stringsAsFactors = FALSE,
    size = ifelse(abs_small < abs_large, "small", "large"),
    amount = r_large
  )
  result$amount[(abs_small < abs_large) &  !is.na(banana_size_frame$vec)] <- r_small[(abs_small < abs_large) &  !is.na(banana_size_frame$vec)]
  result
}

print_bananas <- function(x){
  out <- best_banana_fit(x)
  l_missing <- is.na(out$size)
  l_small <- (out$size=="small" )& (!l_missing)
  l_large <- (out$size=="large" )& (!l_missing)
  out$print[l_small] = paste0(out$amount[l_small], " small")
  out$print[l_large] = paste0(out$amount[l_large], " large")
  out$print[l_missing] <- NA
  out$print[out$amount==0] = "0"
  out[["print"]]
}

banana_plural<- function(vec){
  result <- rep("bananas", length(vec))
  result[vec == 1] <- "banana"
  result
}


#' @export
new_banana <- function(x = double()) {
  new_vctr(x, class = "banana")
}

#' `banana` vector
#'
#' This creates a double vector that represents banana so when it is
#' printed, it is converted and displayed as 🍌.
#' However the underlying structure is still units vector.
#'
#' @param x A numeric vector
#' @return An S3 vector of class `banana`.
#' @export
#' @examples
#' banana(c(0.25, 0.5, 0.75))
banana <- function(x = double()) {
  new_banana(x)
}

#' @export
#' @rdname banana
is_banana <- function(x) {
  inherits(x, "banana")
}

#' @export
#' @rdname banana
#' @param x object to convert into banana
as_banana <- function(x) {
  vec_cast(x, new_banana())
}

#' @export
vec_ptype_abbr.banana <- function(x, ...) {
  "🍌"
}

#' @export
vec_ptype2.banana.banana <- function(x, y, ...) new_banana()

#' @export
vec_ptype2.banana.double <- function(x, y, ...) banana()
#' @export
vec_ptype2.double.banana <- function(x, y, ...) banana()
#' @export
vec_ptype2.banana.integer <- function(x, y, ...) banana()
#' @export
vec_ptype2.integer.banana <- function(x, y, ...) banana()
#' @export
vec_cast.banana.double <- function(x, to, ...) banana(x)
#' @export
vec_cast.double.banana <- function(x, to, ...) vec_data(x)
#' @export
vec_cast.banana.integer <- function(x, to, ...) banana()
#' @export
vec_cast.integer.banana <- function(x, to, ...) as.integer(vec_data(x))
# from units to banana and back
#' @export
vec_cast.banana.units <- function(x, to, ...) units_to_banana(x)
#' @export
vec_cast.units.banana <- function(x, to, ...) turn_into_units(x)
#' @export
vec_cast.double.units <- function(x, to, ...) units::drop_units(x)

#' @export
vec_arith.banana <- function(op, x, y, ...) {
  UseMethod("vec_arith.banana", y)
}

#' @export
vec_arith.banana.default <- function(op, x, y, ...) {
  stop_incompatible_op(op, x, y)
}

#' @export
vec_arith.banana.MISSING <- function(op, x, y, ...) {
  switch(op,
         `-` = x * -1,
         `+` = x,
         stop_incompatible_op(op, x, y)
  )
}

#' @export
vec_arith.banana.numeric <- function(op, x, y, ...) {
  switch(
    op,
    "+" = new_banana(vec_arith_base(op, x, y)),
    "-" = new_banana(vec_arith_base(op, x, y)),
    "/" = new_banana(vec_arith_base(op, x, y)),
    "*" = new_banana(vec_arith_base(op, x, y)),
    stop_incompatible_op(op, x, y)
  )
}

#' @export
vec_arith.numeric.banana <- function(op, x, y, ...) {
  switch(
    op,
    "+" = new_banana(vec_arith_base(op, x, y)),
    "-" = new_banana(vec_arith_base(op, x, y)),
    "/" = new_banana(vec_arith_base(op, x, y)),
    "*" = new_banana(vec_arith_base(op, x, y)),
    stop_incompatible_op(op, x, y)
  )
}

#' @export
format.banana <- function(x, ...) {
  if(length(x)>0){
  print_bananas(x)
  }
}

#' @export
as_text <- function(banana){
  as.character(print_bananas(banana))
}
