USE testing_system_db;

-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
DROP PROCEDURE IF EXISTS sp_GetAccFromDep;
DELIMITER $$
CREATE PROCEDURE sp_GetAccFromDep(IN in_dep_name NVARCHAR(50))
BEGIN
	SELECT		*
	FROM 		`account` A 
	INNER JOIN	Department D
	ON			A.DepartmentId = D.DepartmentId
	WHERE		DepartmentName = in_dep_name;
END$$
DELIMITER ;

CALL sp_GetAccFromDep(N'Lễ tân');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS sp_AccFromGroup;
DELIMITER $$
CREATE PROCEDURE sp_AccFromGroup(IN in_accountfromgroup NVARCHAR(50))
	BEGIN
		SELECT 	G.GroupID, G.GroupName, COUNT(*) AS AccountCount 
		FROM 	`group` G
		INNER JOIN 
				groupaccount GA
		ON 		G.GroupID = GA.GroupID
		WHERE 	G.GroupName = in_accountfromgroup
		GROUP BY 
				G.GroupID, G.GroupName;
    END$$
DELIMITER ;

CALL sp_AccFromGroup(N'Nhóm dẫn đầu');

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS sp_QuesInMonth;
DELIMITER $$
CREATE PROCEDURE sp_QuesInMonth (IN in_type_ques VARCHAR(30))
	BEGIN
		SELECT	TQ.TypeName, COUNT(*) AS COUNTQUESTION
		FROM	typequestion TQ
		INNER JOIN 
				question Q
		ON 		TQ.TypeID = Q.TypeID
        WHERE 	TQ.TypeName = in_type_ques AND
				EXTRACT(MONTH FROM Q.CreateDate) = EXTRACT(MONTH FROM CURRENT_DATE)
		GROUP BY 
				TQ.TypeName;
    END$$
DELIMITER ;

CALL sp_QuesInMonth(N'Essay');
	
-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS sp_MaxTypeID;
DELIMITER $$
CREATE PROCEDURE sp_MaxTypeID (OUT out_MaxTypeID INT)
	BEGIN
		WITH CTE_CountTypeID AS(
			SELECT 	COUNT(Q.TypeID) AS CountTypeID
			FROM	question Q
			GROUP BY
					Q.TypeID
		)
		SELECT	Q.TypeID INTO out_MaxTypeID
		FROM 	question Q
		GROUP BY
				Q.TypeID
		HAVING 	COUNT(Q.TypeID) = (	SELECT 	MAX(CountTypeID) 
									FROM	CTE_CountTypeID);
    END$$
DELIMITER ;

SET 	@ID = 0;
CALL	sp_MaxTypeID(@ID);
SELECT	@ID;

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
DROP PROCEDURE IF EXISTS sp_TypeNameOfMaxTypeID;
DELIMITER $$
CREATE PROCEDURE sp_TypeNameOfMaxTypeID (OUT out_TypeName VARCHAR(255))
	BEGIN
		DECLARE maxTypeID INT;
		CALL 	sp_MaxTypeID(maxTypeID);
		SELECT 	TQ.TypeName INTO out_TypeName
		FROM 	typequestion TQ
		WHERE 	TQ.TypeID = maxTypeID;
	END$$
DELIMITER ;
SET 	@TypeName = '';
CALL	sp_TypeNameOfMaxTypeID(@TypeName);
SELECT	@TypeName;

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào
DROP PROCEDURE IF EXISTS sp_SearchGroupAndUser;
DELIMITER $$
CREATE PROCEDURE sp_SearchGroupAndUser (IN in_searchString VARCHAR(255))
BEGIN
	SELECT 	GroupName 
	FROM	`group`
	WHERE 	GroupName LIKE CONCAT('%', in_searchString, '%')
	UNION
	SELECT 	Username 
	FROM	`account`
	WHERE 	Username LIKE CONCAT('%', in_searchString, '%');
END $$
DELIMITER ;

CALL sp_SearchGroupAndUser(N'bứt');

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công
DROP PROCEDURE IF EXISTS sp_InputUser;
DELIMITER $$
CREATE PROCEDURE sp_InputUser (IN in_email VARCHAR(50), IN in_fullname NVARCHAR(50))
BEGIN
	DECLARE 	in_username	VARCHAR(50);
	DECLARE 	default_positionID TINYINT DEFAULT 1;
	DECLARE		default_departmentID TINYINT DEFAULT 11;

	SET in_username = SUBSTRING_INDEX(in_email, '@', 1);
	
    INSERT INTO `account` 	(Email		, FullName		, Username		, DepartmentID			, PositionID		)
    VALUES 					(in_email	, in_fullname	, in_username	, default_departmentID	, default_positionID);
END $$
DELIMITER ;

CALL sp_InputUser('traisaigon102@gmail.com','Thanh Duy');

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để
-- thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DROP FUNCTION IF EXISTS fn_LongestContentQuestion;
DELIMITER $$

CREATE FUNCTION fn_LongestContentQuestion (
    in_TypeName VARCHAR(50)
)
RETURNS TEXT
DETERMINISTIC
	BEGIN
		DECLARE out_LongestContent TEXT;
		
		SELECT 	Q.Content INTO out_LongestContent
		FROM 	question Q
		INNER JOIN
				typequestion TQ
		ON		Q.TypeID = TQ.TypeID
		WHERE	TypeName = in_TypeName
		ORDER BY	
				LENGTH(Content) DESC
		LIMIT 1;
		
		RETURN out_LongestContent;
	END $$
DELIMITER ;

SELECT fn_LongestContentQuestion('Essay');


-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DROP PROCEDURE IF EXISTS sp_DelExam;
DELIMITER $$
CREATE PROCEDURE sp_DelExam (IN in_examID INT)
BEGIN
	DELETE FROM exam
    WHERE		ExamID = in_examID;
END $$
DELIMITER ;

CALL sp_DelExam(10);

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng
-- store ở câu 9 để xóa) Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
DROP FUNCTION IF EXISTS fn_DeleteExamsCreatedBefore;
DELIMITER $$

CREATE FUNCTION fn_DeleteExamsCreatedBefore()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_3YearsAgo DATETIME;

    SET v_3YearsAgo = DATE_SUB(NOW(), INTERVAL 3 YEAR);

     DELETE FROM exam WHERE CreateDate <= v_3YearsAgo;

    -- Trả về số lượng bản ghi đã bị xóa
    RETURN ROW_COUNT();
END$$

DELIMITER ;

SELECT fn_DeleteExamsCreatedBefore();

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập
-- vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng ban
-- default là phòng ban chờ việc
DROP PROCEDURE IF EXISTS sp_DelDepartment;
DELIMITER $$
CREATE PROCEDURE sp_DelDepartment (IN in_DepartmentName NVARCHAR(50))
BEGIN
	DECLARE v_defaultDepartmentID INT;
    DECLARE v_departmentID INT;
    
    SELECT 	DepartmentID INTO v_defaultDepartmentID
    FROM 	department
    WHERE 	DepartmentName = N'Chờ việc';

    SELECT 	DepartmentID INTO v_departmentID
    FROM 	department
    WHERE 	DepartmentName = in_departmentName;

    IF 	v_departmentID IS NOT NULL THEN
        UPDATE `account`
        SET DepartmentID = v_defaultDepartmentID
        WHERE DepartmentID = v_departmentID;

		DELETE FROM department
		WHERE DepartmentID = v_departmentID;

		SELECT CONCAT('Đã xóa phòng ban ', in_departmentName) AS Message;	
	END IF;
END $$
DELIMITER ;

CALL sp_DelDepartment(N'Kinh doanh');


-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
DROP PROCEDURE IF EXISTS sp_QuesCreateInMonth;
DELIMITER $$
CREATE PROCEDURE sp_QuesCreateInMonth ()
BEGIN
	SELECT	MONTH(CreateDate) AS `Month`, COUNT(*) AS QuestionCount
	FROM	question
	WHERE 	YEAR(CreateDate) = YEAR(NOW())
	GROUP BY
			MONTH(CreateDate);
END $$
DELIMITER ;

CALL sp_QuesCreateInMonth();

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng
-- gần đây nhất (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")
DROP PROCEDURE IF EXISTS sp_QuestionsLast6Months;
DELIMITER $$

CREATE PROCEDURE sp_QuestionsLast6Months()
BEGIN
    SELECT 
        MONTH(CreateDate) AS Month,
        COUNT(*) AS QuestionCount
    FROM 
        question
    WHERE 
        CreateDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) AND CreateDate <= CURDATE()
    GROUP BY 
        MONTH(CreateDate)
    ORDER BY 
        MONTH(CreateDate) DESC;
END$$

DELIMITER ;
CALL sp_QuestionsLast6Months();








































