<%--
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: CRUD Project
    Date: July 12, 2026
    File Name: index.jsp
    Description: Provides the main landing page and navigation for the CSD 430 U.S. States CRUD project. This page introduces
                 the database project, links to the current module deliverables, and presents the development roadmap for
                 future CRUD assignments.
--%>

<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="author" content="Wade Eckert">
    <meta name="description" content="U.S. States CRUD Project developed for CSD 430 Server Side Development using JSP, JDBC, JavaBeans, and MySQL.">
    <meta name="keywords" content="JSP, Java, JavaBeans, JDBC, MySQL, CRUD, Server Side Development, Bellevue University">
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
                A database-driven Java web application demonstrating create, read, update, and delete operations.
            </p>
        </div>
    </header>
    <!-- End Site Header -->

    <!-- Main Content: Contains the project overview, schema, deliverables, and roadmap. -->
    <main class="page-container">

        <!-- Project Overview Section: Explains the purpose and scope of the application. -->
        <section class="content-card introduction-card">
            <div class="section-heading">
                <p class="section-label">Project Overview</p>
                <h2>About the Application</h2>
            </div>

            <p>
                This project uses MySQL, JDBC, JSP, and JavaBeans to manage information about the 50 U.S. states. The application will
                be developed incrementally throughout Modules 5 through 9.
            </p>

            <p>
                Each state record will contain identifying, geographic, demographic, and symbolic information. Later modules will
                add interfaces for reading, creating, updating, and deleting database records.
            </p>
        </section>
        <!-- End Project Overview Section -->

        <!-- Database Design Section: Describes the fields stored in each state record. -->
        <section class="content-card">
            <div class="section-heading">
                <p class="section-label">Database Design</p>
                <h2>State Record Fields</h2>
            </div>

            <!-- Field Grid: Summarizes the columns planned for the states table. -->
            <div class="field-grid">
                <article class="field-item">
                    <h3>State ID</h3>
                    <p>
                        A unique numerical primary key used internally to identify each database record.
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
                        The year associated with the recorded population value.
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

        <!-- Current Deliverables Section: Links to the Module 5.2 and 6.2 SQL files. -->
        <section class="content-card">
            <div class="section-heading">
                <p class="section-label">Modules 5.2 and 6.2</p>
                <h2>Current Deliverables</h2>
            </div>

            <p>
                The following SQL scripts create, populate, and remove the <code>wade_states_data</code> table in the <code>CSD430</code> database.
            </p>

            <!-- Deliverable Navigation: Provides access to the current SQL source files. -->
            <nav class="deliverable-grid"
                 aria-label="Modules 5.2 and 6.2 deliverables">

                <a class="deliverable-card" href="module-5-6/wadeCreateTable.sql">
                    <span class="deliverable-type">
                        SQL Script
                    </span>

                    <span class="deliverable-title">
                        Create Table
                    </span>

                    <span class="deliverable-description">
                        Creates the U.S. states database table and defines its fields and constraints.
                    </span>
                </a>

                <a class="deliverable-card" href="module-5-6/wadePopulateTable.sql">
                    <span class="deliverable-type">
                        SQL Script
                    </span>

                    <span class="deliverable-title">
                        Populate Table
                    </span>

                    <span class="deliverable-description">
                        Inserts complete records for all 50 U.S. states.
                    </span>
                </a>

                <a class="deliverable-card danger-link" href="module-5-6/wadeDropTable.sql">
                    <span class="deliverable-type">
                        SQL Script
                    </span>

                    <span class="deliverable-title">
                        Drop Table
                    </span>

                    <span class="deliverable-description">
                        Removes the states table when database cleanup or recreation is required.
                    </span>
                </a>
            </nav>
            <!-- End Deliverable Navigation -->
        </section>
        <!-- End Current Deliverables Section -->

        <!-- Development Roadmap Section: Summarizes the required work for Modules 5 through 9. -->
        <section class="content-card">
            <div class="section-heading">
                <p class="section-label">Development Roadmap</p>
                <h2>Project Deliverables by Module</h2>
            </div>

            <p>
                The application will be expanded during each module while continuing to use the same database, 
                table, JavaBean, shared stylesheet, and project landing page.
            </p>

            <!-- Status List: Shows the current phase and future assignment requirements. -->
            <div class="status-list">

                <article class="status-item current-status">
                    <div class="status-marker"
                         aria-hidden="true">
                    </div>

                    <div>
                        <p class="status-label">
                            Current Phase
                        </p>

                        <h3>
                            Modules 5.2 and 6.2 — Database Setup
                        </h3>

                        <p>
                            Create the <code>CSD430</code> database and the <code>wade_states_data</code> table, populate the
                            table with all 50 U.S. states, provide a script for dropping the table, and document the completed
                            database through screenshots.
                        </p>
                    </div>
                </article>

                <article class="status-item future-status">
                    <div class="status-marker"
                         aria-hidden="true">
                    </div>

                    <div>
                        <p class="status-label">
                            Upcoming
                        </p>

                        <h3>
                            Modules 5.3 and 6.3 — Project Part 1: Read
                        </h3>

                        <p>
                            Create JSP and JDBC pages that create, populate, and delete the same database table. Use a JavaBean
                            to retrieve the available primary-key values, display them in an HTML dropdown, and show the
                            selected state record in an HTML table.
                        </p>
                    </div>
                </article>

                <article class="status-item future-status">
                    <div class="status-marker"
                         aria-hidden="true">
                    </div>

                    <div>
                        <p class="status-label">
                            Upcoming
                        </p>

                        <h3>
                            Module 7.2 — Project Part 2: Create
                        </h3>

                        <p>
                            Provide an HTML or JSP form containing all fields needed to add a new record. Allow the database to
                            generate the primary key, insert the submitted record, and display all records in an HTML table
                            after the operation is completed.
                        </p>
                    </div>
                </article>

                <article class="status-item future-status">
                    <div class="status-marker"
                         aria-hidden="true">
                    </div>

                    <div>
                        <p class="status-label">
                            Upcoming
                        </p>

                        <h3>
                            Module 8.2 — Project Part 3: Update
                        </h3>

                        <p>
                            Display all primary-key values in an HTML dropdown, allow the user to select a record, and load its
                            values into an update form. Keep the primary key read-only, save the modified values, and display
                            the updated record in an HTML table.
                        </p>
                    </div>
                </article>

                <article class="status-item future-status">
                    <div class="status-marker"
                         aria-hidden="true">
                    </div>

                    <div>
                        <p class="status-label">
                            Upcoming
                        </p>

                        <h3>
                            Module 9.2 — Project Part 4: Delete
                        </h3>

                        <p>
                            Display all records in an HTML table and provide an HTML dropdown containing the remaining primary
                            keys. Delete the selected record and redisplay the remaining records and dropdown options until the
                            table contains no records.
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