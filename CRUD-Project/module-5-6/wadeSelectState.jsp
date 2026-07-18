<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Modules 5.3 and 6.3 - CRUD Project Part 1
    Date: July 17, 2026
    File Name: wadeSelectState.jsp
    Description: Connects to the CSD430 database and uses the State JavaBean
                 to retrieve state IDs and names for an HTML dropdown menu.
                 After the user selects a state, the page loads the complete
                 record through the bean and displays all eight fields in a
                 formatted HTML table on the same page.
--%>

<%--
    The page directive establishes Java as the JSP scripting language,
    imports the JDBC, collection, formatting, and JavaBean classes used by
    this page, and applies UTF-8 character encoding.
--%>
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.SQLException,
                 java.util.ArrayList,
                 java.util.List,
                 java.text.NumberFormat,
                 java.util.Locale,
                 crudproject.State" %>

<%--
    jsp:useBean creates the State JavaBean used to load the selected database
    record. Request scope keeps the bean available for the current page
    request without storing it longer than necessary.
--%>
<jsp:useBean id="stateBean" class="crudproject.State" scope="request" />

<%
    /*
        These constants store the assignment-provided database connection information.
    */
    final String DATABASE_URL = "jdbc:mysql://localhost:3306/CSD430";
    final String DATABASE_USERNAME = "student1";
    final String DATABASE_PASSWORD = "pass";


    /*
        These variables store the state options, selected primary key, page
        status, and any validation or database error message.
    */
    List<State> stateOptions = new ArrayList<>();
    int selectedStateId = 0;
    boolean connectionSuccessful = false;
    boolean formSubmitted = false;
    boolean recordFound = false;
    String errorMessage = null;


    /*
        NumberFormat displays the selected state's population with comma separators.
    */
    NumberFormat populationFormatter = NumberFormat.getIntegerInstance(Locale.US);


    /*
        The form submits the selected state_id using the stateId parameter.
        A value is processed only when the parameter exists and is not blank.
    */
    String selectedStateParameter = request.getParameter("stateId");

    if (selectedStateParameter != null && !selectedStateParameter.trim().isEmpty()) {
        formSubmitted = true;

        try {
            selectedStateId = Integer.parseInt(selectedStateParameter);

            /*
                A valid state_id must be greater than zero. The database query
                will later confirm that the ID matches an existing record.
            */
            if (selectedStateId <= 0) {
                errorMessage = "Please select a valid state from the dropdown menu.";
            }

        } catch (NumberFormatException exception) {
            errorMessage = "The submitted state ID was not a valid whole number.";
        }
    }


    /*
        Load the JDBC driver, connect to the database, and use the State bean
        to retrieve the dropdown options and selected record.
    */
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection connection = DriverManager.getConnection(DATABASE_URL, DATABASE_USERNAME, DATABASE_PASSWORD)) {
            connectionSuccessful = true;


            /*
                The JavaBean retrieves the state_id and state_name values used to initialize the dropdown menu.
            */
            stateOptions = stateBean.getStateOptions(connection);


            /*
                Load the complete selected record only after the form submits a valid positive integer.
            */
            if (formSubmitted && errorMessage == null) {
                recordFound = stateBean.loadStateById(connection, selectedStateId);

                if (!recordFound) {
                    errorMessage = "No state record matched the selected state ID. Please choose another option.";
                }
            }
        }

    } catch (ClassNotFoundException exception) {
        errorMessage =
            "The MySQL JDBC driver could not be found. Confirm that the " +
            "MySQL Connector/J JAR file is available to Tomcat.";

    } catch (SQLException exception) {
        errorMessage =
            exception.getMessage() +
            " (SQLState: " + exception.getSQLState() +
            ", Error Code: " + exception.getErrorCode() + ")" +
            " Please recreate and repopulated the database table using the provided JSP utilities.";

    } catch (Exception exception) {
        errorMessage = "An unexpected error occurred: " + exception.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Wade Eckert">
    <meta name="description" content="Select a state record from the CSD430 database and display all eight fields in a formatted HTML table.">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="robots" content="noindex, nofollow">

    <title>Select State Record | CSD 430 CRUD Project</title>

    <%-- This JSP file is one folder below the shared stylesheet. --%>
    <link rel="stylesheet" href="../wadeStyles.css">
</head>

<body>

    <header class="site-header">
        <div class="header-content">

            <p class="course-label">
                CSD 430 Server Side Development
            </p>

            <h1>Select a State Record</h1>

            <p class="header-description">
                Choose a primary-key value from the dropdown menu to retrieve
                and display one complete record from the
                <code>wade_states_data</code> table.
            </p>

        </div>
    </header>


    <main class="page-container">

        <section class="content-card introduction-card">

            <div class="section-heading">

                <p class="section-label">
                    Read Operation
                </p>

                <h2>State Record Lookup</h2>

            </div>


            <p>
                The dropdown displays each state's primary-key value and name.
                After a selection is submitted, the same page displays all
                eight fields associated with that database record.
            </p>


            <%-- Display a database or validation error when one occurs. --%>
            <% if (errorMessage != null) { %>

                <div class="message error-message">

                    <span class="message-title">
                        Record lookup unsuccessful
                    </span>

                    <p>
                        <%= errorMessage %>
                    </p>

                </div>

            <% } else if (connectionSuccessful && stateOptions.isEmpty()) { %>

                <%-- Warn the user when the table exists but contains no rows. --%>
                <div class="message warning-message">

                    <span class="message-title">
                        No state records available
                    </span>

                    <p>
                        The database connection succeeded, but the
                        <code>wade_states_data</code> table does not contain
                        any records. Run the Populate Table utility before
                        using this page.
                    </p>

                </div>

            <% } else if (connectionSuccessful) { %>

                <div class="message success-message">

                    <span class="message-title">
                        State options loaded successfully
                    </span>

                    <p>
                        The page connected to the <code>CSD430</code>
                        database and loaded <%= stateOptions.size() %>
                        available state records through the State JavaBean.
                    </p>

                </div>

            <% } %>


            <%-- Display the selection form only when dropdown records are available. --%>
            <% if (!stateOptions.isEmpty()) { %>

                <form method="get" action="wadeSelectState.jsp" class="record-form">

                    <div class="form-group">

                        <label for="stateId">
                            Select a State
                        </label>

                        <p class="form-help">
                            Each option displays the database ID followed by the state name.
                        </p>

                        <select id="stateId" name="stateId" required>

                            <option value="" <%= selectedStateId == 0 ? "selected" : "" %>>
                                Choose a state record
                            </option>

                            <%-- Generate one dropdown option for each State object returned by the bean. --%>
                            <% for (State option : stateOptions) { %>

                                <option value="<%= option.getStateId() %>" <%= option.getStateId() == selectedStateId ? "selected" : "" %>>
                                    <%= option.getStateId() %> - <%= option.getStateName() %>
                                </option>

                            <% } %>

                        </select>

                    </div>


                    <div class="form-actions">

                        <button type="submit" class="button primary-button">
                            Display State Record
                        </button>

                        <% if (formSubmitted) { %>

                            <a class="button secondary-button" href="wadeSelectState.jsp">
                                Clear Selection
                            </a>

                        <% } %>

                    </div>

                </form>

            <% } %>

        </section>


        <%-- Display the complete record after the JavaBean finds the selected state. --%>
        <% if (recordFound) { %>

            <section class="content-card">

                <div class="section-heading">

                    <p class="section-label">
                        Selected Database Record
                    </p>

                    <h2>
                        <%= stateBean.getStateName() %>
                    </h2>

                </div>


                <p>
                    The State JavaBean loaded the selected database row and
                    stored each column value in its corresponding Java
                    property.
                </p>


                <div class="table-container">

                    <table class="data-table record-detail-table">

                        <caption>
                            Selected U.S. State Record
                        </caption>

                        <thead>
                            <tr>
                                <th scope="col">State ID</th>
                                <th scope="col">State Name</th>
                                <th scope="col">Abbreviation</th>
                                <th scope="col">Capital</th>
                                <th scope="col">Population</th>
                                <th scope="col">Population Year</th>
                                <th scope="col">State Bird</th>
                                <th scope="col">State Flower</th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr>
                                <td><%= stateBean.getStateId() %></td>
                                <td><%= stateBean.getStateName() %></td>
                                <td><%= stateBean.getStateAbbreviation() %></td>
                                <td><%= stateBean.getCapital() %></td>
                                <td>
                                    <%= populationFormatter.format(stateBean.getPopulation()) %>
                                </td>
                                <td><%= stateBean.getPopulationYear() %></td>
                                <td><%= stateBean.getStateBird() %></td>
                                <td><%= stateBean.getStateFlower() %></td>
                            </tr>
                        </tbody>

                    </table>

                </div>

            </section>

        <% } %>


        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Page Process
                </p>

                <h2>How the JavaBean Supports the Read Operation</h2>

            </div>


            <div class="field-grid">

                <article class="field-item">

                    <h3>Load Options</h3>

                    <p>
                        The bean retrieves each <code>state_id</code> and
                        <code>state_name</code> used to build the dropdown
                        menu.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Submit Primary Key</h3>

                    <p>
                        The form sends only the selected numeric state ID back
                        to this JSP page.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Load One Record</h3>

                    <p>
                        The bean uses a parameterized query to find the row
                        matching the selected primary key.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Display Properties</h3>

                    <p>
                        The JSP reads the bean's getter methods and displays
                        the stored values in an HTML table.
                    </p>

                </article>

            </div>

        </section>


        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Next Actions
                </p>

                <h2>Manage the Project Database</h2>

            </div>


            <div class="deliverable-grid">

                <a class="deliverable-card" href="wadeCreateTable.jsp">

                    <span class="deliverable-type">
                        JSP Utility
                    </span>

                    <span class="deliverable-title">
                        Create Table
                    </span>

                    <span class="deliverable-description">
                        Verify the project database and create the states
                        table if it is currently missing.
                    </span>

                </a>


                <a class="deliverable-card" href="wadePopulateTable.jsp">

                    <span class="deliverable-type">
                        JSP Utility
                    </span>

                    <span class="deliverable-title">
                        Populate Table
                    </span>

                    <span class="deliverable-description">
                        Insert all 50 U.S. state records and display the
                        completed database table.
                    </span>

                </a>


                <a class="deliverable-card danger-link" href="wadeDropTable.jsp">

                    <span class="deliverable-type">
                        JSP Utility
                    </span>

                    <span class="deliverable-title">
                        Drop Table
                    </span>

                    <span class="deliverable-description">
                        Safely remove the states table after reviewing and
                        submitting the confirmation form.
                    </span>

                </a>


                <a class="deliverable-card" href="../index.jsp">

                    <span class="deliverable-type">
                        Project Navigation
                    </span>

                    <span class="deliverable-title">
                        Return to Project Home
                    </span>

                    <span class="deliverable-description">
                        Return to the main CRUD project page and review the
                        database utilities and current deliverables.
                    </span>

                </a>

            </div>

        </section>

    </main>


    <footer class="site-footer">

        <p>Wade Eckert</p>

        <p>
            Bellevue University | Bachelor of Science in Software
            Development and Mathematics
        </p>

    </footer>

</body>
</html>