<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Module 8 - CRUD Project Part 3
    Date: July 29, 2026
    File Name: wadeUpdateState.jsp
    Description: Displays a dropdown for selecting an existing record from
                 the wade_states_data table and a prepopulated form for
                 updating the selected record. The page validates submitted
                 values, preserves valid entries when an error occurs, uses
                 the State JavaBean to update the database, and displays the
                 completed record after a successful update.
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
    jsp:useBean creates the State JavaBean used to retrieve and update the
    selected record. Request scope keeps the bean available only while the
    current page request is processed.
--%>
<jsp:useBean id="stateBean" class="crudproject.State" scope="request" />


<%!
    /*
        Converts special HTML characters before submitted or database values are displayed on the page.

        This prevents a value containing characters such as <, >, or quotes from changing the page's HTML structure.
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
    // These constants store the assignment-provided database connection information.
    final String DATABASE_URL = "jdbc:mysql://localhost:3306/CSD430";
    final String DATABASE_USERNAME = "student1";
    final String DATABASE_PASSWORD = "pass";


    /*
        These variables identify the submitted form and requested operation.

        The page uses separate formAction values because the selection form
        loads a record while the update form changes that record.
    */
    boolean postRequest = "POST".equalsIgnoreCase(request.getMethod());
    String formAction = request.getParameter("formAction");
    boolean loadRequested = postRequest && "loadState".equals(formAction);
    boolean updateRequested = postRequest && "updateState".equals(formAction);


    // These variables store and validate the primary-key value submitted by either form.
    String selectedStateIdValue = request.getParameter("stateId");
    selectedStateIdValue = selectedStateIdValue == null ? "" : selectedStateIdValue.trim();

    int selectedStateId = 0;
    String selectedStateError = null;


    /*
        These variables preserve the seven editable form values.

        A load request fills them with database values. An update request
        keeps the submitted strings so they remain visible if validation fails.
    */
    String stateNameValue = "";
    String stateAbbreviationValue = "";
    String capitalValue = "";
    String populationValue = "";
    String populationYearValue = "";
    String stateBirdValue = "";
    String stateFlowerValue = "";


    // These variables store field-specific validation messages for the update form.
    String stateNameError = null;
    String stateAbbreviationError = null;
    String capitalError = null;
    String populationError = null;
    String populationYearError = null;
    String stateBirdError = null;
    String stateFlowerError = null;


    // These numeric variables receive the converted values after their submitted strings are validated.
    long population = 0L;
    int populationYear = 0;


    // These variables track the results of the record-loading and database-update operations.
    boolean stateLoaded = false;
    boolean updateSuccessful = false;
    String pageErrorMessage = null;


    // This list stores the state IDs and names displayed in the selection dropdown.
    List<State> stateOptions = new ArrayList<>();


    // NumberFormat adds comma separators when population values are displayed.
    NumberFormat populationFormatter = NumberFormat.getIntegerInstance(Locale.US);


    /*
        Validate the state ID whenever either form is submitted.

        The ID must still be validated on the server because a user can
        change submitted browser values even when an input is read-only.
    */
    if (loadRequested || updateRequested) {
        if (selectedStateIdValue.isEmpty()) {
            selectedStateError = "Select a state record before continuing.";

        } else {
            try {
                selectedStateId = Integer.parseInt(selectedStateIdValue);

                if (selectedStateId <= 0) {
                    selectedStateError = "The selected state ID must be greater than zero.";
                }

            } catch (NumberFormatException exception) {
                selectedStateError = "The selected state ID is not valid.";
            }
        }
    }


    // Retrieve and validate the editable values only when the update form is submitted.
    if (updateRequested) {

        /*
            Retrieve each form parameter and replace missing parameters with
            empty strings before trimming them.
        */
        stateNameValue = request.getParameter("stateName");
        stateAbbreviationValue = request.getParameter("stateAbbreviation");
        capitalValue = request.getParameter("capital");
        populationValue = request.getParameter("population");
        populationYearValue = request.getParameter("populationYear");
        stateBirdValue = request.getParameter("stateBird");
        stateFlowerValue = request.getParameter("stateFlower");

        stateNameValue = stateNameValue == null ? "" : stateNameValue.trim();
        stateAbbreviationValue = stateAbbreviationValue == null ? "" : stateAbbreviationValue.trim().toUpperCase(Locale.US);
        capitalValue = capitalValue == null ? "" : capitalValue.trim();
        populationValue = populationValue == null ? "" : populationValue.trim();
        populationYearValue = populationYearValue == null ? "" : populationYearValue.trim();
        stateBirdValue = stateBirdValue == null ? "" : stateBirdValue.trim();
        stateFlowerValue = stateFlowerValue == null ? "" : stateFlowerValue.trim();


        // Validate the state name against the required VARCHAR(30) database column.
        if (stateNameValue.isEmpty()) {
            stateNameError = "State name is required.";

        } else if (stateNameValue.length() > 30) {
            stateNameError = "State name cannot contain more than 30 characters.";
        }


        // Validate the two-letter abbreviation stored in the CHAR(2) database column.
        if (stateAbbreviationValue.isEmpty()) {
            stateAbbreviationError = "State abbreviation is required.";

        } else if (!stateAbbreviationValue.matches("[A-Z]{2}")) {
            stateAbbreviationError = "Enter exactly two letters, such as CO.";
        }


        // Validate the capital against the required VARCHAR(40) database column.
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


        // Validate and convert the value stored in the MySQL YEAR column.
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


        // Validate the state bird against the required VARCHAR(60) database column.
        if (stateBirdValue.isEmpty()) {
            stateBirdError = "State bird is required.";

        } else if (stateBirdValue.length() > 60) {
            stateBirdError = "State bird cannot contain more than 60 characters.";
        }


        // Validate the state flower against the required VARCHAR(60) database column.
        if (stateFlowerValue.isEmpty()) {
            stateFlowerError = "State flower is required.";

        } else if (stateFlowerValue.length() > 60) {
            stateFlowerError = "State flower cannot contain more than 60 characters.";
        }
    }


    // Determine whether every editable value passed validation.
    boolean formValid =
        updateRequested &&
        stateNameError == null &&
        stateAbbreviationError == null &&
        capitalError == null &&
        populationError == null &&
        populationYearError == null &&
        stateBirdError == null &&
        stateFlowerError == null;


    /*
        Connect to the database for every request so the dropdown can always display the currently available records.
    */
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection connection = DriverManager.getConnection(DATABASE_URL, DATABASE_USERNAME, DATABASE_PASSWORD)) {

            // Retrieve the ID and name used for each dropdown option.
            stateOptions = stateBean.getStateOptions(connection);


            // Continue only when a submitted form contains a valid state ID.
            if ((loadRequested || updateRequested) && selectedStateError == null) {

                // Confirm that the submitted primary key still identifies an existing record.
                stateLoaded = stateBean.loadStateById(connection, selectedStateId);

                if (!stateLoaded) {
                    selectedStateError = "The selected state record could not be found.";

                } else if (loadRequested) {

                    // Copy the selected record's current database values into the update form.
                    stateNameValue = stateBean.getStateName();
                    stateAbbreviationValue = stateBean.getStateAbbreviation();
                    capitalValue = stateBean.getCapital();
                    populationValue = Long.toString(stateBean.getPopulation());
                    populationYearValue = Integer.toString(stateBean.getPopulationYear());
                    stateBirdValue = stateBean.getStateBird();
                    stateFlowerValue = stateBean.getStateFlower();

                } else if (formValid) {

                    // Copy the validated form values into the State JavaBean.
                    stateBean.setStateId(selectedStateId);
                    stateBean.setStateName(stateNameValue);
                    stateBean.setStateAbbreviation(stateAbbreviationValue);
                    stateBean.setCapital(capitalValue);
                    stateBean.setPopulation(population);
                    stateBean.setPopulationYear(populationYear);
                    stateBean.setStateBird(stateBirdValue);
                    stateBean.setStateFlower(stateFlowerValue);


                    /*
                        Ask the JavaBean to update its current property values.

                        The state ID is used only in the UPDATE statement's WHERE clause and is not changed.
                    */
                    try {
                        updateSuccessful = stateBean.updateState(connection);

                        if (updateSuccessful) {

                            // Reload the record so the page displays the values currently stored in the database.
                            stateLoaded = stateBean.loadStateById(connection, selectedStateId);

                            if (stateLoaded) {
                                stateNameValue = stateBean.getStateName();
                                stateAbbreviationValue = stateBean.getStateAbbreviation();
                                capitalValue = stateBean.getCapital();
                                populationValue = Long.toString(stateBean.getPopulation());
                                populationYearValue = Integer.toString(stateBean.getPopulationYear());
                                stateBirdValue = stateBean.getStateBird();
                                stateFlowerValue = stateBean.getStateFlower();

                                // Refresh the dropdown in case the update changed the state name.
                                stateOptions = stateBean.getStateOptions(connection);

                            } else {
                                updateSuccessful = false;
                                pageErrorMessage = "The record was updated but could not be reloaded for confirmation.";
                            }

                        } else {
                            pageErrorMessage =
                                "The database did not report that one record " +
                                "was updated. No success result could be confirmed.";
                        }

                    } catch (SQLException exception) {

                        /*
                            MySQL error 1062 indicates that a unique state name or abbreviation already belongs to another record.
                        */
                        if (exception.getErrorCode() == 1062) {
                            String duplicateMessage = exception.getMessage() == null ? "" : exception.getMessage().toLowerCase(Locale.US);

                            if (duplicateMessage.contains("uq_wade_states_name") || duplicateMessage.contains("state_name")) {
                                stateNameError = "That state name already belongs to another database record.";

                            } else if (duplicateMessage.contains("uq_wade_states_abbreviation") || duplicateMessage.contains("state_abbreviation")) {
                                stateAbbreviationError = "That state abbreviation already belongs to another database record.";

                            } else {
                                pageErrorMessage = "Another record already uses the submitted state name or abbreviation.";
                            }

                        } else {
                            throw exception;
                        }
                    }
                }
            }
        }

    } catch (ClassNotFoundException exception) {
        pageErrorMessage =
            "The MySQL JDBC driver could not be found. Confirm that the " +
            "MySQL Connector/J JAR file is available to Tomcat.";

    } catch (SQLException exception) {
        pageErrorMessage =
            exception.getMessage() +
            " (SQLState: " + exception.getSQLState() +
            ", Error Code: " + exception.getErrorCode() + ")" +
            " Confirm that the CSD430 database and " +
            "wade_states_data table have been created.";

    } catch (Exception exception) {
        pageErrorMessage = "An unexpected error occurred: " + exception.getMessage();
    }


    /*
        Recheck the field errors after database processing because a
        duplicate-key error may have added a validation message.
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
    <meta name="description" content="Select and update an existing record in the wade_states_data table using the State JavaBean.">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="robots" content="noindex, nofollow">

    <title>Update State Record | CSD 430 CRUD Project</title>

    <%-- This JSP file is one folder below the shared stylesheet. --%>
    <link rel="stylesheet" href="../wadeStyles.css">
</head>

<body>

    <header class="site-header">
        <div class="header-content">

            <p class="course-label">
                CSD 430 Server Side Development
            </p>

            <h1>Update a State Record</h1>

            <p class="header-description">
                Select an existing record, revise its editable values, and
                update the <code>wade_states_data</code> table using the
                State JavaBean.
            </p>

        </div>
    </header>


    <main class="page-container">

        <section class="content-card introduction-card">

            <div class="section-heading">

                <p class="section-label">
                    Update Operation
                </p>

                <h2>Select a State Record</h2>

            </div>


            <p>
                Choose a state by its primary-key value and name. The page
                will retrieve the complete record and display its current
                values in the update form.
            </p>


            <%-- Display a general database or application error. --%>
            <% if (pageErrorMessage != null) { %>

                <div class="message error-message">

                    <span class="message-title">
                        State update unsuccessful
                    </span>

                    <p>
                        <%= escapeHtml(pageErrorMessage) %>
                    </p>

                </div>

            <% } %>


            <form method="post" action="wadeUpdateState.jsp" class="record-form" novalidate>

                <%-- This hidden value tells the page to load the selected record without updating it. --%>
                <input type="hidden" name="formAction" value="loadState">


                <div class="form-group">

                    <label for="selectedStateId">
                        State Record
                        <span class="required-marker" aria-hidden="true">*</span>
                    </label>

                    <p class="form-help" id="selectedStateHelp">
                        Each option displays the database ID followed by the state name.
                    </p>

                    <select id="selectedStateId"
                            name="stateId"
                            aria-describedby="selectedStateHelp<%= selectedStateError != null ? " selectedStateError" : "" %>"
                            aria-invalid="<%= selectedStateError != null %>"
                            required>

                        <option value="">
                            -- Select a state record --
                        </option>

                        <% for (State option : stateOptions) { %>

                            <option value="<%= option.getStateId() %>"
                                    <%= Integer.toString(option.getStateId()).equals(selectedStateIdValue) ? "selected" : "" %>>
                                <%= option.getStateId() %> - <%= escapeHtml(option.getStateName()) %>
                            </option>

                        <% } %>

                    </select>

                    <% if (selectedStateError != null) { %>

                        <small class="field-error" id="selectedStateError">
                            <%= selectedStateError %>
                        </small>

                    <% } %>

                </div>


                <div class="form-actions">

                    <button type="submit"
                            class="button primary-button"
                            <%= stateOptions.isEmpty() ? "disabled" : "" %>>
                        Load State Record
                    </button>

                    <a class="button secondary-button" href="wadeUpdateState.jsp">
                        Clear Selection
                    </a>

                </div>

            </form>

        </section>


        <%-- Display the prepopulated update form after an existing record has been loaded. --%>
        <% if (stateLoaded) { %>

            <section class="content-card">

                <div class="section-heading">

                    <p class="section-label">
                        Selected Record
                    </p>

                    <h2>Update State Information</h2>

                </div>


                <p>
                    Revise any editable value below. The state ID is the
                    table's primary key, so it identifies the record but
                    cannot be changed.
                </p>


                <% if (updateRequested && hasFieldErrors) { %>

                    <div class="message error-message">

                        <span class="message-title">
                            Please correct the highlighted fields
                        </span>

                        <p>
                            The state record was not updated. Your submitted
                            values have been preserved below.
                        </p>

                    </div>

                <% } else if (updateSuccessful) { %>

                    <div class="message success-message">

                        <span class="message-title">
                            State record updated successfully
                        </span>

                        <p>
                            The record for
                            <strong><%= escapeHtml(stateBean.getStateName()) %></strong>
                            was updated without changing state ID
                            <strong><%= stateBean.getStateId() %></strong>.
                        </p>

                    </div>

                <% } %>


                <form method="post" action="wadeUpdateState.jsp" class="record-form update-state-form" novalidate>

                    <%-- This hidden value tells the page to validate and update the selected record. --%>
                    <input type="hidden" name="formAction" value="updateState">


                    <div class="create-form-grid">

                        <div class="form-group">

                            <label for="stateId">
                                State ID
                            </label>

                            <p class="form-help" id="stateIdHelp">
                                This primary-key value identifies the record and cannot be changed.
                            </p>

                            <input type="text"
                                   id="stateId"
                                   name="stateId"
                                   value="<%= selectedStateId %>"
                                   class="readonly-field"
                                   aria-describedby="stateIdHelp"
                                   readonly>

                        </div>


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
                                Enter exactly two letters. Lowercase letters are automatically converted to uppercase.
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
                        All editable fields are required.
                    </p>


                    <div class="form-actions">

                        <button type="submit" class="button primary-button">
                            Update State Record
                        </button>

                        <a class="button secondary-button" href="wadeUpdateState.jsp">
                            Select Another Record
                        </a>

                    </div>

                </form>

            </section>

        <% } %>


        <%-- Display the complete updated record after the database confirms the change. --%>
        <% if (updateSuccessful && stateLoaded) { %>

            <section class="content-card">

                <div class="section-heading">

                    <p class="section-label">
                        Update Result
                    </p>

                    <h2>Updated State Record</h2>

                </div>


                <p>
                    The State JavaBean reloaded the record after the update.
                    The table below shows the values currently stored in the
                    database.
                </p>


                <div class="table-container">

                    <table class="data-table">

                        <caption>
                            Updated U.S. State Database Record
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
                            <tr class="updated-record-row">
                                <td>
                                    <%= stateBean.getStateId() %>
                                </td>

                                <td>
                                    <%= escapeHtml(stateBean.getStateName()) %>
                                </td>

                                <td>
                                    <%= escapeHtml(stateBean.getStateAbbreviation()) %>
                                </td>

                                <td>
                                    <%= escapeHtml(stateBean.getCapital()) %>
                                </td>

                                <td>
                                    <%= populationFormatter.format(stateBean.getPopulation()) %>
                                </td>

                                <td>
                                    <%= stateBean.getPopulationYear() %>
                                </td>

                                <td>
                                    <%= escapeHtml(stateBean.getStateBird()) %>
                                </td>

                                <td>
                                    <%= escapeHtml(stateBean.getStateFlower()) %>
                                </td>
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

                <h2>How the JavaBean Supports the Update Operation</h2>

            </div>


            <div class="field-grid">

                <article class="field-item">

                    <h3>Select the Record</h3>

                    <p>
                        The dropdown submits a state ID, and the JavaBean
                        retrieves the corresponding database record.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Load Current Values</h3>

                    <p>
                        The JSP copies the bean's existing property values
                        into a prepopulated update form.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Validate and Update</h3>

                    <p>
                        The JSP validates the edited values before the bean
                        uses a parameterized <code>PreparedStatement</code>
                        to update the selected record.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Confirm the Result</h3>

                    <p>
                        The bean reloads the record so the final table shows
                        the values currently stored in the database.
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

            <div class="deliverable-grid next-actions-grid">

                <a class="deliverable-card" href="../module-5-6/wadeCreateTable.jsp">

                    <span class="deliverable-type">JSP Utility</span>
                    <span class="deliverable-title">Create Database Table</span>
                    <span class="deliverable-description">
                        Create the wade_states_data table in the CSD430 database.
                    </span>

                </a>


                <a class="deliverable-card" href="../module-5-6/wadePopulateTable.jsp">

                    <span class="deliverable-type">JSP Utility</span>
                    <span class="deliverable-title">Populate Database Table</span>
                    <span class="deliverable-description">
                        Insert the state records and display the populated table.
                    </span>

                </a>


                <a class="deliverable-card danger-link" href="../module-5-6/wadeDropTable.jsp">

                    <span class="deliverable-type">JSP Utility</span>
                    <span class="deliverable-title">Drop Database Table</span>
                    <span class="deliverable-description">
                        Remove the state table after confirming the destructive action.
                    </span>

                </a>


                <a class="deliverable-card project-home-card" href="../index.jsp">

                    <span class="deliverable-type">Project Navigation</span>
                    <span class="deliverable-title">Return to Project Home</span>
                    <span class="deliverable-description">
                        Return to the project overview, utilities, and development roadmap.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="../module-5-6/wadeSelectState.jsp">

                    <span class="deliverable-type">Read Operation</span>
                    <span class="deliverable-title">Select State Record</span>
                    <span class="deliverable-description">
                        Select a state and display its complete database record.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="../module-7/wadeCreateState.jsp">

                    <span class="deliverable-type">Create Operation</span>
                    <span class="deliverable-title">Create State Record</span>
                    <span class="deliverable-description">
                        Validate and insert a new state record into the database.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="wadeUpdateState.jsp">

                    <span class="deliverable-type">Update Operation</span>
                    <span class="deliverable-title">Update State Record</span>
                    <span class="deliverable-description">
                        Select an existing state and save validated changes.
                    </span>

                </a>


                <article class="deliverable-card crud-operation-card planned-card">

                    <span class="deliverable-type">Delete Operation</span>
                    <span class="deliverable-title">Delete State Record</span>
                    <span class="deliverable-description">
                        Planned for Module 9.2.
                    </span>

                </article>

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
