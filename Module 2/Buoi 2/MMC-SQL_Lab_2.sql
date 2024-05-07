DROP DATABASE IF EXISTS TestingSystem;
CREATE DATABASE TestingSystem;
USE TestingSystem;

DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	DepartmentID 			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    DepartmentName 			NVARCHAR(30) NOT NULL UNIQUE KEY
);

DROP TABLE IF EXISTS Position;
CREATE TABLE `Position` (
	PositionID				TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    PositionName			ENUM('Dev','Test','Scrum Master','PM') NOT NULL UNIQUE KEY
);

DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account`(
	AccountID				TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Email					VARCHAR(50) NOT NULL UNIQUE KEY,
    Username				VARCHAR(50) NOT NULL UNIQUE KEY,
    FullName				NVARCHAR(50) NOT NULL,
    DepartmentID 			TINYINT UNSIGNED NOT NULL,
    PositionID				TINYINT UNSIGNED NOT NULL,
    CreateDate				DATETIME DEFAULT NOW(),
    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID),
    FOREIGN KEY (PositionID) REFERENCES `Position` (PositionID)
);

DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group`(
	GroupID					TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    GroupName				NVARCHAR(50) NOT NULL UNIQUE KEY,
    CreatorID				TINYINT UNSIGNED,
    CreateDate				DATETIME DEFAULT NOW(),
    FOREIGN KEY (CreatorID) 	REFERENCES `Account` (AccountId)
);

DROP TABLE IF EXISTS GroupAccount;
CREATE TABLE GroupAccount(
	GroupID					TINYINT UNSIGNED NOT NULL,
    AccountID				TINYINT UNSIGNED NOT NULL,
    JoinDate				DATETIME DEFAULT NOW(),
    PRIMARY KEY (GroupID, AccountID),
    FOREIGN KEY (GroupID) 		REFERENCES `Group` (GroupID) 
);

DROP TABLE IF EXISTS TypeQuestion;
CREATE TABLE TypeQuestion (
    TypeID 			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    TypeName 		ENUM('Essay','Multiple-Choice') NOT NULL
);

DROP TABLE IF EXISTS CategoryQuestion;
CREATE TABLE CategoryQuestion(
    CategoryID				TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    CategoryName			NVARCHAR(50) NOT NULL UNIQUE KEY
);

DROP TABLE IF EXISTS Question;
CREATE TABLE Question(
    QuestionID				TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Content					NVARCHAR(100) NOT NULL,
    CategoryID				TINYINT UNSIGNED NOT NULL,
    TypeID					TINYINT UNSIGNED NOT NULL,
    CreatorID				TINYINT UNSIGNED NOT NULL,
    CreateDate				DATETIME DEFAULT NOW(),
    FOREIGN KEY (CategoryID) 	REFERENCES CategoryQuestion (CategoryID),
    FOREIGN KEY (TypeID) 		REFERENCES TypeQuestion (TypeID),
    FOREIGN KEY (CreatorID) 	REFERENCES `Account` (AccountId) 
);

DROP TABLE IF EXISTS Answer;
CREATE TABLE Answer(
    AnswerID				TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Content					NVARCHAR(100) NOT NULL,
    QuestionID				TINYINT UNSIGNED NOT NULL,
    isCorrect				BIT DEFAULT 1,
    FOREIGN KEY (QuestionID) REFERENCES Question (QuestionID)
);

DROP TABLE IF EXISTS Exam;
CREATE TABLE Exam(
    ExamID					TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Code`					CHAR(10) NOT NULL,
    Title					NVARCHAR(50) NOT NULL,
    CategoryID				TINYINT UNSIGNED NOT NULL,
    Duration				TINYINT UNSIGNED NOT NULL,
    CreatorID				TINYINT UNSIGNED NOT NULL,
    CreateDate				DATETIME DEFAULT NOW(),
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion (CategoryID),
    FOREIGN KEY (CreatorID) 	REFERENCES `Account` (AccountId)
);

DROP TABLE IF EXISTS ExamQuestion;
CREATE TABLE ExamQuestion(
    ExamID				TINYINT UNSIGNED NOT NULL,
	QuestionID			TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (QuestionID) REFERENCES Question (QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exam (ExamID),
    PRIMARY KEY (ExamID, QuestionID)
);

INSERT INTO `Department`(`DepartmentName`)
VALUES                  (N'Lễ tân'),
                        (N'Bảo vệ'),
                        (N'Kế toán'),
                        (N'Nhân sự'),
                        (N'Kinh doanh'),
                        (N'Kỹ thuật');

    
-- Add data position
INSERT INTO Position	(PositionName	) 
VALUES 					('Dev'			),
						('Test'			),
						('Scrum Master'	),
						('PM'			); 


-- Add data Account
INSERT INTO Account (Email, Username, FullName, DepartmentID, PositionID)
VALUES
    ('account01@gmail.com', 'account01', 'Trần Văn A', 1, 1),
    ('account02@gmail.com', 'account02', 'Nguyễn Thị B', 3, 2),
    ('account03@gmail.com', 'account03', 'Lê Văn C', 2, 3),
    ('account04@gmail.com', 'account04', 'Phạm Ti D', 3, 4),
    ('account05@gmail.com', 'account05', 'Tôn Hoàng E', 1, 1);

-- Add data Group
INSERT INTO `Group`(`GroupName`, `CreatorID`)
VALUES             ('Nhóm Dẫn đầu', 1),
                   ('Nhóm Bứt phá', 2),
                   ('Nhóm Bền bỉ', 3),
                   ('Nhóm Cẩn thận', 4),
                   ('Nhóm Tốc độ', 5);

INSERT INTO `GroupAccount`(`GroupID`, `AccountID`)
VALUES                    (1, 1),
                          (1, 3),
                          (2, 2),
                          (2, 5),
                          (4, 4),
                          (4, 1),
                          (3, 5);


INSERT INTO `TypeQuestion`(`TypeName`)
VALUES                    ('Essay'),
                          ('Essay'),
                          ('Essay'),
                          ('Essay');

INSERT INTO `CategoryQuestion`(`CategoryName`)
VALUES                        ('Kiến thức chung'),
                              ('Ngôn ngữ lập trình'),
                              ('CSDL'),
                              ('Thuật toán');

INSERT INTO `Question`(`Content`, `CategoryID`, `TypeID`, `CreatorID`)
VALUES                ('Câu hỏi số 1 là', 1, 1, 1),
                      ('Câu hỏi số 2 là', 3, 2, 2),
                      ('Câu hỏi số 3 là', 4, 3, 2),
                      ('Câu hỏi số 4 là', 2, 4, 1),
                      ('Câu hỏi số 5 là', 1, 2, 1),
                      ('Câu hỏi số 6 là', 4, 1, 1),
                      ('Câu hỏi số 7 là', 3, 4, 3),
                      ('Câu hỏi số 8 là', 2, 3, 4),
                      ('Câu hỏi số 9 là', 2, 1, 5),
                      ('Câu hỏi số 10 là', 1, 1, 2),
                      ('Câu hỏi số 11 là', 4, 2, 3),
                      ('Câu hỏi số 12 là', 3, 3, 1);

INSERT INTO `Answer`(`Content`, `QuestionID`)
VALUES              ('Đáp án 1 là', 1),
                    ('Đáp án 2 là', 2),
                    ('Đáp án 3 là', 3),
                    ('Đáp án 4 là', 4),
                    ('Đáp án 5 là', 5),
                    ('Đáp án 6 là', 6),
                    ('Đáp án 7 là', 7),
                    ('Đáp án 8 là', 8),
                    ('Đáp án 9 là', 9),
                    ('Đáp án 10 là', 10),
                    ('Đáp án 11 là', 11),
                    ('Đáp án 12 là', 12);

INSERT INTO `Exam`(`Code`, `Title`, `CategoryID`, `Duration`, `CreatorID`)
VALUES            ('E001', 'Entrance exam', 1, 60, 1),
                  ('E002', 'Short Entrance exam', 1, 30, 1),
                  ('E003', 'Evaluation exam', 2, 120, 2),
                  ('E004', 'Short Evaluation exam', 3, 90, 1),
                  ('E005', 'Regular exam', 4, 30, 1);

INSERT INTO `ExamQuestion`(`ExamID`, `QuestionID`)
VALUES                    (1, 4),
                          (2, 5),
                          (3, 7),
                          (4, 9),
                          (5, 1);