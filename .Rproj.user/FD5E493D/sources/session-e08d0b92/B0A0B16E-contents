# Load and preprocess data
books_raw <- fread("BX-Books.csv", sep = ";", quote = "\"", encoding = "Latin-1")
ratings <- fread("BX-Book-Ratings.csv", sep = ";", quote = "\"", encoding = "Latin-1")

# Rename columns
setnames(books_raw, c("ISBN", "Book-Title", "Book-Author"), c("item", "title", "author"))
setnames(ratings, c("User-ID", "ISBN", "Book-Rating"), c("user", "item", "rating"))

# Clean whitespace
books_raw[, `:=`(item = trimws(item), title = trimws(title), author = trimws(author))]
ratings[, item := trimws(item)]

# Filter out low-quality data
ratings <- ratings[rating > 0]
ratings <- ratings[user %in% ratings[, .N, by = user][N >= 10]$user]
ratings <- ratings[item %in% ratings[, .N, by = item][N >= 20]$item]

# Build rating matrix
ratingmat <- as(ratings[, .(user, item, rating)], "realRatingMatrix")
ratingmat <- ratingmat[1:min(1000, nrow(ratingmat))]

# Train model
model <- Recommender(normalize(ratingmat), method = "UBCF")

# Deduplicate books
books_raw[, `:=`(
  norm_title = tolower(gsub("[^a-z0-9]", "", title)),
  norm_author = tolower(gsub("[^a-z0-9]", "", author))
)]

book_counts <- ratings[, .N, by = item]
books_merged <- merge(books_raw, book_counts, by = "item", all.x = TRUE)
books_merged[is.na(N), N := 0]
setorder(books_merged, -N)

books <- books_merged[, .SD[1], by = .(norm_title, norm_author)]
books[, display := paste0(title, " by ", author)]

# UI
ui <- fluidPage(
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

server <- function(input, output, session) {
  user_ratings <- reactiveVal(list())
  
  filtered_books <- reactive({
    query <- tolower(trimws(input$search))
    if (query == "") return(books)
    books[grepl(query, tolower(title)) | grepl(query, tolower(author))]
  })
  
  output$books_ui <- renderUI({
    valid_items <- colnames(ratingmat)
    sample_books <- filtered_books()[item %in% valid_items]
    if (nrow(sample_books) == 0) return(NULL)
    sample_books <- sample_books[sample(.N, min(.N, 12))]
    
    fluidRow(
      lapply(seq_len(nrow(sample_books)), function(i) {
        book <- sample_books[i]
        isbn <- book$item
        img_url <- paste0("https://covers.openlibrary.org/b/isbn/", isbn, "-M.jpg")
        
        column(2,
               tags$div(style = "text-align:center;",
                        tags$img(src = img_url, height = "150px"),
                        tags$p(strong(book$title)),
                        tags$p(em(book$author)),
                        prettyRadioButtons(
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
  
  observeEvent(input$get_recs, {
    all_inputs <- reactiveValuesToList(input)
    rated_inputs <- Filter(function(x) x != "" && !is.null(x), all_inputs[grepl("^star_", names(all_inputs))])
    
    if (length(rated_inputs) < 5) {
      output$recommendations <- renderTable({
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
    new_user <- as(matrix(new_user, nrow = 1), "realRatingMatrix")
    
    prediction <- predict(model, new_user, n = 5)
    recommendations <- as(prediction, "list")[[1]]
    
    if (length(recommendations) == 0) {
      output$recommendations <- renderTable({
        data.frame(Message = "❌ No recommendations found. Try rating different books.")
      })
    } else {
      output$recommendations <- renderTable({
        books[item %in% recommendations, .(Title = title, Author = author)]
      })
    }
  })
}

shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))

