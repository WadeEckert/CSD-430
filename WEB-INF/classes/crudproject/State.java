/*
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Module 7 - CRUD Project Part 2
    Date: July 22, 2026
    File Name: State.java
    Description: Defines a JavaBean that represents one record from the
                 wade_states_data table. The bean stores the fields for a U.S.
                 state and provides JDBC methods for inserting a new record,
                 retrieving all records, retrieving the available primary-key
                 values, and loading one selected record from the database.
*/


/*
    The package statement must match the folder containing this file.

    State.java and State.class are stored in:

    WEB-INF/classes/crudproject/
*/
package crudproject;


/*
    Serializable allows the JavaBean's data to be converted into a form
    that Java can save, transfer, or preserve between application processes.

    ArrayList and List are used to return collections of State objects.

    Connection, PreparedStatement, ResultSet, SQLException, and Statement
    are JDBC classes used to communicate with the MySQL database.
*/
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;


/*
 * Represents one U.S. state record from the wade_states_data table.
 *
 * The JSP page creates the database connection and passes that connection
 * to this bean. The bean does not contain the database username or password.
 */
public class State implements Serializable {

    /*
        serialVersionUID identifies the version of this Serializable class.

        Using a fixed value prevents Java from automatically generating a
        different identifier when minor changes are made to the class.
    */
    private static final long serialVersionUID = 1L;


    /*
        This query retrieves the primary-key values and state names used to
        initialize the dropdown menu.

        Returning the state name with the ID allows the dropdown to display
        a useful option such as "1 - Alabama" rather than only showing "1".
    */
    private static final String SELECT_STATE_OPTIONS_SQL =
        "SELECT state_id, state_name " +
        "FROM wade_states_data " +
        "ORDER BY state_id";


    /*
        This parameterized query retrieves one complete database record.

        The question mark is a placeholder for the state_id selected by the
        user. A PreparedStatement safely supplies the selected value.
    */
    private static final String SELECT_STATE_BY_ID_SQL =
        "SELECT state_id, state_name, state_abbreviation, capital, " +
        "population, population_year, state_bird, state_flower " +
        "FROM wade_states_data " +
        "WHERE state_id = ?";


    /*
        This parameterized statement inserts the seven values entered in the
        Create State form. The state_id column is omitted because MySQL
        generates it automatically.
    */
    private static final String INSERT_STATE_SQL =
        "INSERT INTO wade_states_data (state_name, state_abbreviation, capital, " +
        "population, population_year, state_bird, state_flower) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?)";


    /*
        This query retrieves every column and record for the HTML table
        displayed after a new state is inserted.
    */
    private static final String SELECT_ALL_STATES_SQL =
        "SELECT state_id, state_name, state_abbreviation, capital, " +
        "population, population_year, state_bird, state_flower " +
        "FROM wade_states_data " +
        "ORDER BY state_id";


    /*
        These private instance variables correspond to the eight fields in
        the wade_states_data database table.

        Private variables protect the bean's data from direct modification.
        JSP pages and other Java classes access these values through the
        public getter and setter methods below.
    */
    private int stateId;
    private String stateName;
    private String stateAbbreviation;
    private String capital;
    private long population;
    private int populationYear;
    private String stateBird;
    private String stateFlower;


    /*
     * Creates an empty State bean.
     *
     * A public no-argument constructor is required by the JavaBean standard
     * and allows jsp:useBean to create an instance of this class.
     */
    public State() {
        // The fields initially receive Java's default values.
    }


    /*
     * Creates a State bean with values for every database field.
     *
     * This constructor is not required by jsp:useBean, but it is useful when
     * a complete State object needs to be created directly in Java code.
     *
     * @param stateId the table's primary-key value
     * @param stateName the full state name
     * @param stateAbbreviation the state's two-letter abbreviation
     * @param capital the state capital
     * @param population the estimated population
     * @param populationYear the year associated with the population estimate
     * @param stateBird the official state bird
     * @param stateFlower the official state flower
     */
    public State(
        int stateId,
        String stateName,
        String stateAbbreviation,
        String capital,
        long population,
        int populationYear,
        String stateBird,
        String stateFlower
    ) {
        this.stateId = stateId;
        this.stateName = stateName;
        this.stateAbbreviation = stateAbbreviation;
        this.capital = capital;
        this.population = population;
        this.populationYear = populationYear;
        this.stateBird = stateBird;
        this.stateFlower = stateFlower;
    }


    /*
     * Retrieves the state IDs and state names used by the dropdown menu.
     *
     * The JSP page opens the database connection and passes it to this
     * method. This keeps database credentials and connection permissions
     * outside the JavaBean.
     *
     * Each returned State object contains its stateId and stateName values.
     * The remaining fields are not needed when creating the dropdown.
     *
     * @param connection an active JDBC connection to the CSD430 database
     * @return a list of State objects containing IDs and names
     * @throws SQLException if the database query cannot be completed
     */
    public List<State> getStateOptions(Connection connection) throws SQLException {

        //Create an empty list that will hold one State object for each dropdown option returned by the database.
        List<State> stateOptions = new ArrayList<>();

        /*
            try-with-resources automatically closes the PreparedStatement and
            ResultSet when the query is complete, even if an error occurs.

            The Connection is not included here because it was opened by the
            JSP page. The JSP remains responsible for closing it.
        */
        try (
            PreparedStatement statement = connection.prepareStatement(SELECT_STATE_OPTIONS_SQL);

            ResultSet resultSet = statement.executeQuery()
        ) {

            // Process each row returned by the query.
            while (resultSet.next()) {

                /*
                    Create a small State object for the dropdown.

                    Only the ID and name are assigned because those are the
                    only values required to display and submit an option.
                */
                State option = new State();

                option.setStateId(resultSet.getInt("state_id"));
                option.setStateName(resultSet.getString("state_name"));

                stateOptions.add(option);
            }
        }


        // Return the completed collection to the JSP page.
        return stateOptions;
    }


    /*
     * Loads one complete state record into this JavaBean.
     *
     * @param connection an active JDBC connection to the CSD430 database
     * @param selectedStateId the state_id selected from the dropdown
     * @return true when the record is found, or false when no record matches
     * @throws SQLException if the database query cannot be completed
     */
    public boolean loadStateById(Connection connection, int selectedStateId) throws SQLException {

        /*
            Clear any values previously stored in this bean.

            This prevents an older record from remaining visible if a later
            database query does not find a matching state.
        */
        clearState();


        // Prepare the SQL statement containing the state_id placeholder.
        try (PreparedStatement statement = connection.prepareStatement(SELECT_STATE_BY_ID_SQL)) {

            /*
                Supply the selected state ID as the first question-mark value.

                Because state_id is an integer, setInt() is used.
            */
            statement.setInt(1, selectedStateId);


            // Execute the query and automatically close its ResultSet after the database values have been processed.
            
            try (ResultSet resultSet = statement.executeQuery()) {

                // A primary key can identify no more than one record, so an if statement is used rather than a while loop.
                if (resultSet.next()) {

                    // Copy every database column into the corresponding JavaBean property.
                    setStateId(resultSet.getInt("state_id"));
                    setStateName(resultSet.getString("state_name"));
                    setStateAbbreviation(resultSet.getString("state_abbreviation"));
                    setCapital(resultSet.getString("capital"));
                    setPopulation(resultSet.getLong("population"));
                    setPopulationYear(resultSet.getInt("population_year"));
                    setStateBird(resultSet.getString("state_bird"));
                    setStateFlower(resultSet.getString("state_flower"));

                    // Return true so the JSP knows that it can display the selected record.
                    return true;
                }
            }
        }


        // Reaching this point means that the query completed but did not find a row matching the selected state_id.
        return false;
    }


    /*
     * Inserts the values stored in this State bean as a new database record.
     *
     * A PreparedStatement safely supplies the bean's values to the SQL
     * placeholders. MySQL generates the state_id value, and
     * RETURN_GENERATED_KEYS makes that new ID available to the bean.
     *
     * @param connection an active JDBC connection to the CSD430 database
     * @return true when exactly one record is inserted, or false otherwise
     * @throws SQLException if the database statement cannot be completed
     */
    public boolean insertState(Connection connection) throws SQLException {

        // Prepare the INSERT statement and request the automatically generated state_id value.
        try (PreparedStatement statement = connection.prepareStatement(INSERT_STATE_SQL, Statement.RETURN_GENERATED_KEYS)) {

            // Supply the bean's seven user-entered values in the same order as the SQL placeholders.
            statement.setString(1, stateName);
            statement.setString(2, stateAbbreviation);
            statement.setString(3, capital);
            statement.setLong(4, population);
            statement.setInt(5, populationYear);
            statement.setString(6, stateBird);
            statement.setString(7, stateFlower);


            // executeUpdate() returns the number of records affected by the INSERT statement.
            int affectedRows = statement.executeUpdate();

            if (affectedRows != 1) {
                return false;
            }


            // Store the state_id generated by MySQL in this bean so the JSP can identify the newly created record.
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    setStateId(generatedKeys.getInt(1));
                }
            }


            return true;
        }
    }


    /*
     * Retrieves every state record for the results table.
     *
     * Each database row is copied into a separate State object before that
     * object is added to the returned list.
     *
     * @param connection an active JDBC connection to the CSD430 database
     * @return a list containing every state record ordered by state_id
     * @throws SQLException if the database query cannot be completed
     */
    public List<State> getAllStates(Connection connection) throws SQLException {

        // Create an empty list that will hold the complete collection of state records.
        List<State> states = new ArrayList<>();


        // Execute the query and automatically close both JDBC resources when all records have been processed.
        try (
            PreparedStatement statement = connection.prepareStatement(SELECT_ALL_STATES_SQL);

            ResultSet resultSet = statement.executeQuery()
        ) {

            while (resultSet.next()) {

                // Create one complete State object from the current database row.
                State state = new State(
                    resultSet.getInt("state_id"),
                    resultSet.getString("state_name"),
                    resultSet.getString("state_abbreviation"),
                    resultSet.getString("capital"),
                    resultSet.getLong("population"),
                    resultSet.getInt("population_year"),
                    resultSet.getString("state_bird"),
                    resultSet.getString("state_flower")
                );

                states.add(state);
            }
        }


        return states;
    }


    /*
     * Removes all values currently stored in this bean.
     *
     * This is a private helper method because it is only needed internally
     * before loading another database record.
     */
    private void clearState() {
        stateId = 0;
        stateName = null;
        stateAbbreviation = null;
        capital = null;
        population = 0L;
        populationYear = 0;
        stateBird = null;
        stateFlower = null;
    }


    /*
        Getter and setter methods provide controlled access to the bean's
        private properties.

        Their names follow the JavaBean naming convention:
            getPropertyName()
            setPropertyName(value)
    */

    /*
     * Returns the primary-key value for this state.
     *
     * @return the state ID
     */
    public int getStateId() {
        return stateId;
    }


    /*
     * Assigns the primary-key value for this state.
     *
     * @param stateId the state ID to store
     */
    public void setStateId(int stateId) {
        this.stateId = stateId;
    }


    /*
     * Returns the full state name.
     *
     * @return the state name
     */
    public String getStateName() {
        return stateName;
    }


    /*
     * Assigns the full state name.
     *
     * @param stateName the state name to store
     */
    public void setStateName(String stateName) {
        this.stateName = stateName;
    }


    /*
     * Returns the two-letter state abbreviation.
     *
     * @return the state abbreviation
     */
    public String getStateAbbreviation() {
        return stateAbbreviation;
    }


    /*
     * Assigns the two-letter state abbreviation.
     *
     * @param stateAbbreviation the abbreviation to store
     */
    public void setStateAbbreviation(String stateAbbreviation) {
        this.stateAbbreviation = stateAbbreviation;
    }


    /*
     * Returns the state capital.
     *
     * @return the capital
     */
    public String getCapital() {
        return capital;
    }


    /*
     * Assigns the state capital.
     *
     * @param capital the capital to store
     */
    public void setCapital(String capital) {
        this.capital = capital;
    }


    /*
     * Returns the state's population estimate.
     *
     * A long is used because the database column is a BIGINT and state
     * populations can be larger than values typically stored in an int.
     *
     * @return the population estimate
     */
    public long getPopulation() {
        return population;
    }


    /*
     * Assigns the state's population estimate.
     *
     * @param population the population to store
     */
    public void setPopulation(long population) {
        this.population = population;
    }


    /*
     * Returns the year associated with the population estimate.
     *
     * @return the population year
     */
    public int getPopulationYear() {
        return populationYear;
    }


    /*
     * Assigns the year associated with the population estimate.
     *
     * @param populationYear the population year to store
     */
    public void setPopulationYear(int populationYear) {
        this.populationYear = populationYear;
    }


    /*
     * Returns the official state bird.
     *
     * @return the state bird
     */
    public String getStateBird() {
        return stateBird;
    }


    /*
     * Assigns the official state bird.
     *
     * @param stateBird the state bird to store
     */
    public void setStateBird(String stateBird) {
        this.stateBird = stateBird;
    }


    /*
     * Returns the official state flower.
     *
     * @return the state flower
     */
    public String getStateFlower() {
        return stateFlower;
    }


    /*
     * Assigns the official state flower.
     *
     * @param stateFlower the state flower to store
     */
    public void setStateFlower(String stateFlower) {
        this.stateFlower = stateFlower;
    }
}