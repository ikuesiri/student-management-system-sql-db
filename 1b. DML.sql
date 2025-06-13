-- 1b. SQL queries for reports (DML)
use SMS_DB;

-- Insightful Reporting Questions 
-- -------------------------------------------------------------------------------

--1. Student & Enrollment Reports

--i.] How many students are currently enrolled in each course?


/* requirements:
'How many students' -- student count
    'each course' -- group by course

	[LEFT JOIN:  courses --->enrollments to output all courses]
*/


SELECT 
	c_o.CourseID, 
	c_o.CourseName,
	COUNT(e_r.StudentID) AS no_of_students
FROM courses AS c_o
LEFT JOIN enrollments AS e_r
	ON  c_o.CourseID = e_r.CourseID
GROUP BY
	c_o.CourseID, 
	c_o.CourseName
ORDER BY COUNT(e_r.StudentID) DESC;




-- ii.] Which students are enrolled in multiple courses, and which courses are they taking?

/* requirements:
		'which students...'  -- (i.e students name, studentID) therefore 'student' table
		'...enrolled in multiple courses' count courses-- (i.e > 1 courses)  'enrollment table
		'which courses...' -- (courses name, therefore 'courses' table
*/

WITH studentMultiCourses AS (
-- Which students enrolled in more than 1 course
    SELECT StudentID, COUNT(CourseID) AS no_of_courses
	FROM enrollments
	GROUP BY StudentID
	HAVING COUNT(DISTINCT CourseID) > 1
)
 -- JOIN students, and course table to get students id & name, and course names respectively. [ students --> enrollments <--- courses]
SELECT 
	s_t.StudentID,
	s_t.Name,
	c_o.CourseName
FROM students AS s_t
JOIN enrollments AS e_r  
	ON s_t.StudentID = e_r.StudentID
JOIN courses c_o
	ON e_r.CourseID = c_o.CourseID
-- this will filter the enties to only those that enroled for 2 or more course
WHERE s_t.StudentID IN ( SELECT StudentID FROM studentMultiCourses);



-- iii.] What is the total number of students per department across all courses?

/* requirements:
		'...total number of student' --> count ('students' table)
		'..per department  --> level 1 group: group by 'department ('department' table)
		'..all courses' ---> level 2 group: group by 'courses('courses' table)
*/


-- [join/ left join :  departments --> courses --> enrollments --> students]
-- nb: preserves dept. and courses with 0 students

SELECT 
	d_p.DepartmentID,
	d_p.DepartmentName,
	c_o.CourseID,
	c_o.CourseName,
	COUNT(DISTINCT s_t.StudentID) AS no_of_student  --handles duplicate errors
FROM departments AS d_p
JOIN courses AS c_o 
	ON d_p.DepartmentID = c_o.DepartmentID
LEFT JOIN enrollments AS e_n                        -- preserves department & courses with 0 enrollment
	ON c_o.CourseID = e_n.CourseID
LEFT JOIN students AS s_t			                -- handles errors, or NULL entry
	ON e_n.StudentID = s_t.StudentID       
GROUP BY
	d_p.DepartmentID,
	d_p.DepartmentName,
	c_o.CourseID,
	c_o.CourseName
ORDER BY
	no_of_student DESC ;
	
	
-- --------------------------------------------------------------------

--2. Course & Instructor Analysis

-- i.]  Which courses have the highest number of enrollments?


/* requirements:
   'Which courses...'  (course name ) 'courses' table
   'highest number of enrollments... --> therefore 'enrollment' table [NB: Ensure code handles cases of a joint highest)
   extra: students register for courses, since its just highest ('counting'), 'student id' is enough, no need for 'student name.

   [left join: courses --> enrollments ] 
*/

WITH topEnrolledCourses AS (
SELECT 
	-- rank course from the highest count of enrollment
	c_o.CourseID,
	c_o.CourseName,
	COUNT(e_r.StudentID) as enrollment_count,
	DENSE_RANK() OVER(ORDER BY COUNT(e_r.StudentID) DESC) AS ranking
FROM courses AS c_o
LEFT JOIN enrollments AS e_r
	ON c_o.CourseID = e_r.CourseID
GROUP BY
	c_o.CourseID,
	c_o.CourseName
)
	SELECT CourseID, CourseName, enrollment_count
	FROM topEnrolledCourses
	WHERE ranking = 1
;

-- ii.] Which department has the least number of students?

/* requirements:
    'Which department...' --> 'department' table for dept. name
	'least number of students.. ---> count, 'students' table [NB: Handle scenario with a joint least]

	[LEFT JOIN: department --> students] to preserve 0 student departments]


*/


WITH leastRankedDept AS (
SELECT 
	d_p.DepartmentID,
	d_p.DepartmentName,
	COUNT(s_t.StudentID) AS no_of_students,
	DENSE_RANK() OVER(ORDER BY COUNT(s_t.StudentID) ASC) as ranking
FROM
	departments AS d_p
LEFT JOIN students AS s_t      -- presevers dept. with 0 students
	ON d_p.DepartmentID = s_t.DepartmentID
GROUP BY
	d_p.DepartmentID,
	d_p.DepartmentName
)
SELECT 
	DepartmentID,
	DepartmentName
FROM
	leastRankedDept
WHERE ranking = 1;



-- ---------------------------------------------------------

-- 3.] Data Integrity & Operational Insights

-- i.]  Are there any students not enrolled in any course?

/* requirements: 
  'Are there any students...' (student name needed) therefore 'students' table
  'not enrolled..'    'enrollment' table needed.
  'in any course'  'course table' not really needed, as we only students with no course enrolled in

   [LEFT JOIN: students --> enrollment; to include student with no course enrollements]

*/


SELECT
	s_t.StudentID,
    s_t.Name AS [Student Name]

FROM students AS s_t 
LEFT JOIN enrollments AS e_r
	ON s_t.StudentID = e_r.StudentID
WHERE e_r.enrollmentID IS NULL;

-- output here will be a list of the id and names of students not enrolled to any course.
-- A blank output indicates that all the students have been enrolled to atleast 1 course.


-- ii.] How many courses does each student take on average?


/* requirements:
	'How many courses...'  course aggregations (count and average) can be handled from 'enrolled' table,
	'each student' -->  students table needed
	[left join students ---> enrolment including students with 0 enrol courses, to make the code accurate enough]
*/

-- step 1: count number of courses enrolled by each student
-- step 2: take the overall average (mean)

WITH courseCount AS (
 -- stp-1
 SELECT
	s_t.StudentID,
	COUNT(DISTINCT e_n.CourseID) AS no_of_courses
FROM students AS s_t
LEFT JOIN enrollments AS e_n
	ON s_t.StudentID = e_n.StudentID
GROUP BY
	s_t.StudentID
)

 -- stp-2
 SELECT 
	ROUND(AVG(no_of_courses), 2)  AS no_of_courses_per_student  -- 2 d.p
 FROM courseCount;


-- iii.] What is the gender distribution of students across courses and instructors?

/* requirements:
		'...gender distribution...'  'students' table needed
		'...across courses [course table] 
		'...and instructors'   ['instructor' table needed]

		other tables needed: 
		-- the enrollment table as a junction table to connect students & courses table
		-- the 'course_instructors' table as a junction table to connect courses & instructors table

		[JOINS:  students --> enrollments <--- courses---> course_instructors <--- instructors]

*/

-- step 1:join the tables and group by courses info, instructors infos , and then, gender infos

WITH courseInstructorInfo AS (
	SELECT 
		c_o.CourseID, c_o.CourseName,
		i_n.InstructorID, i_n.InstructorName,
		s_t.Gender,
		COUNT(*) As student_count

	FROM students AS s_t                   -- table 1
	JOIN enrollments AS e_n                -- table 2
		ON s_t.StudentID = e_n.StudentID 
		
	JOIN courses AS c_o					   -- table 3
		ON e_n.CourseID = c_o.CourseID

	JOIN course_instructors AS c_i         -- table 4
		ON c_o.CourseID = c_i.CourseID

	JOIN instructors AS i_n
		on c_i.InstructorID = i_n.InstructorID  --- table 5

)
--distribution

SELECT 
	CourseName,
	InstructorName,
	SUM(CASE when Gender = 'Male' THEN student_count ELSE 0 END) AS [Male Students],
	SUM(CASE WHEN Gender = 'Female' THEN student_count	ELSE 0 END) AS [Fmalale Students],
	SUM(CASE WHEN Gender = 'Other' THEN student_count ELSE 0 END) AS [Others],
	SUM(student_count) AS Total_no_of_Students
FROM courseInstructorInfo
;	



-- Which course has the highest number of male or female students enrolled?

/* requirements:

  'Which course' --> 'courses' table needed
  'male or female students..' for gender 'students' table needed
  and 'enrollments to connect both tables

     [JOIN:  students ---> enrollments <-- courses]

	 [Structure: CourseName  | Gender | Students_count]

*/

WITH genderCount AS (
	SELECT
		c_o.CourseID,
		c_o.CourseName,
		s_t.Gender,
		COUNT(*) AS enrollment_count,
		DENSE_RANK() OVER(PARTITION BY c_o.CourseID, c_o.CourseName, s_t.Gender ORDER BY COUNT(*) DESC) AS rank_by_gender
	FROM students s_t
	JOIN enrollments AS e_r
		ON  s_t.StudentID = e_r.StudentID
	JOIN courses AS c_o
		ON	e_r.CourseID =  c_o.CourseID
	WHERE GENDER IN ('Male', 'Female') -- to exclude 'other'
	GROUP BY
		c_o.CourseID,
		c_o.CourseName,
		s_t.Gender
)

SELECT
	CourseName,
	Gender,
	enrollment_count
FROM genderCount
WHERE rank_by_gender = 1

;


-------END