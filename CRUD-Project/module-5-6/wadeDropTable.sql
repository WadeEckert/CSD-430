/*
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Modules 5.2 and 6.2 - CRUD Project Part 1
    Date: July 12, 2026
    File Name: wadeDropTable.sql
    Description: Selects the CSD430 database and removes the wade_states_data table used throughout the U.S. States CRUD project.
*/


/* Select the project database. */
USE CSD430;


/* Remove the project table if it exists.
   IF EXISTS allows the script to execute safely even if the table has already been removed. */
DROP TABLE IF EXISTS wade_states_data;