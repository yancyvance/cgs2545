
/* Select the university database for the following SQL queries. */
USE university;


/* Task 1: List all students.
   Demonstrate SELECT * to retrieve all columns. */
SELECT * FROM Student;


/* Task 2: List all students, displaying only their
   StudentID, FirstName, and LastName.
   Demonstrate projection (selecting specific columns). */
SELECT StudentID, FirstName, LastName FROM Student;


/* Task 3: List all students whose major is
   Information Technology.
   Demonstrate filtering using WHERE. */
SELECT * FROM Student
WHERE Major = 'Information Technology';


/* Task 4: List all students whose major is either
   Information Technology or Computer Science.
   Demonstrate the OR operator. */
SELECT * FROM Student
WHERE Major = 'Information Technology'
    OR Major = 'Computer Science';


/* Task 5: List all inactive students whose major is
   Information Technology or Computer Science.
   Demonstrate operator precedence and the importance
   of parentheses when combining AND and OR. */

/* [INTENTIONAL LOGIC ERROR]
   AND has higher precedence than OR, so the condition
   IsActive = FALSE applies only to Computer Science majors.
   Consequently, active Information Technology students
   may also appear in the results. */
SELECT * FROM Student
WHERE Major = 'Information Technology'
    OR Major = 'Computer Science'
    AND IsActive = FALSE;

/* [CORRECTED QUERY]
   Group the major conditions using parentheses so that
   IsActive = FALSE applies to both majors. */
SELECT * FROM Student
WHERE ( Major = 'Information Technology'
    OR Major = 'Computer Science' )
    AND IsActive = FALSE;


/* Task 6: List all inactive students whose major is
   Information Technology, Computer Science, or Mathematics.
   Demonstrate IN as an alternative to multiple OR conditions. */
SELECT * FROM Student
WHERE Major IN ('Information Technology', 'Computer Science', 'Mathematics')
    AND IsActive = FALSE;


/* Task 7: List all inactive students who have declared
   a major other than Mathematics.
   Demonstrate the != comparison operator. */
SELECT * FROM Student
WHERE IsActive = FALSE
    AND Major != 'Mathematics';


/* Task 8: List all students who have not declared a major.
   Demonstrate IS NULL. */
SELECT * FROM Student
WHERE Major IS NULL;


/* Task 9: List all active students who have not declared
   a major.
   Demonstrate combining IS NULL with AND. */
SELECT * FROM Student
WHERE Major IS NULL
    AND IsActive = TRUE;


/* Task 10: List the last name, first name, and email
   of active students who have not declared a major.
   Demonstrate combining projection and selection. */
SELECT LastName, FirstName, Email FROM Student
WHERE Major IS NULL
    AND IsActive = TRUE;


/* Task 11: List all active students who have already
   declared a major.
   Demonstrate IS NOT NULL. */
SELECT * FROM Student
WHERE Major IS NOT NULL
    AND IsActive = TRUE;


/* Task 12: List all courses arranged alphabetically
   by course title.
   Demonstrate ORDER BY with ASC. */
SELECT * FROM Course
ORDER BY CourseTitle ASC;


/* Task 13: List all courses arranged by credit hours
   in descending order.
   Demonstrate ORDER BY with DESC. */
SELECT * FROM Course
ORDER BY CreditHours DESC;


/* Task 14: List all courses arranged by credit hours
   in descending order. For courses with the same
   credit hours, arrange them alphabetically by title.
   Demonstrate sorting by multiple columns. */
SELECT * FROM Course
ORDER BY CreditHours DESC, CourseTitle ASC;


/* Task 15: List all courses with fewer than 3 credit hours.
   Demonstrate filtering using the < comparison operator. */
SELECT * FROM Course
WHERE CreditHours < 3;


/* Task 16: List all courses with fewer than 3 credit hours.
   Arrange them by credit hours in descending order,
   then by course title in ascending order.
   Demonstrate combining WHERE and ORDER BY. */
SELECT * FROM Course
WHERE CreditHours < 3
ORDER BY CreditHours DESC, CourseTitle ASC;


/* Task 17: List all registrations for the year 2026.
   Demonstrate filtering records using an integer value. */
SELECT * FROM Registration
WHERE SemesterYear = 2026;


/* Task 18: List all registrations for the years
   2025 and 2026.
   Demonstrate OR with multiple equality conditions. */
SELECT * FROM Registration
WHERE SemesterYear = 2025
    OR SemesterYear = 2026;


/* Task 19: List all registrations from 2024 through 2026,
   inclusive.
   Demonstrate BETWEEN for filtering a range of values. */
SELECT * FROM Registration
WHERE SemesterYear BETWEEN 2024 AND 2026;


/* Task 20: List all registrations for the years
   2020, 2022, and 2024.
   Demonstrate IN for matching specific values. */
SELECT * FROM Registration
WHERE SemesterYear IN (2020, 2022, 2024);


/* Task 21: List all registrations that occurred
   during an even-numbered year.
   Demonstrate using an arithmetic expression
   with the modulo (%) operator in WHERE. */
SELECT * FROM Registration
WHERE ( SemesterYear % 2 = 0 );


/* Task 22: List all registrations whose grade
   has not yet been recorded.
   Demonstrate checking for missing values using IS NULL. */
SELECT * FROM Registration
WHERE Grade IS NULL;
