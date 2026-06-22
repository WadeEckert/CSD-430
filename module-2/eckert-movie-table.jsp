<%--
Original Author: Wade Eckert
Professor: John Woods
Course: CSD 430 - Server Side Development
Assignment: Module 2.2 - Programming Assignment
Date: June 21, 2026
Description: This JSP program creates a dynamic HTML page that displays a table of movie records.
The movie data is stored in Java arrays inside JSP scriptlet sections. The HTML table is built
using JSP logic to loop through each movie record and display the title, genre, release year,
director, and rating. External CSS is used to style the page.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Store movie data in separate arrays.
    // Each index position represents one complete movie record.
    String[] titles = {
        "Interstellar",
        "The Dark Knight",
        "Inception",
        "The Lord of the Rings: The Fellowship of the Ring",
        "Jurassic Park"
    };

    String[] genres = {
        "Science Fiction",
        "Action",
        "Science Fiction",
        "Fantasy",
        "Adventure"
    };

    int[] releaseYears = {
        2014,
        2008,
        2010,
        2001,
        1993
    };

    String[] directors = {
        "Christopher Nolan",
        "Christopher Nolan",
        "Christopher Nolan",
        "Peter Jackson",
        "Steven Spielberg"
    };

    String[] ratings = {
        "PG-13",
        "PG-13",
        "PG-13",
        "PG-13",
        "PG-13"
    };
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="A JSP page displaying a collection of favorite movies using dynamic content and HTML tables.">
    <meta name="author" content="Wade Eckert">
    
    <title>Favorite Movies</title>
    <link rel="stylesheet" href="eckert-style.css">
</head>
<body>

    <main class="container"> <!-- Main container starts here-->
        <h1>Wade Eckert's Favorite Movies</h1>

        <p class="description">
            This table displays a list of movies I have enjoyed watching. The data is grouped
            into topical categories including movie title, genre, release year, director, and rating.
        </p>

        <div class="table-wrapper"> <!-- Table wrapper starts here -->
        <table> <!-- Table for displaying movie data starts here -->
            <caption>Five favorite movies with their genres, release years, directors, and ratings.</caption>
            <thead> <!-- Table header starts here -->
                <tr>
                    <th>Movie Title</th>
                    <th>Genre</th>
                    <th>Release Year</th>
                    <th>Director</th>
                    <th>Rating</th>
                </tr>
            </thead> <!-- Table header ends here -->

            <tbody> <!-- Table body starts here -->
                <%
                    // Loop through the movie arrays and create one table row for each movie.
                    for (int i = 0; i < titles.length; i++) {
                %>
                    <tr>
                        <td><%= titles[i] %></td>
                        <td><%= genres[i] %></td>
                        <td><%= releaseYears[i] %></td>
                        <td><%= directors[i] %></td>
                        <td><%= ratings[i] %></td>
                    </tr>
                <%
                    }
                %>
            </tbody> <!-- Table body ends here -->
        </table> <!-- Table for displaying movie data ends here -->
        </div> <!-- Table wrapper ends here -->
    </main> <!-- Main container ends here -->

</body>
</html>
