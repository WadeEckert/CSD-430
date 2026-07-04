# CSD-430
Wade Eckert's repository for CSD-430 - Server Side Development.

This repository demonstrates my progression through Java server-side development, including JSP, JavaBeans, Servlets, and other enterprise Java technologies.

## Repository Structure

```text
CSD-430/
├── module-1/
├── module-2/
├── module-3/
├── module-4/
├── ...
└── WEB-INF/
    └── classes/
        ├── module4/
        └── ...
```

### WEB-INF Directory

The **WEB-INF** directory follows the standard Apache Tomcat web application structure.

The **classes** directory contains Java packages organized by assignment or module. For example, the Module 4 programming assignment stores the `Movie` JavaBean in the following package structure:

```text
WEB-INF/
└── classes/
    └── module4/
        ├── Movie.java
        └── Movie.class
```

As additional assignments are completed, new package directories may be added under **WEB-INF/classes** to organize JavaBeans and other Java classes used by those modules.

This directory structure allows Apache Tomcat to correctly locate and load packaged Java classes while preventing them from being accessed directly through a web browser.

## Author

**Wade Eckert**  
Bellevue University  
Bachelor of Science in Software Development and Mathematics