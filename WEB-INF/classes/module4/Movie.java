/*
Original Author: Wade Eckert
Professor: John Woods
Course: CSD 430 - Server Side Development
Assignment: Module 4.2 - Programming Assignment
Date: July 3, 2026
Description: This JavaBean class stores movie record data for the Module 4 JSP application.
The bean contains fields for a movie title, genre, release year, director, and rating. It uses
private instance variables with public getter and setter methods so JSP pages can safely create,
populate, and display movie objects using standard JavaBean practices.
*/

package module4;

// The Movie class implements the Serializable interface, which allows movie objects to be serialized and deserialized.
// This is important for storing and retrieving movie objects in a session or transferring them over a network.
import java.io.Serializable;

public class Movie implements Serializable {

    // This field is required for the Serializable interface to ensure that the class can be serialized and deserialized correctly.
    // The serialVersionUID is a unique identifier for the class version, which helps maintain compatibility during the serialization process.
    private static final long serialVersionUID = 1L;

    // Private fields store the data for one movie record.
    private String title;
    private String genre;
    private int releaseYear;
    private String director;
    private String rating;

    // No-argument constructor required for standard JavaBean usage.
    // This constructor allows JSP pages to create an empty movie object and then populate its fields using setter methods.
    public Movie() {
    }

    /* 
     * Convenience constructor used when all movie information is already available.
     * Although JavaBeans typically use the no-argument constructor and setter methods,
     * this constructor provides a concise way to create a fully initialized Movie object
     */
    public Movie(String title, String genre, int releaseYear, String director, String rating) {
        this.title = title;
        this.genre = genre;
        this.releaseYear = releaseYear;
        this.director = director;
        this.rating = rating;
    }

    // Getter and setter methods provide controlled access to each private field while
    // maintaining the encapsulation principles of object-oriented programming.
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public int getReleaseYear() {
        return releaseYear;
    }

    public void setReleaseYear(int releaseYear) {
        this.releaseYear = releaseYear;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }
}