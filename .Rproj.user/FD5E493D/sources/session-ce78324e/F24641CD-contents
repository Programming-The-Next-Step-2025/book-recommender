#' Book Recommender Server Logic
#'
#' @param input Shiny input
#' @param output Shiny output
#' @param session Shiny session
#' @param books Book metadata
#' @param ratingmat User-book rating matrix
#' @param model Trained recommender model
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyWidgets prettyRadioButtons
#' @import data.table
#' @import methods
#' @import recommenderlab
#' @export
app_server <- function(input, output, session, books, ratingmat, model) {
  user_ratings <- shiny::reactiveVal(list())

  filtered_books <- shiny::reactive({
    query <- tolower(trimws(input$search))
    if (query == "") return(books)
    books[grepl(query, tolower(title)) | grepl(query, tolower(author))]
  })

  output$books_ui <- shiny::renderUI({
    valid_items <- colnames(ratingmat)
    sample_books <- filtered_books()[item %in% valid_items]
    if (nrow(sample_books) == 0) return(NULL)
    sample_books <- sample_books[sample(.N, min(.N, 12))]

    shiny::fluidRow(
      lapply(seq_len(nrow(sample_books)), function(i) {
        book <- sample_books[i]
        isbn <- book$item
        img_url <- paste0("https://covers.openlibrary.org/b/isbn/", isbn, "-M.jpg")

        shiny::column(2,
                      shiny::tags$div(style = "text-align:center;",
                                      shiny::tags$img(src = img_url, height = "150px"),
                                      shiny::tags$p(shiny::strong(book$title)),
                                      shiny::tags$p(shiny::em(book$author)),
                                      shinyWidgets::prettyRadioButtons(
                                        inputId = paste0("star_", isbn),
                                        label = "Your Rating:",
                                        choices = 1:5,
                                        shape = "round",
                                        outline = TRUE,
                                        fill = TRUE,
                                        status = "info",
                                        inline = TRUE
                                      )
                      )
        )
      })
    )
  })

  shiny::observeEvent(input$get_recs, {
    all_inputs <- shiny::reactiveValuesToList(input)
    rated_inputs <- Filter(function(x) x != "" && !is.null(x), all_inputs[grepl("^star_", names(all_inputs))])

    if (length(rated_inputs) < 5) {
      output$recommendations <- shiny::renderTable({
        data.frame(Message = "⚠️ Please rate at least 5 books that are in the system's database.")
      })
      return()
    }

    rating_values <- sapply(rated_inputs, as.numeric)
    names(rating_values) <- sub("^star_", "", names(rating_values))

    new_user <- rep(NA, ncol(ratingmat))
    names(new_user) <- colnames(ratingmat)
    matched <- intersect(names(rating_values), colnames(ratingmat))
    new_user[matched] <- rating_values[matched]
    new_user <- methods::as(matrix(new_user, nrow = 1), "realRatingMatrix")

    prediction <- recommenderlab::predict(model, new_user, n = 5)
    recommendations <- methods::as(prediction, "list")[[1]]

    if (length(recommendations) == 0) {
      output$recommendations <- shiny::renderTable({
        data.frame(Message = "❌ No recommendations found. Try rating different books.")
      })
    } else {
      output$recommendations <- shiny::renderTable({
        books[item %in% recommendations, .(Title = title, Author = author)]
      })
    }
  })
}
