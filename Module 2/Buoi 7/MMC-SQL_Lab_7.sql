USE testing_system_db;

-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước

DROP TRIGGER IF EXISTS Trg_CheckInsertGrp;

DELIMITER $$
CREATE TRIGGER Trg_CheckInsertGrp
BEFORE INSERT ON `group`
FOR EACH ROW
BEGIN
	DECLARE v_CreateDate DATETIME;
    SET	v_CreateDate = DATE_SUB(NOW(), interval 1 year);
    
    IF(NEW.CreateDate <= v_CreateDate) THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not create this group';
	END IF;
END$$
DELIMITER ;

SHOW TRIGGERS;

INSERT INTO `Group`	(  GroupName			, CreatorID		, CreateDate)
VALUES             	(N'Nhóm Dẫn đầu'		, 1				,'2013-03-24');

-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
-- department "Sale" nữa, khi thêm thì hiện ra thông báo "Department "Sale" cannot add more user"

DROP TRIGGER IF EXISTS Trg_NotAddUserToSale;
DELIMITER $$
CREATE TRIGGER Trg_NotAddUserToSale
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
	DECLARE v_DepID INT;
    SELECT D.DepartmentID INTO v_DepID
    FROM 	Department D
    WHERE	D.DepartmentName = 'Sale';
    
    IF (NEW.DepartmentID = v_DepID) THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
	END IF;
END$$
DELIMITER ;

SHOW TRIGGERS;

INSERT INTO `Account`(Email					, Username			, FullName				, DepartmentID	, PositionID, CreateDate)
VALUES 				('haidang4@gmail.com'	, 'dangblack23'		,'Nguyễn hải Đăng'		,   '4'			,   '2'		,'2020-03-05');


-- Question 12: Lấy ra thông tin exam trong đó:
-- ● Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- ● 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- ● Duration > 60 thì sẽ đổi thành giá trị "Long time"

SELECT 	E.ExamID, E.`Code`, E.Title, 	CASE
										WHEN	Duration <= 30 THEN 'Short time'
										WHEN 	Duration <= 60 THEN 'Medium time'
										ELSE	'Long time'
										END AS 	Duration, CreateDate, E.Duration
FROM 	EXAM E;

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER IF EXISTS Trg_Most5UsersInGroup;
DELIMITER $$

CREATE TRIGGER Trg_Most5UsersInGroup
BEFORE INSERT ON `groupaccount`
FOR EACH ROW
BEGIN
	DECLARE UserCount INT;
    
    SELECT 	COUNT(*) INTO UserCount
    FROM 	`groupaccount`
    WHERE 	GroupID = NEW.GroupID;
    
	IF 	UserCount >= 5 THEN
        SIGNAL SQLSTATE '54321'
        SET MESSAGE_TEXT = 'A group can have at most 5 users.';
    END IF;
END $$
DELIMITER ;

SHOW TRIGGERS;

INSERT INTO `GroupAccount`	(  GroupID	, AccountID	, JoinDate	 )
VALUES 						(	1		,    11		,'2019-03-05');

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DROP TRIGGER IF EXISTS Trg_Most10QuesInExam;
DELIMITER $$

CREATE TRIGGER Trg_Most10QuesInExam
BEFORE INSERT ON examquestion
FOR EACH ROW
BEGIN
    DECLARE QuestionCount INT;

    SELECT 	COUNT(*) INTO QuestionCount
    FROM 	examquestion
    WHERE 	ExamID = NEW.ExamID;

    IF question_count >= 10 THEN
        SIGNAL SQLSTATE '54321'
        SET MESSAGE_TEXT = 'An exam can have at most 10 questions.';
    END IF;
END$$

DELIMITER ;

SHOW TRIGGERS;

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), còn lại các tài
-- khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó.
DROP TRIGGER IF EXISTS Trg_DelUser;
DELIMITER $$

CREATE TRIGGER Trg_DelUser
BEFORE DELETE ON `account`
FOR EACH ROW
BEGIN
	IF OLD.Email = 'admin@gmail.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete admin account.';
    END IF;
END$$
DELIMITER ;


DELETE 
FROM 	`account`
WHERE 	Email = 'admin@gmail.com';



-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account,
-- hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID thì
-- sẽ được phân vào phòng ban "waiting Department".
DROP TRIGGER IF EXISTS Trg_DepIDNull;
DELIMITER $$

CREATE TRIGGER Trg_DepIDNull
BEFORE INSERT ON `account`
FOR EACH ROW
BEGIN
	DECLARE v_waitingDeptID INT;

    SELECT 	DepartmentID INTO v_waitingDeptID
    FROM 	Department
    WHERE 	DepartmentName = N'Chờ việc';
    
	IF NEW.DepartmentID IS NULL THEN
		SET NEW.DepartmentID = v_waitingDeptID;
	END IF;
END$$
DELIMITER ;

SHOW TRIGGERS;
INSERT INTO Account (Email, Username, FullName, DepartmentID, PositionID, CreateDate)
VALUES
    ('bavangngoc@gmail.com'			, 'bavangngoc'		, 'Ba Vàng Ngọc'			,		NULL		, '3'			, '2023-03-05')

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question,
-- trong đó có tối đa 2 đáp án đúng.
DROP TRIGGER IF EXISTS Trg_AnsInQues;
DELIMITER $$

CREATE TRIGGER Trg_AnsInQues
BEFORE INSERT ON answer
FOR EACH ROW
BEGIN
	DECLARE AnswerCount INT;
    DECLARE CorrectCount INT;

    SELECT 	COUNT(*) INTO AnswerCount
    FROM 	answer
    WHERE 	QuestionID = NEW.QuestionID;
    
    SELECT 	COUNT(*) INTO CorrectCount
    FROM 	answer
    WHERE 	QuestionID = NEW.QuestionID AND
			isCorrect = 1;
            
	IF AnswerCount >= 4 THEN
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'A question can have at most 4 answers.';
    END IF;

    IF CorrectCount >= 2 AND NEW.isCorrect = 1 THEN
        SIGNAL SQLSTATE '54321'
        SET MESSAGE_TEXT = 'A question can have at most 2 correct answers.';
    END IF;
END$$
DELIMITER ;

SHOW TRIGGERS;

INSERT INTO Answer	(  Content		, QuestionID	, isCorrect	)
VALUES 				(N'Trả lời 11'	,   1			,	1		);

-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- ● Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- ● Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database

ALTER TABLE `account`
MODIFY COLUMN Gender NVARCHAR(20);

DROP TRIGGER IF EXISTS Trg_FixGenderInsert;
DELIMITER $$

CREATE TRIGGER Trg_FixGenderInsert
BEFORE INSERT ON `account`
FOR EACH ROW
BEGIN
    IF NEW.Gender = N'nam' THEN
        SET NEW.Gender = 'M';
    ELSEIF NEW.Gender = N'nữ' THEN
        SET NEW.Gender = 'F';
    ELSEIF NEW.Gender = N'chưa xác định' THEN
        SET NEW.Gender = 'U';
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS Trg_FixGenderUpdate;
DELIMITER $$

CREATE TRIGGER Trg_FixGenderUpdate
BEFORE UPDATE ON `account`
FOR EACH ROW
BEGIN
    IF NEW.Gender = N'nam' THEN
        SET NEW.Gender = 'M';
    ELSEIF NEW.Gender = N'nữ' THEN
        SET NEW.Gender = 'F';
    ELSEIF NEW.Gender = N'chưa xác định' THEN
        SET NEW.Gender = 'U';
    END IF;
END$$
DELIMITER ;

SHOW TRIGGERS;

UPDATE `account`
SET Gender = N'chưa xác định' 
WHERE AccountID = 13;

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS Trg_DelExam;
DELIMITER $$

CREATE TRIGGER Trg_DelExam
BEFORE DELETE ON exam
FOR EACH ROW
BEGIN
	IF OLD.CreateDate >= DATE_SUB(NOW(), INTERVAL 2 DAY) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete a newly created exam within 2 days.';
    END IF;
END$$
DELIMITER ;


-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các question
-- khi question đó chưa nằm trong exam nào
DROP TRIGGER IF EXISTS Trg_PreventQuestionUpdate;
DROP TRIGGER IF EXISTS Trg_PreventQuestionDelete;
DELIMITER $$

CREATE TRIGGER Trg_PreventQuestionDelete
BEFORE DELETE ON question
FOR EACH ROW
BEGIN
    DECLARE ExamCount INT;
    SELECT 	COUNT(*) INTO ExamCount
    FROM 	ExamQuestion
    WHERE 	QuestionID = OLD.QuestionID;

    IF ExamCount > 0 THEN
        SIGNAL SQLSTATE '41241'
        SET MESSAGE_TEXT = 'Cannot delete this question as it is associated with one or more exams.';
    END IF;
END$$

CREATE TRIGGER Trg_PreventQuestionUpdate
BEFORE UPDATE ON question
FOR EACH ROW
BEGIN
    DECLARE ExamCount INT;
    SELECT 	COUNT(*) INTO ExamCount
    FROM 	ExamQuestion
    WHERE 	QuestionID = OLD.QuestionID;

    IF ExamCount > 0 THEN
        SIGNAL SQLSTATE '41341'
        SET MESSAGE_TEXT = 'Cannot update this question as it is associated with one or more exams.';
    END IF;
END$$
DELIMITER ;

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên là
-- the_number_user_amount và mang giá trị được quy định như sau:
-- ● Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- ● Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- ● Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher

SELECT 	GA.GroupID, G.GroupName, COUNT(*) AS UserCount, CASE
														WHEN	COUNT(*) <= 5 		THEN 'few'
														WHEN 	COUNT(*) <= 20 	THEN 'normal'
														ELSE	'higher'
														END AS  the_number_user_amount
FROM 	`Groupaccount` GA 
INNER JOIN
		`Group` G
ON 		GA.GroupID = G.GroupID
GROUP BY
		GA.GroupID, G.GroupName;


-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
SELECT 
    D.DepartmentID,
    D.DepartmentName,
    COALESCE(COUNT(AC.AccountID), 'Không có User') AS UserCount
FROM 
    Department D
LEFT JOIN 
    `account` AC 
ON 	D.DepartmentID = AC.DepartmentID
GROUP BY 
    D.DepartmentID, D.DepartmentName;

