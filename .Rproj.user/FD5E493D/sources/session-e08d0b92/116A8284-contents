#' Book Recommender UI
#'
#' @return Shiny UI definition.
#' @import shiny
#' @import shinyjs
#' @export
app_ui <- function() {
  fluidPage(
    useShinyjs(),
    titlePanel("📚 Book Recommender"),
    h5("⭐ Rate at least 5 books below to get personalized recommendations."),

    textInput("search", "🔍 Search books by title or author:", placeholder = "e.g., Tolkien, Harry Potter"),
    actionButton("get_recs", "Get Recommendations", class = "btn btn-primary"),

    br(), br(),
    uiOutput("books_ui"),

    h3("📖 Your Recommendations"),
    tableOutput("recommendations")
  )
}
