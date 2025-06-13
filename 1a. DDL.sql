-- 1a.  SQL scripts for database creation (DDL)

-- Create database and select the database to create the tables in
USE SMS_DB;

-- Auto-generate statements to create table from the SMS design on 'https://dbdiagram.io/'

CREATE TABLE [students] (
  [StudentID] integer PRIMARY KEY NOT NULL IDENTITY,
  [Name] varchar(20) NOT NULL,
  [Gender] nvarchar(255) NOT NULL CHECK ([Gender] IN ('Male', 'Female', 'Other')),
  [DOB] date,
  [DepartmentID] integer
)
GO

CREATE TABLE [departments] (
  [DepartmentID] integer PRIMARY KEY NOT NULL IDENTITY,
  [DepartmentName] varchar(20) NOT NULL
)
GO

CREATE TABLE [courses] (
  [CourseID] integer PRIMARY KEY NOT NULL IDENTITY,
  [CourseName] varchar(30) NOT NULL,
  [DepartmentID] integer
)
GO

CREATE TABLE [enrollments] (
  [EnrolmentID] integer PRIMARY KEY NOT NULL IDENTITY,
  [CourseID] integer,
  [StudentID] integer,
  [EnrollmentDate] date
)
GO

CREATE TABLE [instructors] (
  [InstructorID] integer PRIMARY KEY NOT NULL IDENTITY,
  [InstructorName] varchar(50) NOT NULL,
  [DepartmentID] integer
)
GO

--NB: Course and instructors have a many-to-many relations. So, A 'junction' table was created to handle that

CREATE TABLE [course_instructors] (
  [InstructorID] integer,
  [CourseID] integer,
  Primary Key (InstructorID,CourseID)
)
GO


-- This section adds to the TABLE the foreign keys that activates the relationship between the tables.

ALTER TABLE [students] 
ADD FOREIGN KEY ([DepartmentID]) REFERENCES [departments] ([DepartmentID])
GO

ALTER TABLE [courses] ADD FOREIGN KEY ([DepartmentID]) REFERENCES [departments] ([DepartmentID])
GO


ALTER TABLE [enrollments] ADD FOREIGN KEY ([StudentID]) REFERENCES [students] ([StudentID])
GO

ALTER TABLE [enrollments] ADD FOREIGN KEY ([CourseID]) REFERENCES [courses] ([CourseID])
GO

ALTER TABLE [instructors] ADD FOREIGN KEY ([DepartmentID]) REFERENCES [departments] ([DepartmentID])
GO

ALTER TABLE [course_instructors] ADD FOREIGN KEY ([InstructorID]) REFERENCES [instructors] ([InstructorID])
GO

ALTER TABLE [course_instructors] ADD FOREIGN KEY ([CourseID]) REFERENCES [courses] ([CourseID])
GO
