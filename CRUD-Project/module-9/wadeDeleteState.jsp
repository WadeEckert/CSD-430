<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Module 9 - CRUD Project Part 4
    Date: August 5, 2026
    File Name: wadeDeleteState.jsp
    Description: Displays all records from the wade_states_data table and
                 provides a dropdown for selecting a record by its primary
                 key. The page validates the selection, uses the State
                 JavaBean to delete the selected record, and refreshes the
                 dropdown and table to display the remaining records.
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
    jsp:useBean creates the State JavaBean used to retrieve and delete
    database records. Request scope keeps the bean available only while the
    current page request is processed.
--%>
<jsp:useBean id="stateBean" class="crudproject.State" scope="request" />


<%!
    /*
        Converts special HTML characters before submitted or database values
        are displayed on the page.

        This prevents values containing characters such as <, >, or quotes
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
    // These constants store the assignment-provided database connection information.
    final String DATABASE_URL = "jdbc:mysql://localhost:3306/CSD430";
    final String DATABASE_USERNAME = "student1";
    final String DATABASE_PASSWORD = "pass";


    /*
        These variables determine whether the Delete form was submitted and
        retrieve the selected primary-key value.
    */
    boolean postRequest = "POST".equalsIgnoreCase(request.getMethod());
    String formAction = request.getParameter("formAction");
    boolean deleteRequested = postRequest && "deleteState".equals(formAction);

    String selectedStateIdValue = request.getParameter("stateId");
    selectedStateIdValue = selectedStateIdValue == null ? "" : selectedStateIdValue.trim();


    // These variables store the validated state ID and any selection error.
    int selectedStateId = 0;
    String selectedStateError = null;


    /*
        These variables track the result of the database operation and
        preserve the deleted record's identifying information for the
        confirmation message.
    */
    boolean databaseDataLoaded = false;
    boolean deleteSuccessful = false;
    int deletedStateId = 0;
    String deletedStateName = "";
    String pageErrorMessage = null;


    // These lists store the dropdown options and complete table records.
    List<State> stateOptions = new ArrayList<>();
    List<State> allStates = new ArrayList<>();


    // NumberFormat adds comma separators when population values are displayed.
    NumberFormat populationFormatter = NumberFormat.getIntegerInstance(Locale.US);


    /*
        Validate the submitted primary-key value before connecting to the
        database or attempting to delete a record.
    */
    if (deleteRequested) {
        if (selectedStateIdValue.isEmpty()) {
            selectedStateError = "Select a state record before deleting.";

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


    /*
        Connect to the database for every request so the dropdown and table
        always contain the records currently stored in the database.
    */
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection connection = DriverManager.getConnection(DATABASE_URL, DATABASE_USERNAME, DATABASE_PASSWORD)) {

            // Retrieve the state IDs and names used to initialize the dropdown.
            stateOptions = stateBean.getStateOptions(connection);


            // Continue only when the Delete form contains a valid state ID.
            if (deleteRequested && selectedStateError == null) {

                /*
                    Confirm that the submitted primary key still identifies an existing database record.
                */
                boolean recordFound = stateBean.loadStateById(connection, selectedStateId);

                if (!recordFound) {
                    selectedStateError =
                        "The selected state record could not be found. " +
                        "It may have already been deleted.";

                } else {

                    /*
                        Preserve the ID and name before deletion so they remain
                        available for the confirmation message.
                    */
                    deletedStateId = stateBean.getStateId();
                    deletedStateName = stateBean.getStateName();


                    /*
                        Ask the JavaBean to delete the record identified by its stateId property.
                    */
                    deleteSuccessful = stateBean.deleteState(connection);

                    if (deleteSuccessful) {

                        /*
                            Refresh the dropdown after deletion so the removed
                            primary key is no longer available for selection.
                        */
                        stateOptions = stateBean.getStateOptions(connection);

                    } else {
                        pageErrorMessage =
                            "The database did not report that one record was " +
                            "deleted. No successful deletion could be confirmed.";
                    }
                }
            }


            /*
                Retrieve every remaining record after any deletion attempt.

                This keeps the table synchronized with the dropdown and also
                produces an empty table body when no records remain.
            */
            allStates = stateBean.getAllStates(connection);
            databaseDataLoaded = true;
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Wade Eckert">
    <meta name="description" content="Select and delete an existing record from the wade_states_data table using the State JavaBean.">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="robots" content="noindex, nofollow">

    <title>Delete State Record | CSD 430 CRUD Project</title>

    <%-- This JSP file is one folder below the shared stylesheet. --%>
    <link rel="stylesheet" href="../wadeStyles.css">
</head>

<body>

    <header class="site-header">
        <div class="header-content">

            <p class="course-label">
                CSD 430 Server Side Development
            </p>

            <h1>Delete a State Record</h1>

            <p class="header-description">
                Select an existing record by its primary-key value and remove
                it from the <code>wade_states_data</code> table using the
                State JavaBean.
            </p>

        </div>
    </header>


    <main class="page-container">

        <section class="content-card introduction-card">

            <div class="section-heading">

                <p class="section-label">
                    Delete Operation
                </p>

                <h2>Select a State Record</h2>

            </div>


            <p>
                Choose a state by its database ID and name. After the record
                is deleted, the dropdown and complete database table will
                automatically refresh to show only the remaining records.
            </p>


            <%-- Display a general database or application error. --%>
            <% if (pageErrorMessage != null) { %>

                <div class="message error-message">

                    <span class="message-title">
                        State deletion unsuccessful
                    </span>

                    <p>
                        <%= escapeHtml(pageErrorMessage) %>
                    </p>

                </div>
            
            <% } else if (selectedStateError != null) { %>

                <div class="message error-message">

                    <span class="message-title">
                        State deletion unsuccessful
                    </span>

                    <p>
                        No state record was deleted.
                        <%= escapeHtml(selectedStateError) %>
                    </p>

                </div>

            <% } else if (deleteSuccessful) { %>

                <div class="message success-message">

                    <span class="message-title">
                        State record deleted successfully
                    </span>

                    <p>
                        The record for
                        <strong><%= escapeHtml(deletedStateName) %></strong>
                        with state ID
                        <strong><%= deletedStateId %></strong>
                        was removed from the database. The table now contains
                        <strong><%= allStates.size() %></strong>
                        remaining
                        <%= allStates.size() == 1 ? "record" : "records" %>.
                    </p>

                </div>

            <% } else if (databaseDataLoaded && allStates.isEmpty()) { %>

                <div class="message warning-message">

                    <span class="message-title">
                        No state records remain
                    </span>

                    <p>
                        The database connection succeeded, but the
                        <code>wade_states_data</code> table does not contain
                        any records. The required table header remains visible
                        below. Run the Populate Table utility to restore the
                        original state records.
                    </p>

                </div>

            <% } else if (databaseDataLoaded && !deleteRequested) { %>

                <div class="message success-message">

                    <span class="message-title">
                        State records loaded successfully
                    </span>

                    <p>
                        The page connected to the <code>CSD430</code>
                        database and loaded
                        <strong><%= allStates.size() %></strong>
                        available
                        <%= allStates.size() == 1 ? "record" : "records" %>
                        through the State JavaBean.
                    </p>

                </div>

            <% } %>


            <%-- Warn the user that a deleted record cannot be restored through this page. --%>
            <% if (databaseDataLoaded && !stateOptions.isEmpty()) { %>

                <div class="message warning-message">

                    <span class="message-title">
                        Confirm the selected record carefully
                    </span>

                    <p>
                        Deleting a state permanently removes that record from
                        the database. The record can only be restored by
                        inserting it again or rerunning the Populate Table
                        utility.
                    </p>

                </div>

            <% } %>


            <%-- Display the Delete form whenever the database information loads successfully. --%>
            <% if (databaseDataLoaded) { %>

                <form method="post" action="wadeDeleteState.jsp" class="record-form" novalidate>

                    <%-- This hidden value identifies the requested Delete operation. --%>
                    <input type="hidden" name="formAction" value="deleteState">


                    <div class="form-group">

                        <label for="stateId">
                            State Record
                            <span class="required-marker" aria-hidden="true">*</span>
                        </label>

                        <p class="form-help" id="stateIdHelp">
                            Each option displays the database ID followed by the state name.
                        </p>

                        <select id="stateId"
                                name="stateId"
                                aria-describedby="stateIdHelp<%= selectedStateError != null ? " stateIdError" : "" %>"
                                aria-invalid="<%= selectedStateError != null %>"
                                <%= stateOptions.isEmpty() ? "disabled" : "" %>
                                required>

                            <option value="">
                                <%= stateOptions.isEmpty() ? "-- No state records available --" : "-- Select a state record --" %>
                            </option>

                            <% for (State option : stateOptions) { %>

                                <option value="<%= option.getStateId() %>"
                                        <%= Integer.toString(option.getStateId()).equals(selectedStateIdValue) ? "selected" : "" %>>
                                    <%= option.getStateId() %> - <%= escapeHtml(option.getStateName()) %>
                                </option>

                            <% } %>

                        </select>

                        <% if (selectedStateError != null) { %>

                            <small class="field-error" id="stateIdError">
                                <%= selectedStateError %>
                            </small>

                        <% } %>

                    </div>


                    <div class="form-actions">

                        <button type="submit"
                                class="button danger-button"
                                <%= stateOptions.isEmpty() ? "disabled" : "" %>>
                            Delete Selected Record
                        </button>

                        <a class="button secondary-button" href="wadeDeleteState.jsp">
                            Clear Selection
                        </a>

                    </div>

                </form>

            <% } %>

        </section>


        <%-- Display the complete table whenever its database records were retrieved successfully. --%>
        <% if (databaseDataLoaded) { %>

            <section class="content-card">

                <div class="section-heading">

                    <p class="section-label">
                        Current Database Table
                    </p>

                    <h2>Remaining State Records</h2>

                </div>


                <% if (allStates.isEmpty()) { %>

                    <p>
                        No database rows remain. The table header is retained
                        below to identify all eight fields in the
                        <code>wade_states_data</code> table.
                    </p>

                <% } else { %>

                    <p>
                        The table currently contains
                        <strong><%= allStates.size() %></strong>
                        <%= allStates.size() == 1 ? "record" : "records" %>.
                        It will refresh after each successful deletion.
                    </p>

                <% } %>


                <div class="table-container">

                    <table class="data-table">

                        <caption>
                            Remaining U.S. States Database Records
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

                                <tr>
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

                <h2>How the JavaBean Supports the Delete Operation</h2>

            </div>


            <div class="field-grid">

                <article class="field-item">

                    <h3>Load Current Records</h3>

                    <p>
                        The JavaBean retrieves the available IDs and names for
                        the dropdown and every complete record for the table.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Validate the Selection</h3>

                    <p>
                        The JSP confirms that the submitted primary key is a
                        positive whole number that still identifies an
                        existing database record.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Delete One Record</h3>

                    <p>
                        The bean uses a parameterized
                        <code>PreparedStatement</code> with a
                        <code>WHERE</code> clause to delete only the selected
                        state ID.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Refresh the Results</h3>

                    <p>
                        After deletion, the bean retrieves the remaining
                        dropdown options and table rows so both displays stay
                        synchronized.
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


                <a class="deliverable-card crud-operation-card" href="../module-7/wadeCreateState.jsp">

                    <span class="deliverable-type">Create Operation</span>
                    <span class="deliverable-title">Create State Record</span>
                    <span class="deliverable-description">
                        Validate and insert a new state record into the database.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="../module-5-6/wadeSelectState.jsp">

                    <span class="deliverable-type">Read Operation</span>
                    <span class="deliverable-title">Select State Record</span>
                    <span class="deliverable-description">
                        Select a state and display its complete database record.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="../module-8/wadeUpdateState.jsp">

                    <span class="deliverable-type">Update Operation</span>
                    <span class="deliverable-title">Update State Record</span>
                    <span class="deliverable-description">
                        Select an existing state and save validated changes.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="wadeDeleteState.jsp">

                    <span class="deliverable-type">Delete Operation</span>
                    <span class="deliverable-title">Delete State Record</span>
                    <span class="deliverable-description">
                        Select an existing state and remove it from the database.
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