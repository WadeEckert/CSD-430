<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Modules 5.3 and 6.3 - CRUD Project Part 1
    Date: July 17, 2026
    File Name: wadeCreateTable.jsp
    Description: Connects to the MySQL server using the assignment-provided
                 Java database account, creates the CSD430 database if needed,
                 and creates the wade_states_data table used throughout the
                 U.S. States CRUD project. The page displays clear success,
                 warning, or error feedback after the operation completes.
--%>

<%--
    The page directive establishes Java as the JSP scripting language,
    identifies the JDBC classes used by this page, and ensures that both
    the response and source file use UTF-8 character encoding.
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
        These constants store the database connection information required by
        the assignment.

        SERVER_URL connects to the MySQL server without selecting a database.
        This allows the page to create CSD430 if it does not already exist.

        DATABASE_URL connects directly to CSD430 after the database has been
        verified or created.
    */
    final String SERVER_URL = "jdbc:mysql://localhost:3306/";

    final String DATABASE_URL = "jdbc:mysql://localhost:3306/CSD430";

    final String DATABASE_USERNAME = "student1";
    final String DATABASE_PASSWORD = "pass";
    final String DATABASE_NAME = "CSD430";
    final String TABLE_NAME = "wade_states_data";


    /*
        This SQL statement creates the project database only when it does not already exist.
    */
    final String CREATE_DATABASE_SQL = "CREATE DATABASE IF NOT EXISTS CSD430 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci";


    /*
        This query checks MySQL's information_schema before the CREATE TABLE
        statement runs.

        Checking first allows the page to report whether the table was newly
        created or whether it was already present.
    */
    final String CHECK_TABLE_SQL = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = ? AND table_name = ?";


    /*
        This statement recreates the exact structure defined in the wadeCreateTable.sql file.

        IF NOT EXISTS allows the page to be run safely more than once.
    */
    final String CREATE_TABLE_SQL = "CREATE TABLE IF NOT EXISTS wade_states_data (" +

            "state_id INT UNSIGNED NOT NULL AUTO_INCREMENT, " +

            "state_name VARCHAR(30) NOT NULL, " +

            "state_abbreviation CHAR(2) NOT NULL, " +

            "capital VARCHAR(40) NOT NULL, " +

            "population BIGINT UNSIGNED NOT NULL, " +

            "population_year YEAR NOT NULL, " +

            "state_bird VARCHAR(60) NOT NULL, " +

            "state_flower VARCHAR(60) NOT NULL, " +

            "CONSTRAINT pk_wade_states_data " +
                "PRIMARY KEY (state_id), " +

            "CONSTRAINT uq_wade_states_name " +
                "UNIQUE (state_name), " +

            "CONSTRAINT uq_wade_states_abbreviation " +
                "UNIQUE (state_abbreviation)" +

        ") " +
        "ENGINE = InnoDB " +
        "DEFAULT CHARACTER SET = utf8mb4 " +
        "COLLATE = utf8mb4_0900_ai_ci";


    /*
        These variables store the results of the database operation.

        Their values are used later in the HTML portion of the page to choose
        the correct success, warning, or error message.
    */
    boolean connectionSuccessful = false;
    boolean databaseVerified = false;
    boolean tableAlreadyExisted = false;
    boolean tableOperationSuccessful = false;
    String errorMessage = null;


    /*
        Load the MySQL JDBC driver.

        Modern JDBC versions can often locate the driver automatically, buts
        explicitly loading it makes the requirement visible and produces a
        clearer error when the Connector/J library is unavailable.
    */
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        /*
            Open a connection to the MySQL server without first selecting a
            database.

            try-with-resources automatically closes the server connection and
            Statement when this block finishes.
        */
        try (Connection serverConnection = DriverManager.getConnection(SERVER_URL, DATABASE_USERNAME, DATABASE_PASSWORD);

            Statement databaseStatement = serverConnection.createStatement()
        ) {
            connectionSuccessful = true;


            /*
                Create CSD430 if needed.

                Because IF NOT EXISTS is used, this statement is safe whether
                the database is new or was created during an earlier step.
            */
            databaseStatement.executeUpdate(CREATE_DATABASE_SQL);

            databaseVerified = true;
        }


        /*
            Open a second connection that directly selects the CSD430 database.

            This connection is used to inspect and create the project table.
        */
        try (Connection databaseConnection = DriverManager.getConnection(DATABASE_URL, DATABASE_USERNAME, DATABASE_PASSWORD)) {

            /*
                Check whether wade_states_data already exists before executing CREATE TABLE.

                A PreparedStatement safely supplies the database and table names as query parameters.
            */
            try (PreparedStatement checkStatement = databaseConnection.prepareStatement(CHECK_TABLE_SQL)) {
                checkStatement.setString(1, DATABASE_NAME);
                checkStatement.setString(2, TABLE_NAME);

                try (ResultSet resultSet = checkStatement.executeQuery()) {
                    if (resultSet.next()) {
                        tableAlreadyExisted = resultSet.getInt(1) > 0;
                    }
                }
            }


            /*
                Create the table when it is missing.

                CREATE TABLE IF NOT EXISTS also protects the application from
                an error if the table is created between the check and this
                statement.
            */
            try (Statement tableStatement = databaseConnection.createStatement()) {
                tableStatement.executeUpdate(CREATE_TABLE_SQL);

                tableOperationSuccessful = true;
            }
        }

    } catch (ClassNotFoundException exception) {

        /*
            This error normally means that MySQL Connector/J is not available
            to Tomcat in the application's library or Tomcat lib directory.
        */
        errorMessage =
            "The MySQL JDBC driver could not be found. " +
            "Confirm that the MySQL Connector/J JAR file is installed " +
            "and available to Tomcat.";

    } catch (SQLException exception) {

        /*
            Save the database error message so it can be displayed in the formatted error section below.

            The SQL state and vendor error code provide useful information
            when diagnosing connection or permission problems.
        */
        errorMessage =
            exception.getMessage() +
            " (SQLState: " + exception.getSQLState() +
            ", Error Code: " + exception.getErrorCode() + ")";

    } catch (Exception exception) {

        /*
            This final catch block prevents an unexpected Java error from
            producing an unformatted server page.
        */
        errorMessage =
            "An unexpected error occurred: " +
            exception.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="author" content="Wade Eckert">
    <meta name="description" content="This JSP utility connects to the MySQL server using the assignment-provided Java database account, creates the CSD430 database if needed, and creates the wade_states_data table used throughout the U.S. States CRUD project. The page displays clear success, warning, or error feedback after the operation completes.">
    <meta name="robots" content="noindex, nofollow">

    <title>Create States Table | CSD 430 CRUD Project</title>

    <link rel="stylesheet" href="../wadeStyles.css">
</head>

<body>

    <header class="site-header">
        <div class="header-content">

            <p class="course-label">
                CSD 430 Server Side Development
            </p>

            <h1>Create States Table</h1>

            <p class="header-description">
                This database-management utility verifies the <code>CSD430</code> database and creates the
                <code>wade_states_data</code> table used by the U.S. States CRUD application.
            </p>

        </div>
    </header>


    <main class="page-container">

        <section class="content-card introduction-card">

            <div class="section-heading">

                <p class="section-label">
                    JSP Utility
                </p>

                <h2>Database Creation Results</h2>

            </div>


            <p>
                The page connected to MySQL using the assignment-provided
                Java database account and attempted to prepare the project
                database and table.
            </p>


            <%-- Display the formatted error message when any part of the operation fails. --%>
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

                <%-- Display one success message for the MySQL connection. --%>
                <% if (connectionSuccessful) { %>

                    <div class="message success-message">

                        <span class="message-title">
                            Database connection successful
                        </span>

                        <p>
                            The page connected to MySQL using the <code>student1</code> Java database account.
                        </p>

                    </div>

                <% } %>


                <%-- Display confirmation that the database is available. --%>
                <% if (databaseVerified) { %>

                    <div class="message success-message">

                        <span class="message-title">
                            Database verified
                        </span>

                        <p>
                            The <code>CSD430</code> database is available for the CRUD project.
                        </p>

                    </div>

                <% } %>


                <%-- Display a warning when the table was already present. No error occurred because CREATE TABLE IF NOT EXISTS safely preserved the existing table. --%>
                <% if (tableOperationSuccessful && tableAlreadyExisted) { %>

                    <div class="message warning-message">

                        <span class="message-title">
                            Table already exists
                        </span>

                        <p>
                            The <code>wade_states_data</code> table was already present. Its existing structure and data were preserved.
                        </p>

                    </div>

                <% } %>


                <%-- Display a success message when the table did not exist before this page ran. --%>
                <% if (tableOperationSuccessful && !tableAlreadyExisted) { %>

                    <div class="message success-message">

                        <span class="message-title">
                            Table created successfully
                        </span>

                        <p>
                            The <code>wade_states_data</code> table was created with its eight fields, primary key, unique
                            constraints, and automatic state ID numbering.
                        </p>

                    </div>

                <% } %>

            <% } %>

        </section>


        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Table Structure
                </p>

                <h2>Created Database Fields</h2>

            </div>


            <p>
                The following fields define each U.S. state record stored by
                the application.
            </p>


            <div class="field-grid">

                <article class="field-item">
                    <h3>State ID</h3>
                    <p>
                        Automatically generated integer primary key used to
                        uniquely identify each state.
                    </p>
                </article>


                <article class="field-item">
                    <h3>State Name</h3>
                    <p>
                        Full state name stored as a required and unique text
                        value.
                    </p>
                </article>


                <article class="field-item">
                    <h3>Abbreviation</h3>
                    <p>
                        Required and unique two-character postal
                        abbreviation.
                    </p>
                </article>


                <article class="field-item">
                    <h3>Capital</h3>
                    <p>
                        Name of the state capital stored as required text.
                    </p>
                </article>


                <article class="field-item">
                    <h3>Population</h3>
                    <p>
                        Unsigned whole-number population estimate stored
                        using MySQL <code>BIGINT</code>.
                    </p>
                </article>


                <article class="field-item">
                    <h3>Population Year</h3>
                    <p>
                        Year associated with the population estimate.
                    </p>
                </article>


                <article class="field-item">
                    <h3>State Bird</h3>
                    <p>
                        Official bird associated with the state.
                    </p>
                </article>


                <article class="field-item">
                    <h3>State Flower</h3>
                    <p>
                        Official flower associated with the state.
                    </p>
                </article>

            </div>

        </section>


        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Next Actions
                </p>

                <h2>Continue the Database Setup</h2>

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