<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: CRUD Project
    Date: July 29, 2026
    File Name: index.jsp
    Description: Provides the main landing page and navigation for the CSD 430
                 U.S. States CRUD project. The page introduces the project,
                 describes the database design, provides access to permanent
                 database-management and CRUD features, offers downloadable
                 SQL source files, and presents the development roadmap for
                 Modules 5 through 9.
--%>

<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Wade Eckert">
    <meta name="description" content="A database-driven Java web application demonstrating create, read, update, and delete operations for U.S. states.">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="robots" content="noindex, nofollow">

    <title>U.S. States CRUD Project | CSD 430</title>

    <link rel="stylesheet" href="wadeStyles.css">
</head>

<body>

    <!-- Site Header: Introduces the course and overall CRUD project. -->
    <header class="site-header">
        <div class="header-content">

            <p class="course-label">
                CSD 430 | Server Side Development
            </p>

            <h1>U.S. States CRUD Project</h1>

            <p class="header-description">
                A database-driven Java web application demonstrating create,
                read, update, and delete operations.
            </p>

        </div>
    </header>
    <!-- End Site Header -->


    <!-- Main Content: Contains the project overview, database design, application navigation, source files, and roadmap. -->
    <main class="page-container">

        <!-- Project Overview Section: Explains the purpose and scope of the application. -->
        <section class="content-card introduction-card">

            <div class="section-heading">

                <p class="section-label">
                    Project Overview
                </p>

                <h2>About the Application</h2>

            </div>


            <p>
                This project uses MySQL, JDBC, JSP, and JavaBeans to manage
                information about the 50 U.S. states.
            </p>

            <p>
                Each state record contains identifying, geographic,
                demographic, and symbolic information. This project
                provides interfaces for creating, reading, updating, and
                deleting database records while also providing JSP/SQL
                utilities for creating, populating, and dropping the <code>wade_states_data</code>
                table.
            </p>

        </section>
        <!-- End Project Overview Section -->


        <!-- Database Design Section: Describes the fields stored in each state record. -->
        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Database Design
                </p>

                <h2>State Record Fields</h2>

            </div>


            <p>
                Each record in the <code>wade_states_data</code> table
                contains the following eight fields.
            </p>


            <!-- Field Grid: Summarizes the columns included in the states table. -->
            <div class="field-grid">

                <article class="field-item">

                    <h3>State ID</h3>

                    <p>
                        A unique numerical primary key generated automatically
                        for each database record.
                    </p>

                </article>


                <article class="field-item">

                    <h3>State Name</h3>

                    <p>
                        The complete and unique name of the U.S. state.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Abbreviation</h3>

                    <p>
                        The state's unique two-letter postal abbreviation.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Capital</h3>

                    <p>
                        The official capital city of the state.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Population</h3>

                    <p>
                        The state's recorded population for the selected
                        population year.
                    </p>

                </article>


                <article class="field-item">

                    <h3>Population Year</h3>

                    <p>
                        The year associated with the recorded population
                        value.
                    </p>

                </article>


                <article class="field-item">

                    <h3>State Bird</h3>

                    <p>
                        The bird officially designated as a state symbol.
                    </p>

                </article>


                <article class="field-item">

                    <h3>State Flower</h3>

                    <p>
                        The flower officially designated as a state symbol.
                    </p>

                </article>

            </div>
            <!-- End Field Grid -->

        </section>
        <!-- End Database Design Section -->


        <!-- Database Management Section: Provides permanent access to the administrative JSP utilities. -->
        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Database Management
                </p>

                <h2>Table Setup and Maintenance</h2>

            </div>


            <p>
                Use these JSP utilities to create, populate, or remove the
                <code>wade_states_data</code> table. Run Create Table and
                Populate Table before using the CRUD application features.
            </p>


            <!-- Database Utility Navigation: Links to the permanent table-management pages. -->
            <nav class="deliverable-grid"
                 aria-label="Database management utilities">

                <a class="deliverable-card"
                   href="module-5-6/wadeCreateTable.jsp">

                    <span class="deliverable-type">
                        JSP Utility
                    </span>

                    <span class="deliverable-title">
                        Create Table
                    </span>

                    <span class="deliverable-description">
                        Verify the <code>CSD430</code> database and create the
                        states table when it is missing.
                    </span>

                </a>


                <a class="deliverable-card"
                   href="module-5-6/wadePopulateTable.jsp">

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
                   href="module-5-6/wadeDropTable.jsp">

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

            </nav>
            <!-- End Database Utility Navigation -->

        </section>
        <!-- End Database Management Section -->


        <!-- CRUD Operations Section: Provides permanent navigation for current and future application features. -->
        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    CRUD Application Features
                </p>

                <h2>Manage State Records</h2>

            </div>


            <p>
                These pages provide the completed create, read, update, 
                and delete operations used to manage individual state records 
                in the database.
            </p>


            <!-- CRUD Feature Grid: Includes the completed Read page and informational cards for future operations. -->
            <div class="deliverable-grid crud-operation-grid">

                <a class="deliverable-card crud-operation-card" href="module-7/wadeCreateState.jsp">

                    <span class="deliverable-type">
                        Create Operation
                    </span>

                    <span class="deliverable-title">
                        Add State Record
                    </span>

                    <span class="deliverable-description">
                        This form allows a user to enter all required
                        state fields and insert a new database record.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="module-5-6/wadeSelectState.jsp">

                    <span class="deliverable-type">
                        Read Operation
                    </span>

                    <span class="deliverable-title">
                        Select State Record
                    </span>

                    <span class="deliverable-description">
                        Choose a state by its database ID and display all eight
                        fields using the State JavaBean.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="module-8/wadeUpdateState.jsp">

                    <span class="deliverable-type">
                        Update Operation
                    </span>

                    <span class="deliverable-title">
                        Update State Record
                    </span>

                    <span class="deliverable-description">
                        Select an existing state, load its current values into
                        a form, and save changes while preserving its primary key.
                    </span>

                </a>


                <a class="deliverable-card crud-operation-card" href="module-9/wadeDeleteState.jsp">

                    <span class="deliverable-type">Delete Operation</span>

                    <span class="deliverable-title">
                        Delete State Record
                    </span>

                    <span class="deliverable-description">
                        Select an existing state, remove its record from the database, 
                        and display the records that remain.
                    </span>

                </a>

            </div>
            <!-- End CRUD Feature Grid -->

        </section>
        <!-- End CRUD Operations Section -->


        <!-- SQL Source Files Section: Provides permanent downloads for the original database scripts. -->
        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Project Source Files
                </p>

                <h2>Downloadable SQL Scripts</h2>

            </div>


            <p>
                The original SQL source files are available for review,
                download, and manual database execution. These scripts match
                the database structure and data used by the JSP utilities.
            </p>


            <!-- SQL Download Navigation: Provides direct downloads for the three original scripts. -->
            <nav class="deliverable-grid"
                 aria-label="Downloadable SQL scripts">

                <a class="deliverable-card"
                   href="module-5-6/wadeCreateTable.sql"
                   download>

                    <span class="deliverable-type">
                        SQL Download
                    </span>

                    <span class="deliverable-title">
                        Create Table Script
                    </span>

                    <span class="deliverable-description">
                        Downloads the SQL script that creates the database
                        table, fields, primary key, and unique constraints.
                    </span>

                </a>


                <a class="deliverable-card"
                   href="module-5-6/wadePopulateTable.sql"
                   download>

                    <span class="deliverable-type">
                        SQL Download
                    </span>

                    <span class="deliverable-title">
                        Populate Table Script
                    </span>

                    <span class="deliverable-description">
                        Downloads the SQL script containing the complete data
                        set for all 50 U.S. states.
                    </span>

                </a>


                <a class="deliverable-card danger-link"
                   href="module-5-6/wadeDropTable.sql"
                   download>

                    <span class="deliverable-type">
                        SQL Download
                    </span>

                    <span class="deliverable-title">
                        Drop Table Script
                    </span>

                    <span class="deliverable-description">
                        Downloads the SQL script used to remove the states
                        table during cleanup or recreation.
                    </span>

                </a>

            </nav>
            <!-- End SQL Download Navigation -->

        </section>
        <!-- End SQL Source Files Section -->


        <!-- Development Roadmap Section: Summarizes completed and future work for Modules 5 through 9. -->
        <section class="content-card">

            <div class="section-heading">

                <p class="section-label">
                    Development Roadmap
                </p>

                <h2>Project Deliverables by Module</h2>

            </div>


            <p>
                The application is expanded during each module while
                continuing to use the same database, table, JavaBean, shared
                stylesheet, and project landing page.
            </p>


            <!-- Status List: Shows completed phases and future assignment requirements. -->
            <div class="status-list">

                <article class="status-item completed-status">

                    <div class="status-marker" aria-hidden="true">
                    </div>

                    <div>

                        <p class="status-label">
                            Completed
                        </p>

                        <h3>
                            Modules 5.2 and 6.2 &mdash; Database Setup
                        </h3>

                        <p>
                            Created the <code>CSD430</code> database and
                            <code>wade_states_data</code> table, populated it
                            with all 50 U.S. states, provided a script for
                            dropping the table, and documented the completed
                            database operations.
                        </p>

                    </div>

                </article>


                <article class="status-item completed-status">

                    <div class="status-marker" aria-hidden="true">
                    </div>

                    <div>

                        <p class="status-label">
                            Completed
                        </p>

                        <h3>
                            Modules 5.3 and 6.3 &mdash; Project Part 1: Read
                        </h3>

                        <p>
                            Created JSP and JDBC utilities that create,
                            populate, and safely remove the project table.
                            Added a State JavaBean that retrieves primary-key
                            options and loads a selected state record for
                            display in an HTML table.
                        </p>

                    </div>

                </article>


                <article class="status-item completed-status">

                    <div class="status-marker" aria-hidden="true">
                    </div>

                    <div>

                        <p class="status-label">
                            Completed
                        </p>

                        <h3>
                            Module 7.2 &mdash; Project Part 2: Create
                        </h3>

                        <p>
                            Created an HTML form containing all fields needed to add a new
                            record. Allowed the database to generate the primary key, inserted
                            the submitted record, and displayed all records in an HTML table
                            after the operation was completed.
                        </p>

                    </div>

                </article>


                <article class="status-item completed-status">

                    <div class="status-marker" aria-hidden="true">
                    </div>

                    <div>

                        <p class="status-label">
                            Completed
                        </p>

                        <h3>
                            Module 8.2 &mdash; Project Part 3: Update
                        </h3>

                        <p>
                            Added an HTML dropdown containing all primary-key
                            values, loaded the selected record into a
                            prepopulated update form, kept the primary key
                            read-only, saved validated changes, and displayed
                            the updated record in an HTML table.
                        </p>

                    </div>

                </article>


                <article class="status-item completed-status">

                    <div class="status-marker" aria-hidden="true">
                    </div>

                    <div class="status-content">

                        <p class="status-label">
                            Completed
                        </p>

                        <h3>
                            Module 9.2 &mdash; Project Part 4: Delete
                        </h3>

                        <p>
                            Created a JSP page that displays all database records 
                            and allows a user to select an existing state by its primary key. 
                            The page deletes the selected record through the State JavaBean and 
                            refreshes the dropdown and table to show the records that remain.
                        </p>

                    </div>

                </article>


            </div>
            <!-- End Status List -->

        </section>
        <!-- End Development Roadmap Section -->

    </main>
    <!-- End Main Content -->


    <!-- Site Footer: Identifies the project author and academic program. -->
    <footer class="site-footer">

        <p>
            Wade Eckert | Bellevue University
        </p>

        <p>
            Bachelor of Science in Software Development and Mathematics
        </p>

    </footer>
    <!-- End Site Footer -->

</body>
</html>