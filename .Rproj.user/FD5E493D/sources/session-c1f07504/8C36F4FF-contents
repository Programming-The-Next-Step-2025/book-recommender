#' Normalize BX Book Ratings Matrix
#'
#' This function filters and normalizes the Book-Crossing ratings data.
#'
#' @param ratings A data.table with columns: user, item, rating.
#' @return A normalized `realRatingMatrix` object from recommenderlab.
#' @importFrom recommenderlab normalize
#' @importFrom methods as
#' @import data.table
#' @export
#' @examples
#' library(data.table)
#' ratings <- fread("BX-Book-Ratings.csv", sep = ";", quote = "\"", encoding = "Latin-1")
#' setnames(ratings, c("User-ID", "ISBN", "Book-Rating"), c("user", "item", "rating"))
#' ratings <- ratings[rating > 0]
#' norm_mat <- normalize_bx_rating_matrix(ratings)
normalize_bx_rating_matrix <- function(ratings) {
  ratings <- ratings[rating > 0]
  user_counts <- ratings[, .N, by = user][N >= 10]
  ratings <- ratings[user %in% user_counts$user]
  item_counts <- ratings[, .N, by = item][N >= 20]
  ratings <- ratings[item %in% item_counts$item]

  ratingmat <- methods::as(ratings[, .(user, item, rating)], "realRatingMatrix")
  ratingmat <- ratingmat[1:min(1000, nrow(ratingmat))]
  normalize(ratingmat)
}
