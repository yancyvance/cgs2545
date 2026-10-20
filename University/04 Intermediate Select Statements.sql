
/* Select the university database for the following SQL queries. */
USE university;


/* Task 1: List all courses.
   Review SELECT * to retrieve all columns. */
SELECT * FROM Course;


/* Task 2: List all courses whose codes begin with the letter C.
   Introduce LIKE and the % wildcard, which matches
   zero or more characters. */
SELECT * FROM Course
WHERE CourseCode LIKE 'C%';


/* Task 3: List all 3000-level courses.
   Introduce the _ wildcard, which matches exactly one character.

   The pattern assumes that course codes consist of a
   three-character prefix followed by a four-digit number.

   Note: This pattern matches any code with exactly three
   characters before the digit 3 and zero or more characters
   afterward. It does not enforce a seven-character code
   or verify that the remaining characters are digits. */
SELECT * FROM Course
WHERE CourseCode LIKE '___3%';


/* Task 4: List all courses whose titles begin with "Computer".
   Demonstrate using LIKE to match a prefix in a text column.
   The result depends on the column's collation, which
   determines whether matching is case-sensitive. */
SELECT * FROM Course
WHERE CourseTitle LIKE 'Computer%';


/* Task 5: List all courses whose titles do not contain "Computer".
   Introduce NOT LIKE to exclude records matching a pattern. */
SELECT * FROM Course
WHERE CourseTitle NOT LIKE '%Computer%';


/* Task 6: List all courses whose titles contain neither
   "Computer" nor "Programming".
   Demonstrate combining NOT LIKE conditions using logical operators. */

/* [INTENTIONAL LOGIC ERROR]
   Using OR produces unintended results because a course
   only needs to satisfy one of the two conditions.

   For example, a course containing "Computer" but not
   "Programming" would still be included. */
SELECT * FROM Course
WHERE CourseTitle NOT LIKE '%Computer%'
    OR CourseTitle NOT LIKE '%Programming%';


/* [CORRECTED QUERY]
   Use AND to ensure that neither word appears in the title. */
SELECT * FROM Course
WHERE CourseTitle NOT LIKE '%Computer%'
    AND CourseTitle NOT LIKE '%Programming%';



/* Introduction to Scalar Functions

   A scalar function accepts one or more arguments and
   returns a single value for each invocation.

   When a scalar function uses a column in a SELECT query,
   it operates on the value from each row, producing
   a corresponding result for that row.

   Examples include SUBSTRING(), CONCAT(), and CAST().

   Scalar functions can be used to transform or calculate
   values without modifying the underlying data. */


/* Task 7: List all courses and add a calculated column
   named CoursePrefix containing the first three characters
   of the course code.

   Introduce SUBSTRING() as a scalar function.
   Demonstrate how the function operates on CourseCode
   for each row to produce the corresponding CoursePrefix.

   Character positions begin at 1. */
SELECT
    *,
    SUBSTRING(CourseCode, 1, 3) AS CoursePrefix
FROM Course;



/* Task 8: List all courses and add two calculated columns:
   CoursePrefix containing the first three characters and
   CourseNumber containing the last four characters.

   Assume that each course code consists of exactly seven
   characters, where the first three characters represent
   the course prefix and the last four represent the course
   number.

   Demonstrate that omitting the length argument in
   SUBSTRING() extracts all characters from the specified
   starting position to the end of the string. */
SELECT
    *,
    SUBSTRING(CourseCode, 1, 3) AS CoursePrefix,
    SUBSTRING(CourseCode, 4) AS CourseNumber
FROM Course;



/* Task 9: List all courses and add calculated columns
   named CourseLevel and CourseLevel2, both representing
   the course level (e.g., 2000, 3000, or 4000).

   Demonstrate two approaches:
   1. CAST() converts the extracted character into a number,
      which is then multiplied by 1000.
   2. CONCAT() appends "000" to the extracted character.

   Note: CourseLevel is numeric, while CourseLevel2 is a string.
   Both approaches assume a three-character course prefix. */
SELECT
    *,
    CAST(SUBSTRING(CourseCode, 4, 1) AS UNSIGNED) * 1000 AS CourseLevel,
    CONCAT(SUBSTRING(CourseCode, 4, 1), '000') AS CourseLevel2
FROM Course;


/* Task 10: List all courses arranged by course level
   in ascending order. For courses with the same level,
   arrange them by course code in ascending order.

   Demonstrate that ORDER BY can reference a calculated
   column alias defined in SELECT. */
SELECT
    *,
    CAST(SUBSTRING(CourseCode, 4, 1) AS UNSIGNED) * 1000 AS CourseLevel
FROM Course
ORDER BY CourseLevel ASC, CourseCode ASC;


/* Task 11: List only 2000-level courses.
   Demonstrate the limitation of calculated column aliases
   when used in WHERE. */

/* [INTENTIONAL ERROR]
   CourseLevel is defined as an alias in SELECT.
   WHERE cannot reference this alias at the same query level
   because WHERE is logically evaluated before SELECT. */
SELECT
    *,
    CAST(SUBSTRING(CourseCode, 4, 1) AS UNSIGNED) * 1000 AS CourseLevel
FROM Course
WHERE CourseLevel = 2000;

/* [CORRECTED QUERY]
   Repeat the calculated expression in WHERE instead
   of referencing the CourseLevel alias. */
SELECT
    *,
    CAST(SUBSTRING(CourseCode, 4, 1) AS UNSIGNED) * 1000 AS CourseLevel
FROM Course
WHERE (CAST(SUBSTRING(CourseCode, 4, 1) AS UNSIGNED) * 1000) = 2000;


/* Task 12: List all students.
   Review the Student table before examining majors. */
SELECT * FROM Student;


/* Task 13: List the different majors declared by students.
   Demonstrate DISTINCT to eliminate duplicate values.

   Note: DISTINCT returns one NULL entry if the selected
   column contains NULL values. */
SELECT DISTINCT Major FROM Student;


/* Task 14: List all distinct student records.
   Demonstrate that DISTINCT applies to the entire
   selected row rather than individual columns.

   Since StudentID is a primary key, every student record
   is already unique, making DISTINCT unnecessary here. */
SELECT DISTINCT * FROM Student;


/* Task 15: List all students whose major is not
   Information Technology.
   Demonstrate the != comparison operator.

   Note: Students whose Major is NULL are excluded because
   comparisons involving NULL evaluate to UNKNOWN.
   WHERE only includes rows whose condition is TRUE. */
SELECT * FROM Student
WHERE Major != 'Information Technology';


/* Task 16: List all students whose major is not
   Information Technology using NOT LIKE.

   Demonstrate NOT LIKE without wildcard characters.
   Unlike !=, pattern matching is affected by collation.

   Note: Students whose Major is NULL are still excluded. */
SELECT * FROM Student
WHERE Major NOT LIKE 'Information Technology';


/* Task 17: List all students whose major is not
   Information Technology, including students who have
   not declared a major.

   Demonstrate combining != with IS NULL.
   Recall that NULL must be checked using IS NULL,
   rather than = NULL or != NULL. */
SELECT * FROM Student
WHERE Major != 'Information Technology'
    OR Major IS NULL;


/* Task 18: List all students and add calculated columns
   that display "Undeclared" when Major is NULL.

   Introduce IFNULL() and COALESCE().

   IFNULL() accepts exactly two arguments.
   COALESCE() returns the first non-NULL argument
   and can accept multiple arguments.

   Both functions produce the same displayed values
   for this example. */
SELECT
    *,
    IFNULL(Major, 'Undeclared') AS CurrentMajor,
    COALESCE(Major, 'Undeclared') AS CurrentMajor2
FROM Student;


/* Task 19: List all students and add a calculated column
   named CurrentMajor that displays the student's major,
   or "Undeclared" if the major is NULL.

   Demonstrate COALESCE() as a standard SQL function
   for handling NULL values.

   Note: The original Major column is not modified. */
SELECT
    *,
    COALESCE(Major, 'Undeclared') AS CurrentMajor
FROM Student;


/* Task 20: List all students whose major is not
   Information Technology, including undeclared students.

   Demonstrate an alternative solution to Task 17
   using COALESCE() in the WHERE clause.

   The NULL value is replaced with "Undeclared"
   before the comparison is performed. */
SELECT * FROM Student
WHERE COALESCE(Major, 'Undeclared') != 'Information Technology';


/* Task 21: List all students and add a calculated column
   named FullName containing the student's last name,
   followed by a comma, a space, and the first name.

   Introduce CONCAT() for combining string values.
   Note: CONCAT() returns NULL if any argument is NULL. */
SELECT
    *,
    CONCAT(LastName, ', ', FirstName) AS FullName
FROM Student;


/* Task 22: List all students born on or before
   October 11, 2005.

   Demonstrate comparing DATE values using <=.
   DateOfBirth is a DATE column without a time component.

   Use the YYYY-MM-DD format for date literals. */
SELECT * FROM Student
WHERE DateOfBirth <= '2005-10-11';


/* Task 23: List all students born on or before
   October 11, 2005, using an alternative condition.

   Demonstrate that comparing dates before October 12, 2005
   produces the same result as Task 22.

   The < operator excludes the specified boundary date.
   This approach is also useful for DATETIME columns when
   filtering records through the end of a calendar day. */
SELECT * FROM Student
WHERE DateOfBirth < '2005-10-12';
