CREATE DATABASE Testing_System_Db;
USE Testing_System_Db;

CREATE TABLE Department (
	DepartmentID			INT,
    DepartmentName			VARCHAR(50)
);

CREATE TABLE  `Position` (
	PositionID				INT,
    PositionName			VARCHAR(50)
);

CREATE TABLE  `Account` (
	AccountID				INT,
    Email					VARCHAR(100),
	Username				VARCHAR(50),
	FullName				VARCHAR(100),
	DepartmentID			INT,
    PositionID				INT,
    CreateDate				Date
);

CREATE TABLE  `GroupAccount` (
	GroupID					INT,
    AccountID				INT,
    JoinDate				Date
);

CREATE TABLE TypeQuestion (
	TypeID					INT,
    TypeName				VARCHAR(50)
);

CREATE TABLE CategoryQuestion (
	CategoryID				INT,
    CategoryName			VARCHAR(50)
);

CREATE TABLE  Question (
	QuestionID				INT,
    Content					VARCHAR(100),
	CategoryID				INT,
    TypeID					INT,
    CreatorID				INT,
    CreateDate				Date
);

CREATE TABLE  Answer (
	AnswerID				INT,
    Content					VARCHAR(200),
	QuestionID				INT,
    isCorrert				BOOLEAN
);

CREATE TABLE Exam (
    ExamID              	INT,
    `Code`                	VARCHAR(50),
    Title               	VARCHAR(50),
    CategoryID          	INT,
    Duration            	TIME,
    CreatorID           	INT,
    CreateDate          	DATE
);

CREATE TABLE ExamQuestion (
	ExamID					INT,
    QuestionID				INT
);








