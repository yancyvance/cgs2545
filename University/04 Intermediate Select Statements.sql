
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
