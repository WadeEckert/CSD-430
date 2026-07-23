<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Module 7.2 - CRUD Project Part 2
    Date: July 22, 2026
    File Name: wadeCreateState.jsp
    Description: Displays a form for creating a new record in the
                 wade_states_data table. The page validates all submitted
                 values, preserves valid form entries when an error occurs,
                 uses the State JavaBean to insert the record, and displays
                 the complete database table after a successful insertion.
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
    jsp:useBean creates the State JavaBean used to insert the submitted
    record and retrieve the completed database table. Request scope keeps
    the bean available only while the current page request is processed.
--%>
<jsp:useBean id="stateBean" class="crudproject.State" scope="request" />


<%!
    /*
        Converts special HTML characters before submitted or database values
        are displayed on the page.

        This prevents a value containing characters such as <, >, or quotes
        from changing the page's HTML structure.
    */
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>


<%
    /*
        These constants store the assignment-provided database connection information.
    */
    final String DATABASE_URL = "jdbc:mysql://localhost:3306/CSD430";
    final String DATABASE_USERNAME = "student1";
    final String DATABASE_PASSWORD = "pass";


    /*
        These variables preserve the submitted form values.

        Each value begins as an empty string so the form can be displayed
        before it has been submitted.
    */
    String stateNameValue = "";
    String stateAbbreviationValue = "";
    String capitalValue = "";
    String populationValue = "";
    String populationYearValue = "";
    String stateBirdValue = "";
    String stateFlowerValue = "";


    /*
        These variables store field-specific validation messages.

        A null value means that the corresponding field has not produced an error.
    */
    String stateNameError = null;
    String stateAbbreviationError = null;
    String capitalError = null;
    String populationError = null;
    String populationYearError = null;
    String stateBirdError = null;
    String stateFlowerError = null;


    // These numeric variables receive the converted population and population-year values after their submitted strings are validated.
    long population = 0L;
    int populationYear = 0;


    // These variables track the result of the form and database operations.
    boolean formSubmitted = "POST".equalsIgnoreCase(request.getMethod()) && "createState".equals(request.getParameter("formAction"));

    boolean insertSuccessful = false;
    int createdStateId = 0;
    String createdStateName = null;
    String pageErrorMessage = null;


    // This list stores every State object returned after a successful insertion.
    List<State> allStates = new ArrayList<>();


    // NumberFormat adds comma separators when population values are displayed in the results table.
    NumberFormat populationFormatter = NumberFormat.getIntegerInstance(Locale.US);


    // Process the submitted values only when the form sends a POST request containing the expected formAction value.
    if (formSubmitted) {

        /*
            Retrieve each form parameter and remove unnecessary spaces from
            the beginning and end of the submitted value.
        */
        stateNameValue = request.getParameter("stateName");
        stateAbbreviationValue = request.getParameter("stateAbbreviation");
        capitalValue = request.getParameter("capital");
        populationValue = request.getParameter("population");
        populationYearValue = request.getParameter("populationYear");
        stateBirdValue = request.getParameter("stateBird");
        stateFlowerValue = request.getParameter("stateFlower");


        /*
            Replace missing parameters with empty strings before trimming
            them. This prevents a NullPointerException if a parameter is
            missing from the request.
        */
        stateNameValue = stateNameValue == null ? "" : stateNameValue.trim();
        stateAbbreviationValue = stateAbbreviationValue == null ? "" : stateAbbreviationValue.trim().toUpperCase(Locale.US);
        capitalValue = capitalValue == null ? "" : capitalValue.trim();
        populationValue = populationValue == null ? "" : populationValue.trim();
        populationYearValue = populationYearValue == null ? "" : populationYearValue.trim();
        stateBirdValue = stateBirdValue == null ? "" : stateBirdValue.trim();
        stateFlowerValue = stateFlowerValue == null ? "" : stateFlowerValue.trim();


        /*
            Validate the state name.

            The maximum length matches the VARCHAR(30) column in the
            database table.
        */
        if (stateNameValue.isEmpty()) {
            stateNameError = "State name is required.";

        } else if (stateNameValue.length() > 30) {
            stateNameError = "State name cannot contain more than 30 characters.";
        }


        /*
            Validate the abbreviation.

            The abbreviation must contain exactly two letters because the
            database stores it in a CHAR(2) column.
        */
        if (stateAbbreviationValue.isEmpty()) {
            stateAbbreviationError = "State abbreviation is required.";

        } else if (!stateAbbreviationValue.matches("[A-Z]{2}")) {
            stateAbbreviationError = "Enter exactly two letters, such as DC.";
        }


        /*
            Validate the capital.

            The maximum length matches the VARCHAR(40) column in the
            database table.
        */
        if (capitalValue.isEmpty()) {
            capitalError = "Capital is required.";

        } else if (capitalValue.length() > 40) {
            capitalError = "Capital cannot contain more than 40 characters.";
        }


        /*
            Validate and convert the population.

            The database column stores an unsigned whole number, so negative
            and decimal values are not accepted.
        */
        if (populationValue.isEmpty()) {
            populationError = "Population is required.";

        } else {
            try {
                population = Long.parseLong(populationValue);

                if (population < 0) {
                    populationError = "Population cannot be less than zero.";
                }

            } catch (NumberFormatException exception) {
                populationError = "Population must be a valid whole number.";
            }
        }


        /*
            Validate and convert the population year.

            MySQL YEAR values normally range from 1901 through 2155.
        */
        if (populationYearValue.isEmpty()) {
            populationYearError = "Population year is required.";

        } else {
            try {
                populationYear = Integer.parseInt(populationYearValue);

                if (populationYear < 1901 || populationYear > 2155) {

                    populationYearError = "Enter a year from 1901 through 2155.";
                }

            } catch (NumberFormatException exception) {
                populationYearError = "Population year must be a valid four-digit year.";
            }
        }


        /*
            Validate the state bird.

            The maximum length matches the VARCHAR(60) column in the
            database table.
        */
        if (stateBirdValue.isEmpty()) {
            stateBirdError = "State bird is required.";

        } else if (stateBirdValue.length() > 60) {
            stateBirdError = "State bird cannot contain more than 60 characters.";
        }


        /*
            Validate the state flower.

            The maximum length matches the VARCHAR(60) column in the
            database table.
        */
        if (stateFlowerValue.isEmpty()) {
            stateFlowerError = "State flower is required.";

        } else if (stateFlowerValue.length() > 60) {
            stateFlowerError = "State flower cannot contain more than 60 characters.";
        }


        /*
            The form is valid only when every field-specific error variable
            remains null.
        */
        boolean formValid =
            stateNameError == null &&
            stateAbbreviationError == null &&
            capitalError == null &&
            populationError == null &&
            populationYearError == null &&
            stateBirdError == null &&
            stateFlowerError == null;


        // Connect to the database and create the record only after every submitted value passes validation.
        if (formValid) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                try (Connection connection = DriverManager.getConnection(DATABASE_URL, DATABASE_USERNAME, DATABASE_PASSWORD)) {

                    // Copy the validated form values into the corresponding State JavaBean properties.
                    stateBean.setStateName(stateNameValue);
                    stateBean.setStateAbbreviation(stateAbbreviationValue);
                    stateBean.setCapital(capitalValue);
                    stateBean.setPopulation(population);
                    stateBean.setPopulationYear(populationYear);
                    stateBean.setStateBird(stateBirdValue);
                    stateBean.setStateFlower(stateFlowerValue);


                    /*
                        Ask the JavaBean to insert its current property values.

                        The state_id is not supplied by the form because MySQL generates it automatically.
                    */
                    try {
                        insertSuccessful = stateBean.insertState(connection);

                        if (insertSuccessful) {
                            createdStateId = stateBean.getStateId();

                            createdStateName = stateBean.getStateName();

                            // Retrieve every record so the complete table can be displayed after the insertion.
                            allStates = stateBean.getAllStates(connection);


                            /*
                                Clear the form values after a successful insertion. Invalid submissions keep their
                                previously entered values.
                            */
                            stateNameValue = "";
                            stateAbbreviationValue = "";
                            capitalValue = "";
                            populationValue = "";
                            populationYearValue = "";
                            stateBirdValue = "";
                            stateFlowerValue = "";

                        } else {
                            pageErrorMessage =
                                "The database did not report that one " +
                                "record was inserted. No success result " +
                                "could be confirmed.";
                        }

                    } catch (SQLException exception) {

                        /*
                            MySQL error 1062 indicates that a unique value already exists.

                            The table has unique constraints on state_name and
                            state_abbreviation, so the database error is
                            converted into a helpful field-specific message.
                        */
                        if (exception.getErrorCode() == 1062) {
                            String duplicateMessage = exception.getMessage() == null ? "" : exception.getMessage().toLowerCase(Locale.US);

                            if (duplicateMessage.contains("uq_wade_states_name") || duplicateMessage.contains("state_name")) {

                                stateNameError = "That state name already exists in the database.";

                            } else if (duplicateMessage.contains("uq_wade_states_abbreviation") || duplicateMessage.contains("state_abbreviation")) {

                                stateAbbreviationError = "That state abbreviation already exists in the database.";

                            } else {
                                pageErrorMessage = "A record with the same state name or abbreviation already exists.";
                            }

                        } else {
                            throw exception;
                        }
                    }
                }

            } catch (ClassNotFoundException exception) {
                pageErrorMessage =
                    "The MySQL JDBC driver could not be found. " +
                    "Confirm that the MySQL Connector/J JAR file is " +
                    "available to Tomcat.";

            } catch (SQLException exception) {
                pageErrorMessage =
                    exception.getMessage() +
                    " (SQLState: " + exception.getSQLState() +
                    ", Error Code: " + exception.getErrorCode() + ")" +
                    " Confirm that the CSD430 database and " +
                    "wade_states_data table have been created.";

            } catch (Exception exception) {
                pageErrorMessage =
                    "An unexpected error occurred: " +
                    exception.getMessage();
            }
        }
    }


    /*
        Recheck the error variables after database processing because a
        duplicate-key error may have added a field-specific message.
    */
    boolean hasFieldErrors =
        stateNameError != null ||
        stateAbbreviationError != null ||
        capitalError != null ||
        populationError != null ||
        populationYearError != null ||
        stateBirdError != null ||
        stateFlowerError != null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Wade Eckert">
    <meta name="description" content="Create a new record in the wade_states_data table using the State JavaBean. The page validates the submitted values, preserves valid form entries when an error occurs, and displays the complete database table after a successful insertion.">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="robots" content="noindex, nofollow">

    <title>Create State Record | CSD 430 CRUD Project</title>

    <%-- This JSP file is one folder below the shared stylesheet. --%>
    <link rel="stylesheet" href="../wadeStyles.css">
</head>

<body>

    <header class="site-header">
        <div class="header-content">

            <p class="course-label">
                CSD 430 Server Side Development
            </p>

            <h1>Create a State Record</h1>

            <p class="header-description">
                Enter the required values to create a new record in the
                <code>wade_states_data</code> table using the State
                JavaBean.
            </p>

        </div>
    </header>


    <main class="page-container">

        <section class="content-card introduction-card">

            <div class="section-heading">

                <p class="section-label">
                    Create Operation
                </p>

                <h2>New State Information</h2>

            </div>


            <p>
                Complete all seven fields below. The page validates the
                submitted values before asking the State JavaBean to insert
                the new database record.
            </p>


            <div class="message warning-message">

                <span class="message-title">
                    Testing the Create operation
                </span>

                <p>
                    If the table was filled using the Populate Table utility,
                    it already contains all 50 U.S. states. You can test this
                    form by creating a record for Washington, D.C., which is
                    not included in the original 50-state dataset.
                </p>

            </div>


            <%-- Display a general database or application error. --%>
            <% if (pageErrorMessage != null) { %>

                <div class="message error-message">

                    <span class="message-title">
                        State creation unsuccessful
                    </span>

                    <p>
                        <%= escapeHtml(pageErrorMessage) %>
                    </p>

                </div>

            <% } else if (formSubmitted && hasFieldErrors) { %>

                <%-- Summarize the validation failure above the form. --%>
                <div class="message error-message">

                    <span class="message-title">
                        Please correct the highlighted fields
                    </span>

                    <p>
                        The state record was not created. Your submitted
                        values have been preserved below.
                    </p>

                </div>

            <% } else if (insertSuccessful) { %>

                <%-- Confirm the insertion and identify the generated ID. --%>
                <div class="message success-message">

                    <span class="message-title">
                        State record created successfully
                    </span>

                    <p>
                        <strong>
                            <%= escapeHtml(createdStateName) %>
                        </strong>
                        was inserted with state ID
                        <strong><%= createdStateId %></strong>.
                        The table now contains
                        <strong><%= allStates.size() %></strong>
                        records.
                    </p>

                </div>

            <% } %>


            <form method="post" action="wadeCreateState.jsp" class="record-form create-state-form" novalidate>

                <%-- This hidden value distinguishes the Create State form from other possible POST requests. --%>
                <input type="hidden" name="formAction" value="createState">


                <div class="create-form-grid">

                    <div class="form-group">

                        <label for="stateName">
                            State Name
                            <span class="required-marker" aria-hidden="true">*</span>
                        </label>

                        <p class="form-help" id="stateNameHelp">
                            Enter the full state or district name.
                        </p>

                        <input type="text"
                               id="stateName"
                               name="stateName"
                               maxlength="30"
                               value="<%= escapeHtml(stateNameValue) %>"
                               aria-describedby="stateNameHelp<%= stateNameError != null ? " stateNameError" : "" %>"
                               aria-invalid="<%= stateNameError != null %>"
                               class="<%= stateNameError != null ? "invalid-field" : "" %>"
                               required>

                        <% if (stateNameError != null) { %>

                            <small class="field-error" id="stateNameError">
                                <%= stateNameError %>
                            </small>

                        <% } %>

                    </div>


                    <div class="form-group">

                        <label for="stateAbbreviation">
                            State Abbreviation
                            <span class="required-marker" aria-hidden="true">*</span>
                        </label>

                        <p class="form-help" id="stateAbbreviationHelp">
                            Enter exactly two letters. Lowercase letters are converted to uppercase.
                        </p>

                        <input type="text"
                               id="stateAbbreviation"
                               name="stateAbbreviation"
                               maxlength="2"
                               value="<%= escapeHtml(stateAbbreviationValue) %>"
                               aria-describedby="stateAbbreviationHelp<%= stateAbbreviationError != null ? " stateAbbreviationError" : "" %>"
                               aria-invalid="<%= stateAbbreviationError != null %>"
                               class="<%= stateAbbreviationError != null ? "invalid-field" : "" %>"
                               required>

                        <% if (stateAbbreviationError != null) { %>

                            <small class="field-error" id="stateAbbreviationError">
                                <%= stateAbbreviationError %>
                            </small>

                        <% } %>

                    </div>


                    <div class="form-group">

                        <label for="capital">
                            Capital
                            <span class="required-marker" aria-hidden="true">*</span>
                        </label>

                        <p class="form-help" id="capitalHelp">
                            Enter the name of the capital.
                        </p>

                        <input type="text"
                               id="capital"
                               name="capital"
                               maxlength="40"
                               value="<%= escapeHtml(capitalValue) %>"
                               aria-describedby="capitalHelp<%= capitalError != null ? " capitalError" : "" %>"
                               aria-invalid="<%= capitalError != null %>"
                               class="<%= capitalError != null ? "invalid-field" : "" %>"
                               required>

                        <% if (capitalError != null) { %>

                            <small class="field-error" id="capitalError">
                                <%= capitalError %>
                            </small>

                        <% } %>

                    </div>


                    <div class="form-group">

                        <label for="population">
                            Population
                            <span class="required-marker" aria-hidden="true">*</span>
                        </label>

                        <p class="form-help" id="populationHelp">
                            Enter a nonnegative whole-number population.
                        </p>

                        <input type="number"
                               id="population"
                               name="population"
                               min="0"
                               step="1"
                               value="<%= escapeHtml(populationValue) %>"
                               aria-describedby="populationHelp<%= populationError != null ? " populationError" : "" %>"
                               aria-invalid="<%= populationError != null %>"
                               class="<%= populationError != null ? "invalid-field" : "" %>"
                               required>

                        <% if (populationError != null) { %>

                            <small class="field-error" id="populationError">
                                <%= populationError %>
                            </small>

                        <% } %>

                    </div>


                    <div class="form-group">

                        <label for="populationYear">
                            Population Year
                            <span class="required-marker" aria-hidden="true">*</span>
                        </label>

                        <p class="form-help" id="populationYearHelp">
                            Enter the four-digit year associated with the population estimate.
                        </p>

                        <input type="number"
                               id="populationYear"
                               name="populationYear"
                               min="1901"
                               max="2155"
                               step="1"
                               value="<%= escapeHtml(populationYearValue) %>"
                               aria-describedby="populationYearHelp<%= populationYearError != null ? " populationYearError" : "" %>"
                               aria-invalid="<%= populationYearError != null %>"
                               class="<%= populationYearError != null ? "invalid-field" : "" %>"
                               required>

                        <% if (populationYearError != null) { %>

                            <small class="field-error" id="populationYearError">
                                <%= populationYearError %>
                            </small>

                        <% } %>

                    </div>


                    <div class="form-group">

                        <label for="stateBird">
                            State Bird
                            <span class="required-marker" aria-hidden="true">*</span>
                        </label>

                        <p class="form-help" id="stateBirdHelp">
                            Enter the official bird associated with the state or district.
                        </p>

                        <input type="text"
                               id="stateBird"
                               name="stateBird"
                               maxlength="60"
                               value="<%= escapeHtml(stateBirdValue) %>"
                               aria-describedby="stateBirdHelp<%= stateBirdError != null ? " stateBirdError" : "" %>"
                               aria-invalid="<%= stateBirdError != null %>"
                               class="<%= stateBirdError != null ? "invalid-field" : "" %>"
                               required>

                        <% if (stateBirdError != null) { %>

                            <small class="field-error" id="stateBirdError">
                                <%= stateBirdError %>
                            </small>

                        <% } %>

                    </div>


                    <div class="form-group">

                        <label for="stateFlower">
                            State Flower
                            <span class="required-marker" aria-hidden="true">*</span>
                        </label>

                        <p class="form-help" id="stateFlowerHelp">
                            Enter the official flower associated with the state or district.
                        </p>

                        <input type="text"
                               id="stateFlower"
                               name="stateFlower"
                               maxlength="60"
                               value="<%= escapeHtml(stateFlowerValue) %>"
                               aria-describedby="stateFlowerHelp<%= stateFlowerError != null ? " stateFlowerError" : "" %>"
                               aria-invalid="<%= stateFlowerError != null %>"
                               class="<%= stateFlowerError != null ? "invalid-field" : "" %>"
                               required>

                        <% if (stateFlowerError != null) { %>

                            <small class="field-error" id="stateFlowerError">
                                <%= stateFlowerError %>
                            </small>

                        <% } %>

                    </div>

                </div>


                <p class="required-note">
                    <span class="required-marker" aria-hidden="true">*</span>
                    All fields are required.
                </p>


                <div class="form-actions">

                    <button type="submit" class="button primary-button">
                        Create State Record
                    </button>

                    <a class="button secondary-button" href="wadeCreateState.jsp">
                        Clear Form
                    </a>

                </div>

            </form>

        </section>


        <%-- Display every database record after a successful insertion. --%>
        <% if (insertSuccessful) { %>

            <section class="content-card">

                <div class="section-heading">

                    <p class="section-label">
                        Updated Database Table
                    </p>

                    <h2>All State Records</h2>

                </div>


                <p>
                    The State JavaBean retrieved the completed table after
                    the new record was inserted. The newly generated
                    <code>state_id</code> appears in the final record.
                </p>


                <div class="table-container">

                    <table class="data-table">

                        <caption>
                            Complete U.S. States Database Table
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

                            <% for (State state : allStates) { %>

                                <tr class="<%= state.getStateId() == createdStateId ? "new-record-row" : "" %>">
                                    <td>
                                        <%= state.getStateId() %>
                                    </td>

                                    <td>
                                        <%= escapeHtml(state.getStateName()) %>
                                    </td>

                                    <td>
                                        <%= escapeHtml(state.getStateAbbreviation()) %>
                                    </td>

                                    <td>
                                        <%= escapeHtml(state.getCapital()) %>
                                    </td>

                                    <td>
                                        <%= populationFormatter.format(state.getPopulation()) %>
                                    </td>

                                    <td>
                                        <%= state.getPopulationYear() %>
                                    </td>

                                    <td>
                                        <%= escapeHtml(state.getStateBird()) %>
                                    </td>

                                    <td>
                                        <%= escapeHtml(state.getStateFlower()) %>
                                    </td>
                                </tr>

                            <% } %>

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

                <h2>How the JavaBean Supports the Create Operation</h2>

            </div>


            <div class="field-grid">

                <article class="field-item">

                    <h3>Validate the Form</h3>

                    <p>
                        The JSP verifies that every value is present and
                        follows the rules of its corresponding database
                        column.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Build the State Object</h3>

                    <p>
                        Validated values are copied into the State JavaBean
                        through its setter methods.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Insert the Record</h3>

                    <p>
                        The bean uses a parameterized
                        <code>PreparedStatement</code> to insert its values
                        and retrieve the automatically generated state ID.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Display the Table</h3>

                    <p>
                        After the insertion succeeds, the bean retrieves
                        every record and returns a list of State objects for
                        the HTML table.
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

                <a class="deliverable-card"
                   href="../module-5-6/wadeCreateTable.jsp">

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


                <a class="deliverable-card"
                   href="../module-5-6/wadePopulateTable.jsp">

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


                <a class="deliverable-card danger-link"
                   href="../module-5-6/wadeDropTable.jsp">

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

                <a class="deliverable-card"
                   href="../module-5-6/wadeSelectState.jsp">

                    <span class="deliverable-type">
                        Read Operation
                    </span>

                    <span class="deliverable-title">
                        Select State Record
                    </span>

                    <span class="deliverable-description">
                        Choose a state by its database ID and display the
                        complete record using the State JavaBean.
                    </span>

                </a>

                <a class="deliverable-card"
                   href="../index.jsp">

                    <span class="deliverable-type">
                        Project Navigation
                    </span>

                    <span class="deliverable-title">
                        Return to Project Home
                    </span>

                    <span class="deliverable-description">
                        Return to the main CRUD project page and review the
                        available database utilities and deliverables.
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