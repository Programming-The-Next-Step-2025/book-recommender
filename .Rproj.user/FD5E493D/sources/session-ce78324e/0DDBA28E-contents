#' Train Recommender Model
#'
#' Builds a user-based collaborative filtering model.
#'
#' @param ratingmat A realRatingMatrix of user ratings.
#' @return A recommender model object.
#' @import recommenderlab
#' @export
train_model <- function(ratingmat) {
  Recommender(normalize(ratingmat), method = "UBCF")
}
