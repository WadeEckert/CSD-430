<%--
Original Author: Wade Eckert
Professor: John Woods
Course: CSD 430 - Server Side Development
Assignment: Module 3.2 - Programming Assignment
Date: June 27, 2026
Description: This JSP page displays a job application form that collects basic applicant information,
including contact details, education level, experience, desired position, and availability.
The form submits the entered data to eckert-display-application.jsp using the POST method.
If validation errors are found, the display page forwards the request back to this form with
error messages and previously submitted values so the user can correct the application
without re-entering all information.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>

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
    // Retrieve validation errors and submitted values if the display page forwards the request back to this form.
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");

    String firstName = escapeHtml((String) request.getAttribute("firstName"));
    String lastName = escapeHtml((String) request.getAttribute("lastName"));
    String email = escapeHtml((String) request.getAttribute("email"));
    String phone = escapeHtml((String) request.getAttribute("phone"));
    String position = (String) request.getAttribute("position");
    String education = (String) request.getAttribute("education");
    String experience = escapeHtml((String) request.getAttribute("experience"));
    String availability = (String) request.getAttribute("availability");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="A job application form that collects applicant contact information, education, experience, desired position, and availability.">
    <meta name="author" content="Wade Eckert">
    <link rel="stylesheet" href="eckert-styles.css">
    <title>Job Application Form</title>
</head>
<body>

    <main>
        <header>
            <h1>Job Application Form</h1>
            <p>Please complete the form below to submit your application information.</p>
        </header>

        <% if (errors != null && !errors.isEmpty()) { %>
            <div class="error-summary">
                <p>Please correct the highlighted fields below and submit the form again.</p>
            </div>
        <% } %>

        <form action="eckert-display-application.jsp" method="post">
            <fieldset>
                <legend>Applicant Information</legend>

                <div>
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" value="<%= firstName %>">
                    <% if (errors != null && errors.get("firstName") != null) { %>
                        <span class="error-message"><%= errors.get("firstName") %></span>
                    <% } %>
                </div>  
                
                <div>
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" value="<%= lastName %>">
                    <% if (errors != null && errors.get("lastName") != null) { %>
                        <span class="error-message"><%= errors.get("lastName") %></span>
                    <% } %>
                </div>

                <div>
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="name@example.com" value="<%= email %>">
                    <% if (errors != null && errors.get("email") != null) { %>
                        <span class="error-message"><%= errors.get("email") %></span>
                    <% } %>
                </div>

                <div>
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" placeholder="123-456-7890" value="<%= phone %>">
                    <% if (errors != null && errors.get("phone") != null) { %>
                        <span class="error-message"><%= errors.get("phone") %></span>
                    <% } %>
                </div>
            </fieldset>

            <fieldset>
                <legend>Application Details</legend>

                <div>
                    <label for="position">Position Applied For</label>
                    <select id="position" name="position">
                        <option value="">-- Select a Position --</option>
                        <option value="Software Developer" <%= "Software Developer".equals(position) ? "selected" : "" %>>Software Developer</option>
                        <option value="Web Developer" <%= "Web Developer".equals(position) ? "selected" : "" %>>Web Developer</option>
                        <option value="Database Analyst" <%= "Database Analyst".equals(position) ? "selected" : "" %>>Database Analyst</option>
                        <option value="Quality Assurance Tester" <%= "Quality Assurance Tester".equals(position) ? "selected" : "" %>>Quality Assurance Tester</option>
                        <option value="Technical Support Specialist" <%= "Technical Support Specialist".equals(position) ? "selected" : "" %>>Technical Support Specialist</option>
                    </select>
                    <% if (errors != null && errors.get("position") != null) { %>
                        <span class="error-message"><%= errors.get("position") %></span>
                    <% } %>
                </div>

                <div>
                    <label for="education">Highest Education Level</label>
                    <select id="education" name="education">
                        <option value="">-- Select Education Level --</option>
                        <option value="High School Diploma" <%= "High School Diploma".equals(education) ? "selected" : "" %>>High School Diploma</option>
                        <option value="Associate Degree" <%= "Associate Degree".equals(education) ? "selected" : "" %>>Associate Degree</option>
                        <option value="Bachelor's Degree" <%= "Bachelor's Degree".equals(education) ? "selected" : "" %>>Bachelor's Degree</option>
                        <option value="Master's Degree" <%= "Master's Degree".equals(education) ? "selected" : "" %>>Master's Degree</option>
                        <option value="Doctoral Degree" <%= "Doctoral Degree".equals(education) ? "selected" : "" %>>Doctoral Degree</option>
                    </select>
                    <% if (errors != null && errors.get("education") != null) { %>
                        <span class="error-message"><%= errors.get("education") %></span>
                    <% } %>
                </div>

                <div>
                    <label for="experience">Years of Experience</label>
                    <input type="number" id="experience" name="experience" value="<%= experience %>">
                    <% if (errors != null && errors.get("experience") != null) { %>
                        <span class="error-message"><%= errors.get("experience") %></span>
                    <% } %>
                </div>
            </fieldset>
            
            <fieldset>
                <legend>Availability</legend>

                <div>
                    <input type="radio" id="fullTime" name="availability" value="Full-Time" <%= "Full-Time".equals(availability) ? "checked" : "" %>>
                    <label for="fullTime">Full-Time</label>
                </div>

                <div>
                    <input type="radio" id="partTime" name="availability" value="Part-Time" <%= "Part-Time".equals(availability) ? "checked" : "" %>>
                    <label for="partTime">Part-Time</label>
                </div>

                <div>
                    <input type="radio" id="flexible" name="availability" value="Flexible" <%= "Flexible".equals(availability) ? "checked" : "" %>>
                    <label for="flexible">Flexible</label>
                </div>

                <% if (errors != null && errors.get("availability") != null) { %>
                    <span class="error-message"><%= errors.get("availability") %></span>
                <% } %>
            </fieldset>

            <div>
                <button type="submit">Submit Application</button>
                <a href="eckert-job-application.jsp" class="button secondary-button">Clear Form</a>
            </div>
        </form>
    </main>

</body>
</html>
