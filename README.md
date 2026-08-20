# CSD 430 – Server Side Development

This repository contains my coursework for **CSD 430 – Server Side Development** at **Bellevue University**.

This course focused on server-side web application development using Java and Jakarta EE technologies. Throughout the course, I worked with JavaServer Pages (JSP), JavaBeans, JDBC, MySQL, Apache Tomcat, Maven, and other server-side development concepts. The coursework progressed from introductory JSP applications to a complete multi-module CRUD database application.

---

## Repository Structure

The repository contains individual module assignments, packaged Java classes used by the JSP applications, and a separate directory for the larger CRUD project developed throughout Modules 5–9.

```text
CSD-430/
├── CRUD-Project/
├── WEB-INF/
│   └── classes/
│       ├── crudproject/
│       └── module4/
├── module-1/
├── module-2/
├── module-3/
├── module-4/
├── module-5/
├── module-10/
├── module-11/
├── .gitignore
└── README.md
```

The early modules contain individual JSP assignments, while the `CRUD-Project` directory contains the larger database-backed application developed incrementally during the middle portion of the course.

---

## Topics Covered

Throughout this course, I gained experience with server-side Java and web application development concepts, including:

* JavaServer Pages (JSP)
* Jakarta EE web applications
* Apache Tomcat
* JavaBeans
* JSP standard actions
* JSP directives and scripting elements
* JDBC database connectivity
* MySQL databases
* SQL queries and database operations
* HTML forms and server-side form processing
* Data validation
* CRUD operations
* HTTP requests and responses
* Cookies
* Redirecting and forwarding requests
* REST and RESTful application concepts
* Cloud computing models
* Spring dependency injection
* Aspect-oriented programming concepts
* JSP custom tags and tag libraries
* Maven project structure and dependency management
* Java GUI technologies including AWT, Swing, and JavaFX

---

## Early JSP Applications

The first portion of the course introduced JSP development through several smaller applications.

### Module 1 – Introductory JSP

Module 1 introduced JavaServer Pages and the basic structure of a server-side Java web application.

### Module 2 – Movie Data Table

Module 2 used Java scriptlets to create and display structured movie data in an HTML table with external CSS styling.

```text
module-2/
├── eckert-movie-table.jsp
└── eckert-style.css
```

### Module 3 – Job Application

Module 3 introduced form processing through a JSP-based job application.

```text
module-3/
├── eckert-job-application.jsp
├── eckert-display-application.jsp
└── eckert-styles.css
```

### Module 4 – Movie JavaBean Application

Module 4 introduced JavaBeans and the separation of Java data objects from JSP presentation logic.

```text
module-4/
├── eckert-movie-display.jsp
└── eckert-style.css
```

The corresponding JavaBean is stored under the `module4` Java package:

```text
WEB-INF/
└── classes/
    └── module4/
        ├── Movie.java
        └── Movie.class
```

This project demonstrates:

* Creating a JavaBean class
* Implementing `Serializable`
* Using private fields with getter and setter methods
* Using a required no-argument constructor
* Organizing Java classes into packages
* Compiling Java classes for Apache Tomcat
* Creating JavaBean objects with JSP standard actions
* Populating bean properties with setter methods
* Retrieving bean data with getter methods
* Displaying server-generated data in a styled HTML table

---

## U.S. States CRUD Application

The primary project for the course was a multi-page CRUD web application for managing information about U.S. states.

The project was developed incrementally throughout **Modules 5–9** and combines JSP, JavaBeans, JDBC, MySQL, SQL, HTML, and CSS.

The database stores information including:

* State name
* State abbreviation
* Capital
* Population
* State bird
* State flower

The project is organized as follows:

```text
CRUD-Project/
├── module-5-6/
│   ├── wadeCreateTable.jsp
│   ├── wadeCreateTable.sql
│   ├── wadeDropTable.jsp
│   ├── wadeDropTable.sql
│   ├── wadePopulateTable.jsp
│   ├── wadePopulateTable.sql
│   └── wadeSelectState.jsp
├── module-7/
│   └── wadeCreateState.jsp
├── module-8/
│   └── wadeUpdateState.jsp
├── module-9/
│   └── wadeDeleteState.jsp
├── index.jsp
└── wadeStyles.css
```

The corresponding `State` JavaBean is stored in the `crudproject` Java package:

```text
WEB-INF/
└── classes/
    └── crudproject/
        ├── State.java
        └── State.class
```

---

## CRUD Operations

The completed application implements all four primary CRUD operations.

### Create

`wadeCreateState.jsp` allows users to add new state records to the MySQL database.

The page includes server-side validation and retains entered values when validation errors occur.

### Read

`wadeSelectState.jsp` allows users to select an existing state and display its stored information.

### Update

`wadeUpdateState.jsp` allows an existing state record to be selected, edited, validated, and updated in the database.

### Delete

`wadeDeleteState.jsp` allows users to select and permanently remove a state record from the database with appropriate validation and feedback.

---

## Database Management Utilities

The CRUD project also includes several JSP utilities for managing the database table itself.

* `wadeCreateTable.jsp` creates the states table
* `wadePopulateTable.jsp` populates the table with U.S. state records
* `wadeDropTable.jsp` removes the table
* Corresponding `.sql` scripts provide standalone SQL versions of these operations

These utilities allow the database environment to be created and reset directly from the project.

---

## CRUD Application Features

The completed project includes:

* MySQL database integration using JDBC
* Prepared SQL statements
* Dynamic JSP pages
* JavaBean data objects
* Database table creation
* Database population
* Database table removal
* State record selection
* Record creation
* Record updating
* Record deletion
* Server-side validation
* Error and success messages
* Consistent navigation between JSP pages
* Shared external CSS styling
* Responsive page layouts
* Downloadable SQL scripts
* A centralized project home page
* Development roadmap and project documentation

The application was developed incrementally, with each module extending the same project until a complete CRUD workflow was available.

---

## Later Course Topics

The later modules focused more heavily on server-side architecture, frameworks, coding practices, and modern Java development concepts.

Topics included:

* JSP custom tags
* Tag libraries
* Cookies
* Maven
* Java coding standards
* REST constraints
* Cloud deployment models
* Spring dependency injection
* Aspect-oriented programming
* AWT, Swing, and JavaFX

These assignments expanded the course beyond JSP syntax by introducing technologies and architectural concepts used in larger Java applications.

---

## Technologies Used

* **Java**
* **JavaServer Pages (JSP)**
* **Jakarta EE**
* **JavaBeans**
* **JDBC**
* **MySQL**
* **SQL**
* **Apache Tomcat**
* **Maven**
* **HTML**
* **CSS**
* **Git**
* **GitHub**
* **Visual Studio Code**

---

## Apache Tomcat and WEB-INF

The applications in this repository were developed and tested using **Apache Tomcat**.

Java classes used by JSP applications are organized under `WEB-INF/classes` according to their Java package structure:

```text
WEB-INF/
└── classes/
    ├── crudproject/
    │   ├── State.java
    │   └── State.class
    └── module4/
        ├── Movie.java
        └── Movie.class
```

The `module4` package contains the JavaBean used by the Module 4 Movie application, while the `crudproject` package contains the `State` JavaBean used by the U.S. States CRUD application.

This structure allows Apache Tomcat to correctly locate and load packaged Java classes while preventing files inside `WEB-INF` from being accessed directly through a web browser.

Because these projects are server-side Java applications, they require a compatible Java environment and servlet container such as Apache Tomcat rather than a static hosting service.

---

## Skills Developed

This course strengthened my experience with:

* Developing server-side Java applications
* Creating dynamic web pages using JSP
* Integrating Java applications with relational databases
* Designing complete CRUD workflows
* Writing and executing SQL queries
* Using JDBC for database communication
* Creating and using JavaBeans
* Applying object-oriented programming principles to web development
* Processing user input through JSP forms
* Implementing server-side validation
* Organizing Java web applications for Apache Tomcat
* Using Java packages and compiled classes
* Debugging server-side applications
* Designing consistent interfaces across multiple JSP pages
* Managing dependencies and Java project structure
* Separating application logic, data objects, and presentation
* Building database-backed applications from the user interface through the database layer

The course provided practical experience connecting Java programming, relational databases, and web technologies into complete server-side applications.

---

## Author

**Wade Eckert**  
Bellevue University  
Bachelor of Science in Software Development and Mathematics
