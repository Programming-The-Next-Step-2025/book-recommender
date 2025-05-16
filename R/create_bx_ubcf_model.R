#' Create BX UBCF Model
#'
#' @param ratingmat A normalized realRatingMatrix
#' @return A recommenderlab model object
#' @importFrom recommenderlab Recommender
#' @export
#'
#' @examples
#' library(data.table)
#' ratings <- fread("BX-Book-Ratings.csv", sep = ";", quote = "\"", encoding = "Latin-1")
#' setnames(ratings, c("User-ID", "ISBN", "Book-Rating"), c("user", "item", "rating"))
#' ratings <- ratings[rating > 0]
#' norm_mat <- normalize_bx_rating_matrix(ratings)
#' model <- create_bx_ubcf_model(norm_mat)
create_bx_ubcf_model <- function(ratingmat) {
  recommenderlab::Recommender(ratingmat, method = "UBCF")
}
