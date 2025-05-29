# 📚 Book Recommender App

This is an interactive book recommender application built with R and Shiny. Users can search for books, rate them by clicking on star widgets, and receive personalized recommendations based on a collaborative filtering algorithm. The app processes and cleans real-world datasets to offer a streamlined user experience.

## 🚀 Features

- Search for books by title
- Rate books interactively using star widgets
- Get personalized book recommendations after rating at least 5 titles
- Book cover images fetched dynamically using ISBN
- Recommendation engine based on collaborative filtering (user-based)
- Uses real book rating data, cleaned and filtered for quality

## 🛠️ Technologies Used

- R
- Shiny – for building the web app UI
- recommenderlab – for collaborative filtering
- data.table – for fast data manipulation
- shinyjs and shinyWidgets – for enhanced interactivity and styling

## 📂 Dataset

The app uses pre-cleaned versions of the Book-Crossing dataset including:
- BX-Books.csv: Book metadata
- BX-Book-Ratings.csv: User ratings
You can replace these CSV files with your own dataset as long as the format matches.

## 📦 Recommendation Logic

- Collaborative filtering using a User-Based Collaborative Filtering (UBCF) model.
- Built on a normalized realRatingMatrix.
- Uses the most active users and popular items for efficiency and accuracy.
- Predictions are generated dynamically based on user input.
