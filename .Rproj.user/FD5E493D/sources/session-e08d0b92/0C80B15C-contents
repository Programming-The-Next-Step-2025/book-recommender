#' Load and Clean Book Data
#'
#' This function loads and preprocesses book and rating data.
#'
#' @return A list containing cleaned books, ratings, and ratingmat.
#' @import data.table
#' @import recommenderlab
#' @import methods
#' @export
load_book_data <- function() {
  books <- data.table::fread("BX-Books.csv", sep = ";", quote = "\"", encoding = "Latin-1")
  ratings <- data.table::fread("BX-Book-Ratings.csv", sep = ";", quote = "\"", encoding = "Latin-1")

  data.table::setnames(books, old = c("ISBN", "Book-Title", "Book-Author"), new = c("item", "title", "author"))
  data.table::setnames(ratings, old = c("User-ID", "ISBN", "Book-Rating"), new = c("user", "item", "rating"))

  books[, item := trimws(item)]
  ratings[, item := trimws(item)]
  ratings <- ratings[rating > 0]
  user_counts <- ratings[, .N, by = user][N >= 10]
  ratings <- ratings[user %in% user_counts$user]
  item_counts <- ratings[, .N, by = item][N >= 20]
  ratings <- ratings[item %in% item_counts$item]

  ratingmat <- methods::as(ratings[, .(user, item, rating)], "realRatingMatrix")
  ratingmat <- ratingmat[1:min(1000, nrow(ratingmat))]

  list(books = books, ratings = ratings, ratingmat = ratingmat)
}
