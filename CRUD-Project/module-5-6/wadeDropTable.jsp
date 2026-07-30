<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Modules 5.3 and 6.3 - CRUD Project Part 1
    Date: July 17, 2026
    File Name: wadeDropTable.jsp
    Description: Displays a confirmation form before connecting to the CSD430
                 database and removing the wade_states_data table. The page
                 reports whether the table was dropped, was already absent,
                 or could not be removed because of an error.
--%>

<%--
    The page directive establishes Java as the JSP scripting language,
    imports the JDBC classes used by this page, and ensures that the
    response and source file use UTF-8 character encoding.
--%>
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.PreparedStatement,
                 java.sql.ResultSet,
                 java.sql.SQLException,
                 java.sql.Statement" %>

<%
    /*
        These constants store the assignment-provided database connection
        information and the name of the project table.
    */
    final String DATABASE_URL = "jdbc:mysql://localhost:3306/CSD430";
    final String DATABASE_USERNAME = "student1";
    final String DATABASE_PASSWORD = "pass";
    final String DATABASE_NAME = "CSD430";
    final String TABLE_NAME = "wade_states_data";


    /*
        This query checks whether the project table exists before the drop
        statement runs. Checking first allows the page to report whether a
        table was actually removed or was already absent.
    */
    final String CHECK_TABLE_SQL =
        "SELECT COUNT(*) FROM information_schema.tables " +
        "WHERE table_schema = ? AND table_name = ?";


    /*
        IF EXISTS prevents MySQL from returning an error if the table is
        removed by another process after the existence check completes.
    */
    final String DROP_TABLE_SQL =
        "DROP TABLE IF EXISTS wade_states_data";


    /*
        The table may only be dropped by a POST request that contains the
        expected confirmation value.

        Simply opening the page, following a link, or requesting its URL
        does not modify the database.
    */
    boolean confirmationSubmitted = "POST".equalsIgnoreCase(request.getMethod()) && "yes".equals(request.getParameter("confirmDrop"));


    /*
        These variables store the outcome of the database operation for the
        formatted status messages displayed later in the page.
    */
    boolean connectionSuccessful = false;
    boolean tableExisted = false;
    boolean dropOperationSuccessful = false;
    String errorMessage = null;


    /*
        No database operation occurs until the confirmation form is submitted successfully.
    */
    if (confirmationSubmitted) {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");


            /*
                Open a connection directly to the CSD430 database.
                try-with-resources automatically closes the connection.
            */
            try (Connection connection = DriverManager.getConnection(DATABASE_URL, DATABASE_USERNAME, DATABASE_PASSWORD)) {
                connectionSuccessful = true;


                /*
                    Check whether wade_states_data exists before removing it.
                */
                try (PreparedStatement checkStatement = connection.prepareStatement(CHECK_TABLE_SQL)) {

                    checkStatement.setString(1, DATABASE_NAME);
                    checkStatement.setString(2, TABLE_NAME);

                    try (ResultSet resultSet = checkStatement.executeQuery()) {
                        if (resultSet.next()) {
                            tableExisted = resultSet.getInt(1) > 0;
                        }
                    }
                }


                /*
                    Execute the protected drop statement. DROP TABLE IF EXISTS
                    succeeds whether the table exists or is already absent.
                */
                try (Statement dropStatement = connection.createStatement()) {
                    dropStatement.executeUpdate(DROP_TABLE_SQL);
                    dropOperationSuccessful = true;
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
                ", Error Code: " + exception.getErrorCode() + ")";

        } catch (Exception exception) {
            errorMessage = "An unexpected error occurred: " + exception.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Wade Eckert">
    <meta name="description" content="Drops the U.S. states table used by the CSD 430 CRUD project.">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="robots" content="noindex, nofollow">

    <title>Drop States Table | CSD 430 CRUD Project</title>

    <%-- This JSP file is one folder below the shared stylesheet. --%>
    <link rel="stylesheet" href="../wadeStyles.css">
</head>

<body>

    <header class="site-header">
        <div class="header-content">

            <p class="course-label">
                CSD 430 Server Side Development
            </p>

            <h1>Drop States Table</h1>

            <p class="header-description">
                This database-management utility safely removes the
                <code>wade_states_data</code> table from the
                <code>CSD430</code> database after receiving confirmation.
            </p>

        </div>
    </header>


    <main class="page-container">

        <section class="content-card introduction-card">

            <div class="section-heading">

                <p class="section-label">
                    JSP Utility
                </p>

                <h2>Table Removal</h2>

            </div>


            <%-- Display the confirmation form when the page is first opened. --%>
            <% if (!confirmationSubmitted) { %>

                <div class="message warning-message">

                    <span class="message-title">
                        Confirmation required
                    </span>

                    <p>
                        Dropping <code>wade_states_data</code> permanently
                        removes its structure and all 50 state records. The
                        table must be recreated and repopulated before any
                        of the utility pages can be used again.
                    </p>

                </div>


                <form method="post" action="wadeDropTable.jsp" class="confirmation-form">

                    <%--
                        This hidden value is checked together with the POST
                        request method before the database operation can run.
                    --%>
                    <input type="hidden" name="confirmDrop" value="yes">

                    <div class="confirmation-panel">

                        <h3>Remove the States Table?</h3>

                        <p>
                            Select the confirmation button below only when
                            database cleanup or table recreation is required.
                        </p>

                        <div class="form-actions">

                            <button type="submit" class="button danger-button">Confirm Drop Table</button>

                            <a class="button secondary-button" href="../index.jsp">
                                Cancel and Return Home
                            </a>

                        </div>

                    </div>

                </form>

            <% } else { %>

                <%-- Display the formatted error when the drop operation fails. --%>
                <% if (errorMessage != null) { %>

                    <div class="message error-message">

                        <span class="message-title">
                            Database operation unsuccessful
                        </span>

                        <p>
                            <%= errorMessage %>
                        </p>

                    </div>

                <% } else { %>

                    <%-- Confirm that the JDBC connection opened successfully. --%>
                    <% if (connectionSuccessful) { %>

                        <div class="message success-message">

                            <span class="message-title">
                                Database connection successful
                            </span>

                            <p>
                                The page connected to the
                                <code>CSD430</code> database using the
                                <code>student1</code> Java database account.
                            </p>

                        </div>

                    <% } %>


                    <%-- Report that an existing table was removed successfully. --%>
                    <% if (dropOperationSuccessful && tableExisted) { %>

                        <div class="message success-message">

                            <span class="message-title">
                                Table dropped successfully
                            </span>

                            <p>
                                The <code>wade_states_data</code> table and
                                all records stored within it were removed from
                                the <code>CSD430</code> database.
                            </p>

                        </div>

                    <% } %>


                    <%-- Report that no table existed when the request was processed. --%>
                    <% if (dropOperationSuccessful && !tableExisted) { %>

                        <div class="message warning-message">

                            <span class="message-title">
                                Table already absent
                            </span>

                            <p>
                                The <code>wade_states_data</code> table did
                                not exist, so no database records needed to be
                                removed.
                            </p>

                        </div>

                    <% } %>

                <% } %>

            <% } %>

        </section>


        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Operation Details
                </p>

                <h2>Protected Database Removal</h2>

            </div>


            <div class="field-grid">

                <article class="field-item">

                    <h3>POST Confirmation</h3>

                    <p>
                        The removal operation only runs when the form submits
                        a valid POST request containing the expected
                        confirmation value.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Existence Check</h3>

                    <p>
                        The page checks MySQL's
                        <code>information_schema</code> so it can report
                        whether the table existed before removal.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Protected SQL</h3>

                    <p>
                        <code>DROP TABLE IF EXISTS</code> prevents an error
                        when the requested table is already absent.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Recovery Process</h3>

                    <p>
                        The Create Table and Populate Table utilities can
                        restore the project table and its complete state data.
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

                <a class="deliverable-card" href="wadeCreateTable.jsp">

                    <span class="deliverable-type">JSP Utility</span>
                    <span class="deliverable-title">Create Table</span>
                    <span class="deliverable-description">
                        Create the wade_states_data table in the CSD430 database.
                    </span>

                </a>


                <a class="deliverable-card" href="wadePopulateTable.jsp">

                    <span class="deliverable-type">JSP Utility</span>
                    <span class="deliverable-title">Populate Table</span>
                    <span class="deliverable-description">
                        Insert the state records and display the populated table.
                    </span>

                </a>


                <a class="deliverable-card danger-link" href="wadeDropTable.jsp">

                    <span class="deliverable-type">JSP Utility</span>
                    <span class="deliverable-title">Drop Table</span>
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


                <a class="deliverable-card crud-operation-card" href="wadeSelectState.jsp">

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


                <a class="deliverable-card crud-operation-card" href="../module-8/wadeUpdateState.jsp">

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