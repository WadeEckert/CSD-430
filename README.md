# CSD 430 – Server Side Development

This repository contains my coursework for **CSD 430 – Server Side Development** at **Bellevue University**.

This course focused on server-side web application development using Java and Jakarta EE technologies. Throughout the course, I worked with JavaServer Pages (JSP), JavaBeans, JDBC, MySQL, Apache Tomcat, Maven, and other server-side development concepts. The coursework progressed from introductory JSP applications to a multi-module CRUD database application.

---

## Repository Structure

The repository is organized by module, with each folder containing the JSP pages, source code, database scripts, documentation, and other files completed during that portion of the course.

```text
CSD-430/
├── module-1/
├── module-2/
├── module-3/
├── module-4/
├── module-5-6/
├── module-7/
├── module-8/
├── module-9/
├── ...
└── WEB-INF/
    └── classes/
```

The `WEB-INF` directory contains compiled Java classes and package structures required by Apache Tomcat for applications that use JavaBeans and other Java classes.

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

---

## Major Projects

### JavaBean Movie Application

An early project in the course used JSP and JavaBeans to create and display structured movie data.

The application demonstrates:

* Creating JavaBean classes
* Using private fields with getter and setter methods
* Organizing Java classes into packages
* Compiling Java classes for Apache Tomcat
* Using JSP standard actions such as `<jsp:useBean>`, `<jsp:setProperty>`, and `<jsp:getProperty>`
* Displaying JavaBean data in an HTML table
* Styling server-generated content with CSS

---

### U.S. States CRUD Application

The primary project developed throughout the later modules of the course is a multi-page CRUD web application for managing information about U.S. states.

The application integrates JSP, Java, JDBC, MySQL, HTML, and CSS to provide a complete database-backed web application.

The database stores information including:

* State name
* State abbreviation
* Capital
* Population
* State bird
* State flower

The application implements all four primary CRUD operations:

* **Create** – Add new state records to the database
* **Read** – Select and display existing state records
* **Update** – Modify existing state information
* **Delete** – Remove state records from the database

Additional database utilities allow the application database table to be created, populated, and removed directly through JSP pages.

---

## CRUD Application Features

The completed CRUD project includes:

* MySQL database integration using JDBC
* Prepared SQL statements
* Dynamic JSP pages
* Database table creation and population
* State record selection
* Record creation
* Record updating
* Record deletion
* Server-side input validation
* Error and success messages
* Reusable JavaBean data objects
* Consistent navigation between application pages
* Responsive CSS styling
* SQL scripts for database setup
* A centralized project home page for accessing application utilities

The project was developed incrementally across several course modules, with each stage adding another component of the CRUD workflow.

---

## Technologies Used

* **Java**
* **JavaServer Pages (JSP)**
* **Jakarta EE**
* **JavaBeans**
* **JDBC**
* **MySQL**
* **Apache Tomcat**
* **Maven**
* **HTML**
* **CSS**
* **SQL**
* **Git**
* **GitHub**
* **Visual Studio Code**

---

## Apache Tomcat and WEB-INF

The applications in this repository were developed and tested using **Apache Tomcat**.

Java classes used by JSP applications are organized under the `WEB-INF/classes` directory according to their Java package structure. For example, the Module 4 Movie JavaBean uses the following structure:

```text
WEB-INF/
└── classes/
    └── module4/
        ├── Movie.java
        └── Movie.class
```

The larger CRUD application also uses packaged Java classes within `WEB-INF/classes`.

This structure allows Apache Tomcat to locate and load application classes while preventing files inside `WEB-INF` from being accessed directly through a web browser.

Because these projects are server-side Java applications, they require a compatible Java environment and servlet container such as Apache Tomcat rather than a static web hosting service.

---

## Skills Developed

This course strengthened my experience with:

* Developing server-side Java applications
* Integrating Java applications with relational databases
* Designing CRUD workflows
* Writing and executing SQL queries
* Using JDBC for database communication
* Creating and using JavaBeans
* Processing user input through JSP forms
* Validating application data
* Organizing Java web applications for Apache Tomcat
* Debugging server-side applications
* Designing consistent interfaces across multiple JSP pages
* Managing dependencies and Java project structure
* Applying object-oriented programming concepts to web development
* Building database-backed web applications from front end to database

The course provided practical experience connecting Java programming, relational databases, and web technologies into complete server-side applications.

---

## Author

**Wade Eckert**
Bellevue University
Bachelor of Science in Software Development and Mathematics
