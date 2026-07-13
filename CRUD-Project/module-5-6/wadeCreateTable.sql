/*
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Modules 5.2 and 6.2 - CRUD Project Part 1
    Date: July 12, 2026
    File Name: wadeCreateTable.sql
    Description: Creates the CSD430 database if it does not already exist,
                 selects the database, and creates the wade_states_data table
                 used throughout the U.S. States CRUD project.
*/


/* Create the project database if it does not already exist. */
CREATE DATABASE IF NOT EXISTS CSD430;


/* Select the project database for all subsequent SQL statements. */
USE CSD430;


/* Create the table that stores records for all 50 U.S. states. */
CREATE TABLE IF NOT EXISTS wade_states_data (

    state_id INT UNSIGNED NOT NULL AUTO_INCREMENT,

    state_name VARCHAR(30) NOT NULL,

    state_abbreviation CHAR(2) NOT NULL,

    capital VARCHAR(40) NOT NULL,

    population BIGINT UNSIGNED NOT NULL,

    population_year YEAR NOT NULL,

    state_bird VARCHAR(60) NOT NULL,

    state_flower VARCHAR(60) NOT NULL,

    /* Named constraints make the database easier to maintain and produce more meaningful error messages. */
    CONSTRAINT pk_wade_states_data
        PRIMARY KEY (state_id),

    CONSTRAINT uq_wade_states_name
        UNIQUE (state_name),

    CONSTRAINT uq_wade_states_abbreviation
        UNIQUE (state_abbreviation)

)

/* InnoDB is MySQL's standard transactional storage engine. */
ENGINE = InnoDB

/* utf8mb4 provides full Unicode support for stored text. */
DEFAULT CHARACTER SET = utf8mb4

/* Uses case-insensitive and accent-insensitive text comparisons. 
   This allows for more flexible searching and sorting of text data. */
COLLATE = utf8mb4_0900_ai_ci;