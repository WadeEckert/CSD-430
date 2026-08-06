<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Modules 5.3 and 6.3 - CRUD Project Part 1
    Date: July 17, 2026
    File Name: wadePopulateTable.jsp
    Description: Connects to the CSD430 database, clears any existing records
                 from the wade_states_data table, inserts records for all
                 50 U.S. states, and displays the completed table in a
                 formatted HTML table.

    Population Source:
    StatsAmerica, "Population Estimate for 2025."
    Original Data Source: U.S. Census Bureau.
    Accessed: July 12, 2026.
--%>

<%--
    The page directive establishes Java as the JSP scripting language,
    imports the JDBC and collection classes used by this page, and ensures
    that the response and source file use UTF-8 character encoding.
--%>
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.Connection,
                 java.sql.DriverManager,
                 java.sql.PreparedStatement,
                 java.sql.ResultSet,
                 java.sql.SQLException,
                 java.sql.Statement,
                 java.util.ArrayList,
                 java.util.List,
                 java.text.NumberFormat,
                 java.util.Locale" %>

<%
    /*
        These constants store the assignment-provided database connection information and the name of the project table.
    */
    final String DATABASE_URL = "jdbc:mysql://localhost:3306/CSD430";
    final String DATABASE_USERNAME = "student1";
    final String DATABASE_PASSWORD = "pass";
    final String TABLE_NAME = "wade_states_data";


    /*
        This query checks whether the project table exists before attempting to delete or insert records.
    */
    final String CHECK_TABLE_SQL = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'CSD430' AND table_name = ?";


    /*
        DELETE removes all existing records while preserving the table structure. Resetting AUTO_INCREMENT ensures that Alabama begins with
        state_id 1 each time the table is repopulated.
    */
    final String DELETE_RECORDS_SQL = "DELETE FROM wade_states_data";

    final String RESET_AUTO_INCREMENT_SQL = "ALTER TABLE wade_states_data AUTO_INCREMENT = 1";


    /*
        This parameterized statement inserts one state record at a time.

        The state_id field is omitted because MySQL generates it automatically using AUTO_INCREMENT.
    */
    final String INSERT_STATE_SQL =
        "INSERT INTO wade_states_data (" +
            "state_name, " +
            "state_abbreviation, " +
            "capital, " +
            "population, " +
            "population_year, " +
            "state_bird, " +
            "state_flower" +
        ") VALUES (?, ?, ?, ?, ?, ?, ?)";


    /*
        This query retrieves the completed table after all state records have been inserted.
    */
    final String SELECT_ALL_STATES_SQL = "SELECT state_id, state_name, state_abbreviation, capital, population, population_year, state_bird, state_flower " +
        "FROM wade_states_data ORDER BY state_id";


    /*
        Each inner array contains the seven manually supplied values for one state. The database generates the state_id automatically.

        Population values match those used in wadePopulateTable.sql.
    */
    final Object[][] STATE_DATA = {
        {"Alabama", "AL", "Montgomery", 5193088L, 2025, "Yellowhammer", "Camellia"},
        {"Alaska", "AK", "Juneau", 737270L, 2025, "Willow Ptarmigan", "Forget-Me-Not"},
        {"Arizona", "AZ", "Phoenix", 7623818L, 2025, "Cactus Wren", "Saguaro Blossom"},
        {"Arkansas", "AR", "Little Rock", 3114791L, 2025, "Mockingbird", "Apple Blossom"},
        {"California", "CA", "Sacramento", 39355309L, 2025, "California Quail", "California Poppy"},
        {"Colorado", "CO", "Denver", 6012561L, 2025, "Lark Bunting", "Rocky Mountain Columbine"},
        {"Connecticut", "CT", "Hartford", 3688496L, 2025, "American Robin", "Mountain Laurel"},
        {"Delaware", "DE", "Dover", 1059952L, 2025, "Blue Hen Chicken", "Peach Blossom"},
        {"Florida", "FL", "Tallahassee", 23462518L, 2025, "Northern Mockingbird", "Orange Blossom"},
        {"Georgia", "GA", "Atlanta", 11302748L, 2025, "Brown Thrasher", "Cherokee Rose"},
        {"Hawaii", "HI", "Honolulu", 1432820L, 2025, "Nēnē", "Yellow Hibiscus"},
        {"Idaho", "ID", "Boise", 2029733L, 2025, "Mountain Bluebird", "Syringa"},
        {"Illinois", "IL", "Springfield", 12719141L, 2025, "Northern Cardinal", "Purple Violet"},
        {"Indiana", "IN", "Indianapolis", 6973333L, 2025, "Northern Cardinal", "Peony"},
        {"Iowa", "IA", "Des Moines", 3238387L, 2025, "Eastern Goldfinch", "Wild Prairie Rose"},
        {"Kansas", "KS", "Topeka", 2977220L, 2025, "Western Meadowlark", "Sunflower"},
        {"Kentucky", "KY", "Frankfort", 4606864L, 2025, "Northern Cardinal", "Goldenrod"},
        {"Louisiana", "LA", "Baton Rouge", 4618189L, 2025, "Brown Pelican", "Magnolia"},
        {"Maine", "ME", "Augusta", 1414874L, 2025, "Black-capped Chickadee", "White Pine Cone and Tassel"},
        {"Maryland", "MD", "Annapolis", 6265347L, 2025, "Baltimore Oriole", "Black-Eyed Susan"},
        {"Massachusetts", "MA", "Boston", 7154084L, 2025, "Black-capped Chickadee", "Mayflower"},
        {"Michigan", "MI", "Lansing", 10127884L, 2025, "American Robin", "Apple Blossom"},
        {"Minnesota", "MN", "Saint Paul", 5830405L, 2025, "Common Loon", "Pink and White Lady's Slipper"},
        {"Mississippi", "MS", "Jackson", 2954160L, 2025, "Mockingbird", "Magnolia"},
        {"Missouri", "MO", "Jefferson City", 6270541L, 2025, "Eastern Bluebird", "Hawthorn Blossom"},
        {"Montana", "MT", "Helena", 1144694L, 2025, "Western Meadowlark", "Bitterroot"},
        {"Nebraska", "NE", "Lincoln", 2018006L, 2025, "Western Meadowlark", "Goldenrod"},
        {"Nevada", "NV", "Carson City", 3282188L, 2025, "Mountain Bluebird", "Sagebrush"},
        {"New Hampshire", "NH", "Concord", 1415342L, 2025, "Purple Finch", "Purple Lilac"},
        {"New Jersey", "NJ", "Trenton", 9548215L, 2025, "Eastern Goldfinch", "Purple Violet"},
        {"New Mexico", "NM", "Santa Fe", 2125498L, 2025, "Greater Roadrunner", "Yucca Flower"},
        {"New York", "NY", "Albany", 20002427L, 2025, "Eastern Bluebird", "Rose"},
        {"North Carolina", "NC", "Raleigh", 11197968L, 2025, "Northern Cardinal", "Flowering Dogwood"},
        {"North Dakota", "ND", "Bismarck", 799358L, 2025, "Western Meadowlark", "Wild Prairie Rose"},
        {"Ohio", "OH", "Columbus", 11900510L, 2025, "Northern Cardinal", "Scarlet Carnation"},
        {"Oklahoma", "OK", "Oklahoma City", 4123288L, 2025, "Scissor-tailed Flycatcher", "Oklahoma Rose"},
        {"Oregon", "OR", "Salem", 4273586L, 2025, "Western Meadowlark", "Oregon Grape"},
        {"Pennsylvania", "PA", "Harrisburg", 13059432L, 2025, "Ruffed Grouse", "Mountain Laurel"},
        {"Rhode Island", "RI", "Providence", 1114521L, 2025, "Rhode Island Red", "Violet"},
        {"South Carolina", "SC", "Columbia", 5570274L, 2025, "Carolina Wren", "Yellow Jessamine"},
        {"South Dakota", "SD", "Pierre", 935094L, 2025, "Ring-necked Pheasant", "American Pasque Flower"},
        {"Tennessee", "TN", "Nashville", 7315076L, 2025, "Northern Mockingbird", "Iris"},
        {"Texas", "TX", "Austin", 31709821L, 2025, "Northern Mockingbird", "Bluebonnet"},
        {"Utah", "UT", "Salt Lake City", 3538904L, 2025, "California Gull", "Sego Lily"},
        {"Vermont", "VT", "Montpelier", 644663L, 2025, "Hermit Thrush", "Red Clover"},
        {"Virginia", "VA", "Richmond", 8880107L, 2025, "Northern Cardinal", "Flowering Dogwood"},
        {"Washington", "WA", "Olympia", 8001020L, 2025, "American Goldfinch", "Coast Rhododendron"},
        {"West Virginia", "WV", "Charleston", 1766147L, 2025, "Northern Cardinal", "Big Rhododendron"},
        {"Wisconsin", "WI", "Madison", 5972787L, 2025, "American Robin", "Wood Violet"},
        {"Wyoming", "WY", "Cheyenne", 588753L, 2025, "Western Meadowlark", "Indian Paintbrush"}
    };


    /*
        These variables store the results of the database operation and the records that will later be displayed in the HTML table.
    */
    boolean connectionSuccessful = false;
    boolean tableExists = false;
    boolean populationSuccessful = false;
    int recordsInserted = 0;
    String errorMessage = null;
    List<Object[]> stateRecords = new ArrayList<>();


    /*
        NumberFormat adds comma separators to population values when they are displayed in the HTML table.
    */
    NumberFormat populationFormatter = NumberFormat.getIntegerInstance(Locale.US);


    /*
        Load the MySQL JDBC driver before attempting to connect.
    */
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");


        /*
            Open the database connection. It is declared outside the inner try block so the catch block can roll back the transaction if an 
            insertion error occurs.
        */
        try (Connection connection = DriverManager.getConnection(DATABASE_URL, DATABASE_USERNAME, DATABASE_PASSWORD)) {
            connectionSuccessful = true;


            /*
                Verify that wade_states_data exists before attempting to populate it.
            */
            try (PreparedStatement checkStatement = connection.prepareStatement(CHECK_TABLE_SQL)) {

                checkStatement.setString(1, TABLE_NAME);

                try (ResultSet resultSet = checkStatement.executeQuery()) {
                    if (resultSet.next()) {
                        tableExists = resultSet.getInt(1) > 0;
                    }
                }
            }


            /*
                The create-table utility must be run before this page can insert records.
            */
            if (!tableExists) {
                errorMessage = "The wade_states_data table does not exist. Run the Create Table utility before populating it.";

            } else {

                /*
                    Disable automatic commits so deleting and inserting the records becomes one transaction.

                    If any insert fails, rollback restores the table to its condition before this page was run.
                */
                connection.setAutoCommit(false);

                try (
                    Statement cleanupStatement = connection.createStatement();

                    PreparedStatement insertStatement = connection.prepareStatement(INSERT_STATE_SQL)) {

                    /*
                        Clear existing records and reset the generated ID sequence before adding the 50-state data set.
                    */
                    cleanupStatement.executeUpdate(DELETE_RECORDS_SQL);
                    cleanupStatement.executeUpdate(RESET_AUTO_INCREMENT_SQL);


                    /*
                        Supply each state's values to the PreparedStatement and add the completed statement to a JDBC batch.
                    */
                    for (Object[] state : STATE_DATA) {
                        insertStatement.setString(1, (String) state[0]);
                        insertStatement.setString(2, (String) state[1]);
                        insertStatement.setString(3, (String) state[2]);
                        insertStatement.setLong(4, (Long) state[3]);
                        insertStatement.setInt(5, (Integer) state[4]);
                        insertStatement.setString(6, (String) state[5]);
                        insertStatement.setString(7, (String) state[6]);

                        insertStatement.addBatch();
                    }


                    /*
                        Execute all insert statements together. Each successful element in the returned array represents one inserted state record.
                    */
                    int[] batchResults = insertStatement.executeBatch();

                    for (int result : batchResults) {
                        if (result >= 0 || result == Statement.SUCCESS_NO_INFO) {
                            recordsInserted++;
                        }
                    }


                    /*
                        Confirm that all 50 state records were added before permanently saving the transaction.
                    */
                    if (recordsInserted == STATE_DATA.length) {
                        connection.commit();
                        populationSuccessful = true;

                    } else {
                        connection.rollback();

                        errorMessage = "The population operation was rolled back because only " + recordsInserted + " of " + STATE_DATA.length + " records were inserted.";

                        recordsInserted = 0;
                    }

                } catch (SQLException exception) {

                    /*
                        Roll back both the deletion and insert operations when an SQL error occurs.
                    */
                    connection.rollback();
                    throw exception;

                } finally {

                    /*
                        Restore the connection's normal automatic-commit behavior before the connection closes.
                    */
                    connection.setAutoCommit(true);
                }


                /*
                    Retrieve the completed table only after the transaction has been committed successfully.
                */
                if (populationSuccessful) {
                    try (Statement selectStatement = connection.createStatement();

                        ResultSet resultSet = selectStatement.executeQuery(SELECT_ALL_STATES_SQL)
                    ) {
                        while (resultSet.next()) {

                            /*
                                Copy each database row into an Object array so all JDBC resources can close before the HTML portion of the JSP begins.
                            */
                            Object[] record = {
                                resultSet.getInt("state_id"),
                                resultSet.getString("state_name"),
                                resultSet.getString("state_abbreviation"),
                                resultSet.getString("capital"),
                                resultSet.getLong("population"),
                                resultSet.getInt("population_year"),
                                resultSet.getString("state_bird"),
                                resultSet.getString("state_flower")
                            };

                            stateRecords.add(record);
                        }
                    }
                }
            }
        }

    } catch (ClassNotFoundException exception) {
        errorMessage = "The MySQL JDBC driver could not be found. Confirm that the MySQL Connector/J JAR file is available to Tomcat.";

    } catch (SQLException exception) {
        errorMessage = exception.getMessage() + " (SQLState: " + exception.getSQLState() + ", Error Code: " + exception.getErrorCode() + ")";

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
    <meta name="description" content="Populates and displays the U.S. states table used by the CSD 430 CRUD project.">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="robots" content="noindex, nofollow">

    <title>Populate States Table | CSD 430 CRUD Project</title>

    <link rel="stylesheet" href="../wadeStyles.css">
</head>

<body>

    <header class="site-header">
        <div class="header-content">

            <p class="course-label">
                CSD 430 Server Side Development
            </p>

            <h1>Populate States Table</h1>

            <p class="header-description">
                This database-management utility inserts records for all 50 U.S. states into the <code>wade_states_data</code> table
                and displays the completed data set.
            </p>

        </div>
    </header>


    <main class="page-container">

        <section class="content-card introduction-card">

            <div class="section-heading">

                <p class="section-label">
                    JSP Utility
                </p>

                <h2>Database Population Results</h2>

            </div>


            <p>
                The page connected to the <code>CSD430</code> database, cleared any existing state records, reset the automatic state
                ID sequence, and attempted to insert the complete 50-state data set.
            </p>


            <%-- Display an error message when the operation does not finish successfully. --%>
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

                <%-- Confirm that the JDBC connection was opened successfully. --%>
                <% if (connectionSuccessful) { %>

                    <div class="message success-message">

                        <span class="message-title">
                            Database connection successful
                        </span>

                        <p>
                            The page connected to the <code>CSD430</code> database using the <code>student1</code> Java database account.
                        </p>

                    </div>

                <% } %>


                <%-- Confirm that the required project table was located. --%>
                <% if (tableExists) { %>

                    <div class="message success-message">

                        <span class="message-title">
                            Database table verified
                        </span>

                        <p>
                            The <code>wade_states_data</code> table is available and ready to store state records.
                        </p>

                    </div>

                <% } %>


                <%-- Report the number of records inserted by the completed transaction. --%>
                <% if (populationSuccessful) { %>

                    <div class="message success-message">

                        <span class="message-title">
                            Table populated successfully
                        </span>

                        <p>
                            All <%= recordsInserted %> U.S. state records were inserted successfully. Existing records were removed before 
                            inserting the new data so the table always contains one complete set of all 50 U.S. states.
                        </p>

                    </div>

                <% } %>

            <% } %>

        </section>


        <%-- Display the table only after all 50 records have been inserted successfully. --%>
        <% if (populationSuccessful) { %>

            <section class="content-card">

                <div class="section-heading">

                    <p class="section-label">
                        Database Records
                    </p>

                    <h2>Current Contents of wade_states_data</h2>

                </div>


                <p>
                    The table below displays all eight fields for each record currently stored in <code>wade_states_data</code>.
                </p>


                <div class="table-container">

                    <table class="data-table">

                        <caption>
                            U.S. States Database Records
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

                            <%-- Generate one HTML row for each database record. --%>
                            <% for (Object[] state : stateRecords) { %>

                                <tr>
                                    <td><%= state[0] %></td>
                                    <td><%= state[1] %></td>
                                    <td><%= state[2] %></td>
                                    <td><%= state[3] %></td>
                                    <td><%= populationFormatter.format((Long) state[4]) %></td>
                                    <td><%= state[5] %></td>
                                    <td><%= state[6] %></td>
                                    <td><%= state[7] %></td>
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


                <a class="deliverable-card crud-operation-card" href="../module-7/wadeCreateState.jsp">

                    <span class="deliverable-type">Create Operation</span>
                    <span class="deliverable-title">Create State Record</span>
                    <span class="deliverable-description">
                        Validate and insert a new state record into the database.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="wadeSelectState.jsp">

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


                <a class="deliverable-card crud-operation-card" href="../module-9/wadeDeleteState.jsp">

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