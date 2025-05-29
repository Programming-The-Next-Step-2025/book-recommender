#' Run the Book Recommender App
#'
#' Launches the app in the default browser.
#'
#' @import shiny
#' @export
run_app <- function() {
  data <- load_book_data()
  model <- train_model(data$ratingmat)
  shiny::shinyApp(
    ui = app_ui(),
    server = function(input, output, session) {
      app_server(input, output, session, data$books, data$ratingmat, model)
    },
    options = list(launch.browser = TRUE)
  )
}
