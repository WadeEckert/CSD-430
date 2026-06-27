<%--
Original Author: Wade Eckert
Professor: John Woods
Course: CSD 430 - Server Side Development
Assignment: Module 3.2 - Programming Assignment
Date: June 27, 2026
Description: This JSP page receives job application form data submitted from eckert-job-application.jsp.
It retrieves the applicant's submitted information from the request object and displays
the results in a structured table.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.HashMap" %>

<%!
    // Escape special HTML characters before displaying user-submitted values back on the page.
    public String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    // Retrieve submitted form values from the HTTP request using the matching form field names.
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String position = request.getParameter("position");
    String education = request.getParameter("education");
    String experience = request.getParameter("experience");
    String availability = request.getParameter("availability");

    // Store validation errors by field name so the form page can display each message near the correct input.
    Map<String, String> errors = new HashMap<String, String>();

    // Regular expressions used to validate the email and phone number formats.
    String emailPattern = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
    String phonePattern = "^\\d{3}-\\d{3}-\\d{4}$";

    // Validate each form field and add any errors to the errors map if validation fails.
    if (firstName == null || firstName.trim().isEmpty()) {
        errors.put("firstName", "First name is required.");
    }

    if (lastName == null || lastName.trim().isEmpty()) {
        errors.put("lastName", "Last name is required.");
    }

    // Check the email format against the regular expression for the email pattern.
    if (email == null || email.trim().isEmpty()) {
        errors.put("email", "Email address is required.");
    } else if (!email.matches(emailPattern)) {
        errors.put("email", "Please enter an email in the format example@domain.com.");
    }

    // Check the phone number format against the regular expression for the phone pattern.
    if (phone == null || phone.trim().isEmpty()) {
        errors.put("phone", "Phone number is required.");
    } else if (!phone.matches(phonePattern)) {
        errors.put("phone", "Please enter a phone number in the format 123-456-7890.");
    }

    if (position == null || position.trim().isEmpty()) {
        errors.put("position", "Please select a position.");
    }

    if (education == null || education.trim().isEmpty()) {
        errors.put("education", "Please select an education level.");
    }

    /*
        Validate the experience field to ensure it is a valid whole number greater than 0 and no more than 60.
        Wrapped in a try-catch block to handle potential NumberFormatException.
    */
    if (experience == null || experience.trim().isEmpty()) {
        errors.put("experience", "Years of experience is required.");
    } else {
        try {
            int yearsExperience = Integer.parseInt(experience);

            if (yearsExperience <= 0 || yearsExperience > 60) {
                errors.put("experience", "Years of experience must be greater than 0 and no more than 60.");
            }
        } catch (NumberFormatException e) {
            errors.put("experience", "Years of experience must be entered as a whole number.");
        }
    }

    if (availability == null || availability.trim().isEmpty()) {
        errors.put("availability", "Please select your availability.");
    }

    /*
        If validation errors exist, the submitted values and error messages are placed
        into the request object before forwarding the user back to the form page.
        Forwarding keeps the request data available so the form can show the errors
        and preserve the user's previously entered information.
    */
    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);

        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("position", position);
        request.setAttribute("education", education);
        request.setAttribute("experience", experience);
        request.setAttribute("availability", availability);

        request.getRequestDispatcher("eckert-job-application.jsp").forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="A job application summary page that displays submitted applicant information in a structured format.">
    <meta name="author" content="Wade Eckert">
    <link rel="stylesheet" href="eckert-styles.css">
    <title>Application Summary</title>
</head>
<body>

    <main>
        <header>
            <h1>Application Summary</h1>
            <p>Please review the submitted job application information below.</p>
        </header>

        <table>
            <caption>Submitted Job Application Details</caption>
            <tr>
                <th>Application Field</th>
                <th>Submitted Information</th>
            </tr>
            <tr>
                <td>First Name</td>
                <td><%= escapeHtml(firstName) %></td>
            </tr>
            <tr>
                <td>Last Name</td>
                <td><%= escapeHtml(lastName) %></td>
            </tr>
            <tr>
                <td>Email Address</td>
                <td><%= escapeHtml(email) %></td>
            </tr>
            <tr>
                <td>Phone Number</td>
                <td><%= escapeHtml(phone) %></td>
            </tr>
            <tr>
                <td>Position Applied For</td>
                <td><%= escapeHtml(position) %></td>
            </tr>
            <tr>
                <td>Highest Education Level</td>
                <td><%= escapeHtml(education) %></td>
            </tr>
            <tr>
                <td>Years of Experience</td>
                <td><%= escapeHtml(experience) %></td>
            </tr>
            <tr>
                <td>Availability</td>
                <td><%= escapeHtml(availability) %></td>
            </tr>
        </table>

        <p>
            <a href="eckert-job-application.jsp">Return to Application Form</a>
        </p>
    </main>

</body>
</html>