
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


/* Task 22: List all students and add a calculated column
   named LastNameLength containing the number of characters
   in each student's last name.

   Introduce CHAR_LENGTH() for counting characters in a string.
   Note: CHAR_LENGTH(NULL) returns NULL. */
SELECT
    *,
    CHAR_LENGTH(LastName) AS LastNameLength
FROM Student;


/* Task 23: List all students born on or before
   October 11, 2005.

   Demonstrate comparing DATE values using <=.
   DateOfBirth is a DATE column without a time component.

   Use the YYYY-MM-DD format for date literals.
   DATE() is unnecessary because DateOfBirth is already
   a DATE column. */
SELECT * FROM Student
WHERE DateOfBirth <= '2005-10-11';

/* [ALTERNATIVE QUERY]
   DATE() extracts the date portion of a date or datetime
   value. It is valid here but unnecessary for a DATE column. */
SELECT * FROM Student
WHERE DATE(DateOfBirth) <= '2005-10-11';


/* Task 24: List all students born on or before
   October 11, 2005, using an alternative condition.

   Demonstrate that comparing dates before October 12, 2005
   produces the same result as Task 23.

   The < operator excludes the specified boundary date.
   This approach is also useful for DATETIME columns when
   filtering records through the end of a calendar day. */
SELECT * FROM Student
WHERE DateOfBirth < '2005-10-12';


/* Task 25: List all students born between January 1, 2000,
   and October 1, 2000, inclusive.

   Demonstrate BETWEEN for an inclusive range and compare
   it with equivalent >= and <= conditions. */
SELECT * FROM Student
WHERE DateOfBirth BETWEEN '2000-01-01' AND '2000-10-01';

/* [ALTERNATIVE QUERY]
   BETWEEN includes both endpoints of the range.
   DATE() is unnecessary because DateOfBirth is already
   a DATE column. The following comparisons are equivalent. */
SELECT * FROM Student
WHERE DateOfBirth >= '2000-01-01'
    AND DateOfBirth <= '2000-10-01';

/* [ALTERNATIVE QUERY USING DATE()]
   Applying DATE() also works, but adds an unnecessary
   function call when the column is already a DATE. */
SELECT * FROM Student
WHERE DATE(DateOfBirth) >= '2000-01-01'
    AND DATE(DateOfBirth) <= '2000-10-01';


/* Task 26: List all students with a calculated BirthYear.
   Sort by birth year in descending order, then by
   student ID in ascending order.

   Introduce YEAR() to extract the year from a DATE.
   ORDER BY can reference the BirthYear alias. */
SELECT
    *,
    YEAR(DateOfBirth) AS BirthYear
FROM Student
ORDER BY BirthYear DESC, StudentID ASC;


/* Task 27: List only students born in the year 2000.
   Revisit the limitation of SELECT aliases in WHERE. */

/* [INTENTIONAL ERROR]
   BirthYear is defined in SELECT and cannot be referenced
   in WHERE at the same query level. */
SELECT
    *,
    YEAR(DateOfBirth) AS BirthYear
FROM Student
WHERE BirthYear = 2000;

/* [CORRECTED QUERY]
   Use the YEAR() expression directly in WHERE. */
SELECT *
FROM Student
WHERE YEAR(DateOfBirth) = 2000;


/* Task 28: List students born in 2000 and arrange them
   by date of birth in ascending order, then student ID.

   Demonstrate using a scalar function in WHERE and ORDER BY.
   Note: Sorting by YEAR(DateOfBirth) is redundant here
   because all returned students have the same birth year. */
SELECT *
FROM Student
WHERE YEAR(DateOfBirth) = 2000
ORDER BY YEAR(DateOfBirth) DESC, DateOfBirth ASC, StudentID ASC;


/* Task 29: Find the youngest student in the database.
   Demonstrate ORDER BY with LIMIT to return one row.

   A later birth date indicates a younger student.
   Note: If multiple students share the latest birth date,
   LIMIT 1 returns only one of them. Since no tie-breaking
   criterion is specified, which student is returned is
   not guaranteed and may vary between executions. */
SELECT * FROM Student
ORDER BY DateOfBirth DESC
LIMIT 1;


/* Task 30: List all students and estimate their age
   by subtracting their birth year from 2026.

   Demonstrate arithmetic using YEAR(). */

/* [INTENTIONAL LOGIC ERROR]
   Subtracting birth years does not account for whether
   the student's birthday has occurred during the year.
   It also hardcodes 2026 rather than using today's date. */
SELECT
    *,
    2026 - YEAR(DateOfBirth) AS EstimatedAge
FROM Student;

/* [CORRECTED QUERY]
   Compare the year-subtraction approach with TIMESTAMPDIFF().

   CURDATE() is a function that returns the current date
   based on the server's session time zone.

   TIMESTAMPDIFF() returns the difference between two date/time
   values in the specified unit. YEAR is one possible unit;
   others include MONTH, DAY, HOUR, MINUTE, and SECOND.

   TIMESTAMPDIFF(YEAR, ...) counts complete elapsed years,
   accounting for whether the birthday has passed. */
SELECT
    *,
    YEAR(CURDATE()) - YEAR(DateOfBirth) AS EstimatedAge,
    TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) AS CurrentAge
FROM Student;


/* Task 31: List all students whose birthday falls in October.
   Introduce MONTH() to extract the month from a DATE.

   Note: The birth year does not affect the birthday month. */
SELECT
    *,
    MONTH(DateOfBirth) AS BirthMonth
FROM Student
WHERE MONTH(DateOfBirth) = 10;


/* Task 32: List all students born during a leap year.
   Demonstrate combining arithmetic, comparison, AND,
   and OR conditions.

   A year is a leap year if it is divisible by 400,
   or divisible by 4 but not by 100. */
SELECT * FROM Student
WHERE (YEAR(DateOfBirth) % 400 = 0)
    OR (YEAR(DateOfBirth) % 4 = 0 AND YEAR(DateOfBirth) % 100 != 0);


/* Task 33: List all registrations.
   Review the Registration table before analyzing grades. */
SELECT * FROM Registration;


/* Task 34: List only the unique student IDs of students
   who have made at least one registration. Each student
   ID must appear exactly once, even if that student has
   multiple registrations.

   Demonstrate DISTINCT on a foreign-key column.
   Sort the unique student IDs in ascending order. */
SELECT DISTINCT OwnerID
FROM Registration
ORDER BY OwnerID;


/* Task 35: List all distinct grades recorded in Registration.
   Demonstrate that DISTINCT includes one NULL result
   when some registrations have not yet been graded. */
SELECT DISTINCT Grade FROM Registration;


/* Task 36: List all registrations and add calculated columns
   named GradePoint and GradeRemark.

   Introduce the two forms of CASE expressions:
   1. Simple CASE compares an expression against specific values.
   2. Searched CASE evaluates conditions in order and returns
      the result for the first condition that is TRUE.

   Both forms can include an optional ELSE clause to specify
   a result when no WHEN clause matches. Without ELSE,
   the expression returns NULL if no condition matches.

   Note: ELSE -1 in the first CASE is a demonstration placeholder
   for grades that do not match any listed value, including NULL.
   It is not a valid grade point or GPA value. */
SELECT
    *,
    CASE Grade
        WHEN 'A' THEN 4.00
        WHEN 'A-' THEN 3.75
        WHEN 'B+' THEN 3.25
        WHEN 'B' THEN 3.00
        WHEN 'B-' THEN 2.75
        WHEN 'C+' THEN 2.25
        WHEN 'C' THEN 2.00
        WHEN 'C-' THEN 1.75
        WHEN 'D' THEN 1.00
        WHEN 'F' THEN 0.00
        ELSE -1     -- Demonstration placeholder for unmatched or NULL grades.
    END AS GradePoint,
    CASE
        WHEN Grade IS NULL THEN 'Not Graded'
        WHEN Grade IN ('A', 'A-', 'B+', 'B', 'B-') THEN 'Satisfactory'
        WHEN Grade IN ('C+', 'C') THEN 'Needs Improvement'
        WHEN Grade IN ('C-', 'D', 'F') THEN 'Failed'
    END AS GradeRemark
FROM Registration;


/* Introduction to Aggregate Functions

   An aggregate function summarizes values across rows
   and returns one result for each group, or one result
   for the entire table when no GROUP BY is specified.

   Examples include COUNT(), MIN(), MAX(), SUM(), and AVG().

   COUNT(*) counts rows, while COUNT(column) excludes rows
   where the specified column is NULL. */


/* Task 37: Count all registrations in the database.
   Introduce COUNT(*) to count rows. */
SELECT * FROM Registration;

SELECT COUNT(*) AS RegCount
FROM Registration;


/* Task 38: Count registrations made during Fall 2026.
   Demonstrate using WHERE to filter rows before
   calculating an aggregate result. */
SELECT COUNT(*) AS RegCount
FROM Registration
WHERE SemesterYear = 2026
    AND Semester = 'Fall';


/* Task 39: Count registrations for each semester year.
   Introduce GROUP BY to calculate a separate COUNT(*)
   for each distinct SemesterYear value.

   Without GROUP BY, COUNT(*) would return a single total.
   ORDER BY can be added to sort the years if desired. */
SELECT
    SemesterYear,
    COUNT(*) AS RegCount
FROM Registration
GROUP BY SemesterYear;


/* Task 40: Count registrations for each semester year and
   arrange the results by year in descending order.

   Extend Task 39 by adding ORDER BY after GROUP BY.
   Sorting does not change how the groups are formed. */
SELECT
    SemesterYear,
    COUNT(*) AS RegCount
FROM Registration
GROUP BY SemesterYear
ORDER BY SemesterYear DESC;


/* Task 41: Count registrations for each semester year.
   Sort by the registration count in descending order,
   breaking ties by semester year in ascending order.

   Demonstrate ORDER BY using an aggregate column alias
   and a second expression to establish a tie-breaker. */
SELECT
    SemesterYear,
    COUNT(*) AS RegCount
FROM Registration
GROUP BY SemesterYear
ORDER BY RegCount DESC, SemesterYear ASC;


/* Task 42: List semester years ordered by the number of
   registrations in each year, without displaying the count.

   Demonstrate that ORDER BY can use an aggregate expression
   even when that expression is not included in SELECT.
   The COUNT(*) output column is intentionally commented out. */
SELECT
    SemesterYear
--    COUNT(*) AS RegCount
FROM Registration
GROUP BY SemesterYear
ORDER BY COUNT(*) DESC, SemesterYear ASC;


/* Task 43: Count registrations for each semester within
   each academic year.

   Introduce GROUP BY with multiple columns. Each distinct
   combination of SemesterYear and Semester forms a group.
   ORDER BY SemesterYear sorts the years, but does not
   guarantee the order of semesters within the same year. */
SELECT
    SemesterYear,
    Semester,
    COUNT(*) AS RegCount
FROM Registration
GROUP BY SemesterYear, Semester
ORDER BY SemesterYear;


/* Task 44: Display semester/year groups with more than
   40 registrations.

   [INTENTIONAL ERROR]
   COUNT(*) is an aggregate function and cannot be used
   in WHERE to filter groups. WHERE filters individual
   rows before GROUP BY forms the groups. */
SELECT
    SemesterYear,
    Semester,
    COUNT(*) AS RegCount
FROM Registration
WHERE COUNT(*) > 40
GROUP BY SemesterYear, Semester
ORDER BY SemesterYear;


/* [CORRECTED QUERY]
   HAVING filters groups after grouping. MySQL permits
   the SELECT alias RegCount to be referenced in HAVING.
   A portable alternative is HAVING COUNT(*) > 40. */
SELECT
    SemesterYear,
    Semester,
    COUNT(*) AS RegCount
FROM Registration
GROUP BY SemesterYear, Semester
HAVING RegCount > 40
ORDER BY SemesterYear;


/* Task 45: List all registrations made by student 1234567.
   Review filtering individual rows with WHERE before
   calculating registration statistics for one student. */
SELECT * FROM Registration
WHERE OwnerID = 1234567;


/* Task 46: Determine the total number of registrations
   made by student 1234567.

   Combine WHERE and COUNT(*). Since GROUP BY is omitted,
   the query returns one aggregate result for the
   qualifying registrations. */
SELECT 
    COUNT(*) AS RegCount 
FROM Registration
WHERE OwnerID = 1234567;


/* Task 47: Count how many registrations for student
   1234567 already have a recorded grade.

   WHERE Grade IS NOT NULL excludes ungraded registrations.
   Compare this approach with COUNT(Grade), which ignores
   NULL values in its argument. */
SELECT COUNT(*) FROM Registration
WHERE OwnerID = 1234567
    AND Grade IS NOT NULL;


/* Task 48: Summarize student 1234567's registrations.
   Display the total count, graded count, and completion rate.

   COUNT(*) includes every registration; COUNT(Grade)
   excludes NULL grades. Dividing the latter by the former
   gives the proportion graded, between 0 and 1.
   ROUND(..., 2) rounds the displayed proportion.
   This example assumes the student has registrations. */
SELECT 
    COUNT(*) AS RegCount,
    COUNT(Grade) AS GradedCount,
    ROUND( COUNT(Grade) / COUNT(*), 2 ) AS CompletionRate
FROM Registration
WHERE OwnerID = 1234567;


/* Task 49: Add a calculated MissingRate column for
   student 1234567.

   MissingRate is the proportion of registrations with
   no recorded grade. Since every registration is either
   graded or ungraded, MissingRate = 1 - CompletionRate
   before rounding. Both rates range from 0 to 1. */
SELECT 
    COUNT(*) AS RegCount,
    COUNT(Grade) AS GradedCount,
    ROUND( COUNT(Grade) / COUNT(*), 2 ) AS CompletionRate,
    ROUND( 1 - COUNT(Grade) / COUNT(*), 2 ) AS MissingRate
FROM Registration
WHERE OwnerID = 1234567;


/* Task 50: Calculate registration and grade-completion
   statistics for every student appearing in Registration.

   GROUP BY OwnerID creates one result per registered
   student. Students with no registrations do not appear
   because this query uses only the Registration table. */
SELECT 
    OwnerID,
    COUNT(*) AS RegCount,
    COUNT(Grade) AS GradedCount,
    ROUND( COUNT(Grade) / COUNT(*), 2 ) AS CompletionRate,
    ROUND( 1 - COUNT(Grade) / COUNT(*), 2 ) AS MissingRate
FROM Registration
GROUP BY OwnerID
ORDER BY OwnerID;


/* Task 51: Show only registered students whose grades
   have all been recorded.

   HAVING RegCount = GradedCount retains groups where
   every registration has a non-NULL Grade. MySQL allows
   SELECT aliases in HAVING. */
SELECT 
    OwnerID,
    COUNT(*) AS RegCount,
    COUNT(Grade) AS GradedCount,
    ROUND( COUNT(Grade) / COUNT(*), 2 ) AS CompletionRate,
    ROUND( 1 - COUNT(Grade) / COUNT(*), 2 ) AS MissingRate
FROM Registration
GROUP BY OwnerID
HAVING RegCount = GradedCount
ORDER BY OwnerID;


/* Task 52: List all courses.
   Return to the Course table before examining aggregate
   credit-hour statistics by department. */
SELECT * FROM Course;


/* Task 53: For each department ID, calculate the minimum,
   maximum, total, and average credit hours of its courses.

   Introduce MIN(), MAX(), SUM(), and AVG() together.
   GROUP BY DeptID returns one summary for each distinct
   department ID, including a NULL group if any courses
   have no assigned department. */

SELECT
    DeptID,
    MIN(CreditHours) AS MinHours,
    MAX(CreditHours) AS MaxHours,
    SUM(CreditHours) AS TotalHours,
    AVG(CreditHours) AS AverageHours
FROM Course
GROUP BY DeptID;


/* Task 54: Show department groups whose average course
   credit hours are at least 3.

   HAVING AVG(CreditHours) >= 3 filters the grouped results.
   Unlike WHERE, HAVING can test aggregate expressions. */
SELECT
    DeptID,
    MIN(CreditHours) AS MinHours,
    MAX(CreditHours) AS MaxHours,
    SUM(CreditHours) AS TotalHours,
    AVG(CreditHours) AS AverageHours
FROM Course
GROUP BY DeptID
HAVING AVG(CreditHours) >= 3;


/* Task 55: Extend Task 54 to include only departments
   offering at least five courses.

   Combine two aggregate conditions using AND in HAVING.
   Both the average-credit requirement and the minimum
   course-count requirement must be satisfied. */
SELECT
    DeptID,
    MIN(CreditHours) AS MinHours,
    MAX(CreditHours) AS MaxHours,
    SUM(CreditHours) AS TotalHours,
    AVG(CreditHours) AS AverageHours
FROM Course
GROUP BY DeptID
HAVING AVG(CreditHours) >= 3
    AND COUNT(*) >= 5;


/* Task 56: [CHALLENGE] Count letter grades awarded in
   each academic year, grouped by their leading letter.

   Begin with a query that counts all registrations per year.
   Then use conditional aggregation to count A, B, C, D,
   and F grades separately, including plus/minus variants.
   The intended presentation is by ascending SemesterYear;
   ORDER BY is not yet included in the provided queries. */
SELECT 
    SemesterYear,
    COUNT(*) AS RegCount
FROM Registration
GROUP BY SemesterYear;

/* [CONDITIONAL AGGREGATION EXAMPLE]
   In MySQL, a TRUE comparison evaluates numerically to 1
   and FALSE to 0, allowing SUM() to count matches.
   LIKE 'A%' also includes grades such as A-.
   For NULL grades, LIKE returns NULL; SUM() ignores NULL.
   If every grade in a year is NULL, the sum is NULL rather
   than zero. SUM(CASE WHEN ... THEN 1 ELSE 0 END) avoids
   this issue and is more portable across SQL systems. */
SELECT
    SemesterYear,
    SUM( Grade LIKE 'A%' ) AS AGradeCount,
    SUM( Grade LIKE 'B%' ) AS BGradeCount,
    SUM( Grade LIKE 'C%' ) AS CGradeCount,
    SUM( Grade LIKE 'D%' ) AS DGradeCount,
    SUM( Grade LIKE 'F%' ) AS FGradeCount
FROM Registration
GROUP BY SemesterYear;


/* Task 57: List all students and add a calculated
   CurrentStatus column containing Active or Inactive.

   Introduce MySQL's IF(condition, true_value, false_value)
   scalar function. The expression returns Active when
   IsActive = 1 and Inactive otherwise.
   The underlying IsActive column is not modified. */
SELECT
    *,
    IF( IsActive = 1, 'Active', 'Inactive' ) AS CurrentStatus
FROM Student;