-- #######################################################################
-- Database Schema Creation Script for DataStax Internship System
-- #######################################################################
CREATE DATABASE DataStax;
USE DataStax;
-- ======================
-- Organization Table
-- ======================
CREATE TABLE Organization (
    org_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    approval_status VARCHAR(20) CHECK (approval_status IN ('approved', 'rejected', 'pending')),
    address VARCHAR(200),
    approved BOOLEAN,
    rejected BOOLEAN
);

-- ======================
-- Monitor Table
-- ======================
CREATE TABLE Monitor (
    monitor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_details VARCHAR(100)
);

-- ======================
-- Internship Table
-- ======================
CREATE TABLE Internship (
    internship_id INT PRIMARY KEY,
    org_id INT NOT NULL,
    monitor_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (org_id) REFERENCES Organization(org_id),
    FOREIGN KEY (monitor_id) REFERENCES Monitor(monitor_id),
    CONSTRAINT valid_dates CHECK (end_date > start_date)
);

-- ======================
-- Students Table
-- ======================
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    field_of_study VARCHAR(100),
    registration_status VARCHAR(20) CHECK (registration_status IN ('approved', 'rejected', 'pending')),
    internship_id INT,
    FOREIGN KEY (internship_id) REFERENCES Internship(internship_id)
);

-- ======================
-- Course Table
-- ======================
CREATE TABLE Course (
    course_code VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    room_no VARCHAR(20)
);

-- ======================
-- Enrollment Table
-- ======================
CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    since DATE NOT NULL,
    PRIMARY KEY (student_id, course_code),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_code) REFERENCES Course(course_code)
);


-- ======================
-- Evaluation Table (Combined for Professors and TAs)
-- ======================
CREATE TABLE Evaluation (
    evaluation_id INT PRIMARY KEY,
    grade VARCHAR(100),
    feedback TEXT,
    prof_id INT,
    assistant_id INT,
    student_id INT NOT NULL,
    FOREIGN KEY (prof_id) REFERENCES Professor(prof_id),
    FOREIGN KEY (assistant_id) REFERENCES Teaching_Assistant(assistant_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT evaluator_check CHECK (
        (prof_id IS NOT NULL AND assistant_id IS NULL) OR 
        (prof_id IS NULL AND assistant_id IS NOT NULL)
));

-- ======================
-- Report Table
-- ======================
CREATE TABLE Report (
    report_id INT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    submission_date DATE NOT NULL,
    evaluation_id INT NOT NULL,
    feedback TEXT,
    FOREIGN KEY (evaluation_id) REFERENCES Evaluation(evaluation_id)
);


CREATE TABLE Teach (
    ssn INT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (course_code) REFERENCES Course(course_code)
);
DROP TABLE Teach; 

CREATE TABLE Professor (
    professor_id INT PRIMARY KEY,
    ssn INT UNIQUE,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    FOREIGN KEY (ssn) REFERENCES Teach(ssn)
);

CREATE TABLE Teaching_Assistant (
    teachasist_id INT PRIMARY KEY,
    ssn INT UNIQUE,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (ssn) REFERENCES Teach(ssn)
);



-- #######################################################################
-- Sample Data Insertion Script
-- #######################################################################

-- Insert Organizations
INSERT INTO Organization VALUES 
(1, 'Tech Solutions Inc.', 'approved', '123 Tech Blvd, San Francisco', TRUE, FALSE),
(2, 'Data Analytics Co.', 'approved', '456 Data Street, Boston', TRUE, FALSE),
(3, 'Software Innovators', 'pending', '789 Innovation Ave, Austin', FALSE, FALSE),
(4, 'Cyber Security Partners', 'approved', '321 Secure Lane, Washington', TRUE, FALSE),
(5, 'AI Research Labs', 'rejected', '654 AI Road, Seattle', FALSE, TRUE),
(6, 'Cloud Services Ltd.', 'approved', '987 Cloud Way, New York', TRUE, FALSE);

-- Insert Monitors
INSERT INTO Monitor VALUES
(101, 'John Smith', 'john.smith@example.com'),
(102, 'Sarah Johnson', 'sarah.j@example.com'),
(103, 'Michael Brown', 'michael.b@example.com'),
(104, 'Emily Davis', 'emily.d@example.com'),
(105, 'Robert Wilson', 'robert.w@example.com'),
(106, 'Jennifer Lee', 'jennifer.l@example.com');

-- Insert Internships
INSERT INTO Internship VALUES
(1001, 1, 101, '2023-06-01', '2023-08-31'),
(1002, 2, 102, '2023-06-15', '2023-09-15'),
(1003, 4, 103, '2023-07-01', '2023-09-30'),
(1004, 1, 104, '2023-06-01', '2023-08-31'),
(1005, 6, 105, '2023-07-15', '2023-10-15'),
(1006, 2, 106, '2023-08-01', '2023-11-30');

-- Insert Students
INSERT INTO Students VALUES
(5001, 'Alice Johnson', 'Computer Science', 'approved', 1001),
(5002, 'Bob Smith', 'Data Science', 'approved', 1002),
(5003, 'Charlie Brown', 'Cybersecurity', 'approved', 1003),
(5004, 'Diana Miller', 'Computer Science', 'pending', NULL),
(5005, 'Ethan Wilson', 'Artificial Intelligence', 'approved', 1005),
(5006, 'Fiona Davis', 'Software Engineering', 'rejected', NULL);

-- Insert Courses
INSERT INTO Course VALUES
('CS101', 'Introduction to Programming', 'A100'),
('DS201', 'Data Structures', 'B205'),
('AI301', 'Artificial Intelligence', 'C310'),
('CS202', 'Database Systems', 'A210'),
('SE401', 'Software Engineering', 'D415'),
('CY501', 'Cybersecurity Fundamentals', 'E510');

-- Insert Enrollments
INSERT INTO Enrollment VALUES
(5001, 'CS101', '2023-01-15'),
(5001, 'DS201', '2023-01-15'),
(5002, 'DS201', '2023-01-20'),
(5002, 'AI301', '2023-01-20'),
(5003, 'CY501', '2023-02-01'),
(5004, 'CS101', '2023-02-10'),
(5005, 'AI301', '2023-02-15'),
(5005, 'SE401', '2023-02-15'),
(5006, 'CS202', '2023-03-01');


-- Insert Evaluations
INSERT INTO Evaluation VALUES
(7001, 'A', 'Excellent work on all assignments', 2001, NULL, 5001),
(7002, 'B+', 'Good performance with room for improvement', NULL, 3001, 5001),
(7003, 'A-', 'Strong technical skills', 2002, NULL, 5002),
(7004, 'B', 'Consistent performance', NULL, 3002, 5003),
(7005, 'A+', 'Outstanding research work', 2003, NULL, 5005),
(7006, 'C+', 'Needs to participate more', NULL, 3003, 5004);

-- Insert Reports
INSERT INTO Report VALUES
(8001, 'Midterm', '2023-04-15', 7001, 'Good progress overall'),
(8002, 'Final', '2023-06-20', 7001, 'Excellent final project'),
(8003, 'Midterm', '2023-04-18', 7003, 'Solid understanding of concepts'),
(8004, 'Final', '2023-06-22', 7004, 'Improved significantly'),
(8005, 'Midterm', '2023-04-20', 7005, 'Exceptional work'),
(8006, 'Final', '2023-06-25', 7006, 'Met minimum requirements');

INSERT INTO Professor VALUES
(2001, 123456789, 'Dr. James Wilson', 'Computer Science'),
(2002, 234567890, 'Dr. Lisa Thompson', 'Data Science'),
(2003, 345678901, 'Dr. Mark Roberts', 'AI'),
(2004, 456789012, 'Dr. Susan Chen', 'Software Eng.'),
(2005, 567890123, 'Dr. David Kim', 'Cybersecurity'),
(2006, 678901234, 'Dr. Patricia Moore', 'Computer Science');
INSERT INTO Teaching_Assistant VALUES
(3001, 123456789, 'Ryan Adams'),
(3002, 234567890, 'Olivia Martinez'),
(3003, 345678901, 'Daniel White'),
(3004, 456789012, 'Sophia Garcia'),
(3005, 567890123, 'Matthew Taylor'),
(3006, 678901234, 'Emma Anderson');
INSERT INTO Teach VALUES
(107777777, 'CS101', '2023-02-01'),
(108888888, 'DS201', '2023-02-05'),
(109999999, 'AI301', '2023-02-10'),
(110000000, 'CS101', '2023-02-15'),
(111111111, 'DS201', '2023-02-20');
-- #######################################################################
-- Verification Queries (SELECT * FROM each table)
-- #######################################################################

SELECT * FROM Organization;
SELECT * FROM Monitor;
SELECT * FROM Internship;
SELECT * FROM Students;
SELECT * FROM Course;
SELECT * FROM Enrollment;
SELECT * FROM Professor;
SELECT * FROM Teaching_Assistant;
SELECT * FROM Evaluation;
SELECT * FROM Report;
SELECT * FROM Teach;