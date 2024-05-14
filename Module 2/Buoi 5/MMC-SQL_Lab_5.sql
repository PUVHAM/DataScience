USE testing_system_db;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
DROP VIEW IF EXISTS vw_employees;
CREATE VIEW vw_employees AS
	SELECT 	AC.*, D.DepartmentName
    FROM 	`account` AS AC 
    INNER JOIN 
			department AS D
	ON 		AC.DepartmentID = D.DepartmentID
    WHERE 	DepartmentName = N'Sale';

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
DROP VIEW IF EXISTS vw_most_account;
	CREATE VIEW vw_most_account 	AS
	WITH		CTE_AccountCount 	AS (
		SELECT 	COUNT(GA1.AccountID) AS AccountCount 
		FROM 	groupaccount GA1
		GROUP BY 	
				GA1.AccountID
	)
	SELECT		A.AccountID, A.UserName, COUNT(GA.AccountID) AS `Count`
	FROM 		groupaccount GA
	INNER JOIN	`account` A
	ON 			GA.AccountID = A.AccountID
	GROUP BY		GA.AccountID
	HAVING		COUNT(GA.AccountID) = ( SELECT MAX(AccountCount) AS maxCount FROM CTE_AccountCount);

-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
DROP VIEW IF EXISTS vw_questions_long_content;
CREATE VIEW vw_questions_long_content AS
	SELECT 	*
	FROM 	question
	WHERE 	LENGTH(content) > 300;

DELETE FROM question
WHERE 		LENGTH(content) > 300;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
DROP VIEW IF EXISTS vw_most_employees_department;
CREATE VIEW vw_most_employees_department AS
	WITH		CTE_most_employees 	AS (
        SELECT 	COUNT(*) AS EmployeeCount
        FROM 	`account`
        GROUP BY 
				departmentID
	)
	SELECT 		DepartmentName, COUNT(*) AS TotalEmployees
    FROM		department D
    INNER JOIN	`account` AC
	ON 			D.departmentID = AC.departmentID
    GROUP BY 	D.DepartmentName
    HAVING 		COUNT(*) = (SELECT MAX(EmployeeCount)
							FROM (	SELECT 	COUNT(*) AS EmployeeCount
									FROM	CTE_most_employees
							) AS DepartmentEmployeeCount
);

-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo       
DROP VIEW IF EXISTS vw_total_questions_create;
CREATE VIEW vw_total_questions_create AS
	SELECT		Q.content, AC.FullName
    FROM		`account` AC
    INNER JOIN 	question Q
    ON 			AC.AccountID = Q.CreatorID
    WHERE		AC.FullName LIKE N'Nguyễn%' OR 
				AC.FullName LIKE 'Nguyen%';
   
            