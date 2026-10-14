/*
    UNIVERSITY DATABASE: GUIDED SQL DEMONSTRATION

    Follow the sequence from top to bottom, executing one statement or
    small group of statements at a time. Inspect the results and discuss
    what each operation changes or protects.

    [EXPECTED ERROR] marks a statement intentionally designed to fail.
    [DISCUSSION] highlights a question or important observation.

    Run this script on a fresh MySQL database server/schema. It is not
    intended to be rerun in its entirety without resetting the database.
*/

/* PART 1: Create the database and define its initial structure. */

/* Create the university database, then make it the active database. */
CREATE DATABASE university;
USE university;

/* A student has a unique ID and email. A major may be undeclared (NULL),
   and new students are active by default unless specified otherwise. */
CREATE TABLE Student (
    StudentID       INT,
    FirstName       VARCHAR(100) NOT NULL,
    LastName        VARCHAR(100) NOT NULL,
    DateOfBirth     DATE NOT NULL,
    Email           VARCHAR(100) NOT NULL,
    Major           VARCHAR(50),
    IsActive        BOOLEAN DEFAULT TRUE,

    CONSTRAINT pk_student
        PRIMARY KEY (StudentID),
    CONSTRAINT uq_student_email
        UNIQUE (Email)
);

/* Each course has a unique code, a title, and a number of credit hours. */
CREATE TABLE Course (
    CourseCode      VARCHAR(10),
    CourseTitle     VARCHAR(100) NOT NULL,
    CreditHours     INT NOT NULL,

    CONSTRAINT pk_course
        PRIMARY KEY (CourseCode)
);

/* A registration connects a student to a course in a specific semester.
   Initially, four columns together identify each registration. The foreign
   keys require the referenced course and student to exist. */
CREATE TABLE Registration (
    CourseCode      VARCHAR(10) NOT NULL,
    OwnerID         INT NOT NULL,
    Semester        VARCHAR(10) NOT NULL,
    SemesterYear    INT NOT NULL,
    Grade           VARCHAR(5),

    CONSTRAINT pk_registration
        PRIMARY KEY (CourseCode, OwnerID, Semester, SemesterYear),
    CONSTRAINT fk_registration_course
        FOREIGN KEY (CourseCode)
            REFERENCES Course(CourseCode),
    CONSTRAINT fk_registration_student
        FOREIGN KEY (OwnerID)
            REFERENCES Student(StudentID)
);

/* PART 2: Populate the tables and inspect their contents. */

/* The Course table starts empty. */
SELECT * FROM Course;

/* Insert one course, then inspect the new row. */
INSERT INTO Course (CourseCode, CourseTitle, CreditHours)
VALUES
    ('CGS2545', 'Database Concepts', 3);

SELECT * FROM Course;

/* A single INSERT statement can add several rows. */
INSERT INTO Course (CourseCode, CourseTitle, CreditHours)
VALUES
    ('COP3223', 'Introduction to Programming in C', 3),
    ('COP3502', 'Computer Science I', 3),
    ('MAC2311', 'Calculus I', 4);

SELECT * FROM Course;

/* Add two students. John's major is unknown, while Maria has declared one.
   IsActive is omitted so the default value TRUE applies. */
SELECT * FROM Student;

INSERT INTO Student (StudentID, FirstName, LastName, DateOfBirth, Email, Major)
VALUES
    (1234567, 'John', 'Doe', '2000-10-06', 'john@ucf.edu', NULL),
    (2345678, 'Maria', 'Cruz', '2005-11-06', 'maria@ucf.edu', 'Information Technology');

SELECT * FROM Student;

/* Record enrollments. A NULL grade means no grade has been entered yet. */
SELECT * FROM Registration;

INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('CGS2545', 1234567, 'Fall', 2026, NULL),
    ('COP3223', 1234567, 'Summer', 2026, 'B+'),
    ('COP3502', 2345678, 'Spring', 2025, 'A');

SELECT * FROM Registration;

/* [EXPECTED ERROR: FOREIGN KEY]
   COP3503 does not exist in Course. MySQL rejects the registration rather
   than allow a reference to a nonexistent course. */
INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('COP3503', 2345678, 'Fall', 2026, NULL);

/* [EXPECTED ERROR: DUPLICATE PRIMARY KEY]
   This student is already registered for CGS2545 in Fall 2026. The four
   primary-key columns match an existing row; changing Grade does not make
   the registration unique. */
INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('CGS2545', 1234567, 'Fall', 2026, 'A+');

/* PART 3: Extend the schema with departments. */

/* The university now wants to track the department offering each course. */
CREATE TABLE Department (
    DeptID          INT,
    DeptName        VARCHAR(100) NOT NULL,

    CONSTRAINT pk_department
        PRIMARY KEY (DeptID)
);

SELECT * FROM Department;

INSERT INTO Department (DeptID, DeptName)
VALUES
    (1, 'Computer Science'),
    (2, 'Mathematics');

SELECT * FROM Department;

/* [EXPECTED ERROR: FOREIGN KEY]
   Existing courses need a value for the new NOT NULL DeptID column.
   DEFAULT 0 supplies that value, but Department 0 does not exist yet.
   The ALTER TABLE fails as a whole; DeptID is not added. */
ALTER TABLE Course
ADD COLUMN DeptID INT NOT NULL DEFAULT 0,
ADD CONSTRAINT fk_course_department
    FOREIGN KEY (DeptID) 
        REFERENCES Department(DeptID);

SELECT * FROM Course;

/* Resolve the problem by creating the department used as the default. */
INSERT INTO Department (DeptID, DeptName)
VALUES
    (0, 'Unassigned');

SELECT * FROM Department;

/* The same ALTER TABLE can now succeed because Department 0 exists. */
ALTER TABLE Course
ADD COLUMN DeptID INT NOT NULL DEFAULT 0,
ADD CONSTRAINT fk_course_department
    FOREIGN KEY (DeptID) 
        REFERENCES Department(DeptID);

SELECT * FROM Course;

/* Assign courses to their departments. Inspect each change. */
UPDATE Course
SET DeptID = 1
WHERE CourseCode = 'CGS2545';

SELECT * FROM Course;

UPDATE Course
SET DeptID = 1
WHERE CourseCode = 'COP3223'
    OR CourseCode = 'COP3502';

SELECT * FROM Course;

UPDATE Course
SET DeptID = 2
WHERE CourseCode = 'MAC2311';

SELECT * FROM Course;

/* PART 4: Update data and reconsider the registration primary key. */

SELECT * FROM Registration;

/* Set the grade of a registration. */
UPDATE Registration
SET Grade = 'F'
WHERE CourseCode = 'CGS2545'
    AND OwnerID = 1234567
    AND Semester = 'Fall'
    AND SemesterYear = 2026;

SELECT * FROM Registration;

/* Replace the composite primary key with an automatically generated RegNo.
   First add a separate index on CourseCode so the foreign key remains
   supported when the old primary-key index is removed. */
ALTER TABLE Registration
ADD INDEX idx_registration (CourseCode),
DROP PRIMARY KEY,
ADD COLUMN RegNo INT AUTO_INCREMENT,
ADD CONSTRAINT pk_registration
    PRIMARY KEY (RegNo);

SELECT * FROM Registration;

/* [DISCUSSION: LOGICAL DUPLICATE]
   This INSERT now succeeds: RegNo is different, even though the student,
   course, and term duplicate an existing registration. A surrogate primary
   key alone does not enforce the original business rule. */
INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('COP3502', 2345678, 'Spring', 2025, 'B+');

SELECT * FROM Registration;

/* Remove the duplicate row just added. For this fresh demonstration it is
   normally RegNo 4; verify the value in the preceding SELECT before running.
   Do not assume AUTO_INCREMENT values are always sequential in general. */
DELETE FROM Registration
WHERE RegNo = 4;

SELECT * FROM Registration;

/* Restore the business rule independently of the surrogate primary key. */
ALTER TABLE Registration
ADD CONSTRAINT uq_registration
    UNIQUE (CourseCode, OwnerID, Semester, SemesterYear);

SELECT * FROM Registration;

/* [EXPECTED ERROR: UNIQUE CONSTRAINT]
   The same logical duplicate is now rejected by uq_registration. */
INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('COP3502', 2345678, 'Spring', 2025, 'B+');

/* [DISCUSSION: INVALID DOMAIN VALUE]
   This INSERT succeeds for now. 'Winter' is not one of the intended
   semesters, but no CHECK constraint has been defined yet. */
SELECT * FROM Registration;

INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('COP3502', 2345678, 'Winter', 2025, 'B+');

SELECT * FROM Registration;

/* Remove the registration with the invalid semester.
   CAUTION: Verify the actual RegNo using SELECT before deleting.
   The RegNo may differ because failed INSERT statements can
   consume AUTO_INCREMENT values. */
DELETE FROM Registration
WHERE RegNo = 6;

SELECT * FROM Registration;

/* Restrict future semester values to the three recognized terms. */
ALTER TABLE Registration
ADD CONSTRAINT chk_registration_semester
    CHECK (Semester IN ('Spring', 'Summer', 'Fall'));

/* [EXPECTED ERROR: CHECK CONSTRAINT]
   Winter is now explicitly prohibited. */
INSERT INTO Registration (CourseCode, OwnerID, Semester, SemesterYear, Grade)
VALUES
    ('CGS2545', 2345678, 'Winter', 2026, NULL);

/* PART 5: Investigate referential actions on course changes. */

/* [EXPECTED ERROR: RESTRICTED DELETE]
   CGS2545 is referenced by Registration. Without ON DELETE CASCADE or
   another suitable action, MySQL prevents deleting the parent course. */
SELECT * FROM Course;

DELETE FROM Course
WHERE CourseCode = 'CGS2545';

SELECT * FROM Registration;

/* [EXPECTED ERROR: RESTRICTED UPDATE]
   Changing the referenced course code would leave a registration pointing
   to the old code, so the default foreign-key behavior blocks the update. */
UPDATE Course
SET CourseCode = 'CGS2545C'
WHERE CourseCode = 'CGS2545';

/* [EXPLANATION: DEFAULT REFERENTIAL ACTIONS]
   When we originally created the Registration table, we defined a
   foreign key referencing Course(CourseCode), but we did not specify
   what should happen when a referenced course is deleted or its
   CourseCode is updated.

   As a result, MySQL uses the default referential action, NO ACTION.
   In MySQL, NO ACTION is equivalent to RESTRICT because foreign key
   constraints are checked immediately.

   Therefore, MySQL prevents deleting or updating a course if doing so
   would violate the foreign key constraint in Registration.

   To allow different behaviors, we must explicitly specify the
   appropriate ON DELETE or ON UPDATE action in the foreign key
   constraint. */

/* Recreate the foreign key with ON UPDATE CASCADE. This permits changes to
   a course code to propagate to referencing registrations automatically. */
ALTER TABLE Registration
DROP FOREIGN KEY fk_registration_course;

ALTER TABLE Registration
ADD CONSTRAINT fk_registration_course
    FOREIGN KEY (CourseCode)
        REFERENCES Course(CourseCode)
        ON UPDATE CASCADE;

SELECT * FROM Registration;
SELECT * FROM Course;

/* The update now succeeds; compare Course and Registration afterward. */
UPDATE Course
SET CourseCode = 'CGS2545C'
WHERE CourseCode = 'CGS2545';

SELECT * FROM Course;
SELECT * FROM Registration;

/* PART 6: Handle deletion of a department without deleting its courses. */

/* [DISCUSSION]
   The Mathematics department is being removed, but Calculus I should
   remain in the catalog. We want its DeptID to become NULL instead.
   That requires a nullable DeptID and an ON DELETE SET NULL foreign key. */
SELECT * FROM Course;

ALTER TABLE Course
DROP FOREIGN KEY fk_course_department;

ALTER TABLE Course
MODIFY COLUMN DeptID INT,
ADD CONSTRAINT fk_course_department
    FOREIGN KEY (DeptID)
        REFERENCES Department(DeptID)
        ON DELETE SET NULL;

SELECT * FROM Course;
SELECT * FROM Department;

/* Deleting Mathematics keeps MAC2311, but sets its DeptID to NULL. */
DELETE FROM Department
WHERE DeptID = 2;

SELECT * FROM Department;
SELECT * FROM Course;

/* [FINAL ACTIVITY: REVERSE ENGINEERING THE DATABASE]
   Now that we have created and modified the university database,
   let us examine its final structure.

   Using MySQL Workbench, perform reverse engineering to generate
   an EER diagram from the existing university database.

   Examine the resulting diagram and identify the tables, primary
   keys, foreign keys, and relationships.

   Compare the generated diagram with our original database design.
   How has the structure changed after all the modifications we made?

   This activity demonstrates how reverse engineering can reconstruct
   a database model from an existing database schema. */

/* END OF GUIDED DEMONSTRATION */
