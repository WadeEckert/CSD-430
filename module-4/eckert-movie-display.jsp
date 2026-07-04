<%-- 
Original Author: Wade Eckert
Professor: John Woods
Course: CSD 430 - Server Side Development
Assignment: Module 4.2 - Programming Assignment
Date: July 3, 2026
Description: This JSP page creates multiple Movie JavaBean objects, populates each object
using setter methods, and displays the stored data in a formatted HTML table. The page
demonstrates standard JavaBean usage by retrieving each field value through getter methods
and presenting the movie records in a clean, organized web page layout.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="module4.Movie" %>

<!--
    Create five Movie JavaBean objects using JSP action tags.

    Each bean is instantiated using its required no-argument constructor and
    stored in page scope so it can be populated with setter methods and later
    displayed through getter methods within this JSP page.
-->
<jsp:useBean id="movie1" class="module4.Movie" scope="page"/>
<jsp:useBean id="movie2" class="module4.Movie" scope="page"/>
<jsp:useBean id="movie3" class="module4.Movie" scope="page"/>
<jsp:useBean id="movie4" class="module4.Movie" scope="page"/>
<jsp:useBean id="movie5" class="module4.Movie" scope="page"/>

<%
    // Populate each Movie JavaBean with the same data used in the Module 2
    // Java Scriptlet Data Display assignment.

    movie1.setTitle("Interstellar");
    movie1.setGenre("Science Fiction");
    movie1.setReleaseYear(2014);
    movie1.setDirector("Christopher Nolan");
    movie1.setRating("PG-13");

    movie2.setTitle("The Dark Knight");
    movie2.setGenre("Action");
    movie2.setReleaseYear(2008);
    movie2.setDirector("Christopher Nolan");
    movie2.setRating("PG-13");

    movie3.setTitle("Inception");
    movie3.setGenre("Science Fiction");
    movie3.setReleaseYear(2010);
    movie3.setDirector("Christopher Nolan");
    movie3.setRating("PG-13");

    movie4.setTitle("The Lord of the Rings: The Fellowship of the Ring");
    movie4.setGenre("Fantasy");
    movie4.setReleaseYear(2001);
    movie4.setDirector("Peter Jackson");
    movie4.setRating("PG-13");

    movie5.setTitle("Jurassic Park");
    movie5.setGenre("Adventure");
    movie5.setReleaseYear(1993);
    movie5.setDirector("Steven Spielberg");
    movie5.setRating("PG-13");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Module 4 JSP application that displays movie data stored in JavaBean objects.">
    <meta name="author" content="Wade Eckert">

    <title>Movie JavaBean Data Display</title>

    <link rel="stylesheet" href="eckert-style.css">
</head>

<body>

    <main class="page-container"> <!-- Main content container starts here-->

        <header class="page-header"> <!-- Page header section starts here-->
            <h1>Movie Data Display</h1>

            <p>
                This page demonstrates how JavaBeans can be used within a JSP page to
                organize and display structured movie information in a professional
                HTML table.
            </p>

        </header> <!-- End of page header section -->

        <section class="description-section"> <!-- Description section starts here -->
            <h2>Data Description</h2>

            <p>
                Each row in the table represents one movie record. Each record is stored
                as a separate Movie JavaBean object.
            </p>

            <p>
                Each movie record contains five fields: title, genre, release year,
                director, and MPAA rating. The data is stored in Movie JavaBean objects,
                populated with setter methods, and displayed using getter methods.
            </p>
        </section> <!-- End of description section -->

        <!--
            Movie Data Table

            The table below retrieves each value from the Movie JavaBean objects
            using getter methods. This keeps the movie fields private inside the
            JavaBean while still allowing the JSP page to display the data.
        -->
        <section class="table-section"> <!-- Table section starts here -->

            <h2>Movie Collection</h2>

            <table>
                <caption>Movie Collection Stored Using JavaBeans</caption>

                <thead>
                    <tr>
                        <th>Movie Title</th>
                        <th>Genre</th>
                        <th>Release Year</th>
                        <th>Director</th>
                        <th>MPAA Rating</th>
                    </tr>
                </thead>

                <tbody>
                    <tr>
                        <td><%= movie1.getTitle() %></td>
                        <td><%= movie1.getGenre() %></td>
                        <td><%= movie1.getReleaseYear() %></td>
                        <td><%= movie1.getDirector() %></td>
                        <td><%= movie1.getRating() %></td>
                    </tr>

                    <tr>
                        <td><%= movie2.getTitle() %></td>
                        <td><%= movie2.getGenre() %></td>
                        <td><%= movie2.getReleaseYear() %></td>
                        <td><%= movie2.getDirector() %></td>
                        <td><%= movie2.getRating() %></td>
                    </tr>

                    <tr>
                        <td><%= movie3.getTitle() %></td>
                        <td><%= movie3.getGenre() %></td>
                        <td><%= movie3.getReleaseYear() %></td>
                        <td><%= movie3.getDirector() %></td>
                        <td><%= movie3.getRating() %></td>
                    </tr>

                    <tr>
                        <td><%= movie4.getTitle() %></td>
                        <td><%= movie4.getGenre() %></td>
                        <td><%= movie4.getReleaseYear() %></td>
                        <td><%= movie4.getDirector() %></td>
                        <td><%= movie4.getRating() %></td>
                    </tr>

                    <tr>
                        <td><%= movie5.getTitle() %></td>
                        <td><%= movie5.getGenre() %></td>
                        <td><%= movie5.getReleaseYear() %></td>
                        <td><%= movie5.getDirector() %></td>
                        <td><%= movie5.getRating() %></td>
                    </tr>
                </tbody>
            </table>

        </section> <!-- End of movie data table section -->

    </main> <!-- End of main content container -->

</body>
</html>