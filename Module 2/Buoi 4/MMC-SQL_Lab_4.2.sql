USE testing_system_db;

-- Exercise 1: Join
-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT	AC.FullName, D.DepartmentName
FROM	`account` AS AC
INNER JOIN 
		department AS D
ON 		AC.DepartmentID = D.DepartmentID;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT 	AC.AccountID, AC.FullName, GA.JoinDate
FROM	`account` AS AC
INNER JOIN 
		groupaccount AS GA
ON 		AC.AccountID = GA.AccountID
WHERE 	GA.JoinDate > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT 	AC.FullName, P.PositionName
FROM	`account` AS AC
INNER JOIN 
		`position` AS P
ON 		AC.PositionID = P.PositionID
WHERE 	P.PositionID = 1;

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT	D.DepartmentName, COUNT(*)
FROM	`account` AS AC
INNER JOIN 
		department AS D
ON		AC.DepartmentID = D.DepartmentID
GROUP BY 
		D.DepartmentName
HAVING	COUNT(*) > 3;



-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT 	Q.QuestionID, Q.content, COUNT(*) AS QuestionCount
FROM 	examquestion AS EQ
INNER JOIN 
		question AS Q 
ON 		EQ.QuestionID = Q.QuestionID
GROUP BY 
		Q.QuestionID, Q.content
HAVING 	COUNT(*) = (
		SELECT MAX(QuestionCount)
		FROM (
			SELECT COUNT(*) AS QuestionCount
			FROM examquestion
			GROUP BY QuestionID
		) AS MaxCounts
);

-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT 	Q.QuestionID, Q.content, COUNT(*) AS QuestionCount
FROM 	categoryquestion AS CQ
INNER JOIN 
		question AS Q 
ON 		CQ.CategoryID = Q.CategoryID
GROUP BY 
		Q.QuestionID, Q.content;
        
-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT 	Q.QuestionID, Q.content, COUNT(*) AS QuestionCount
FROM 	exam AS E
INNER JOIN 
		question AS Q 
ON 		E.CategoryID = Q.CategoryID
GROUP BY 
		Q.QuestionID, Q.content;


-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT 	Q.QuestionID, Q.content, COUNT(*) AS AnswerCount
FROM 	answer AS ANS
INNER JOIN 
		question AS Q 
ON 		Q.QuestionID = ANS.QuestionID
GROUP BY 
		Q.QuestionID, Q.content
HAVING 	COUNT(*) = (
		SELECT MAX(AnswerCount)
		FROM (
			SELECT COUNT(*) AS AnswerCount
			FROM answer
			GROUP BY QuestionID
		) AS MaxCounts
);

-- Question 9: Thống kê số lượng account trong mỗi group
SELECT 	GroupName, COUNT(*) AS AccountCount
FROM 	`Group` AS G
INNER JOIN 
		GroupAccount AS GA
ON 		G.GroupID = GA.GroupID
GROUP BY 
		GroupName;
        
-- Question 10: Tìm chức vụ có ít người nhất
SELECT 	P.PositionName
FROM	`account` AS AC
INNER JOIN 
		`position` AS P
ON 		AC.PositionID = P.PositionID 	
GROUP BY P.PositionID
HAVING 	COUNT(*) = (
		SELECT MIN(PositionCount)
		FROM (
			SELECT COUNT(*) AS PositionCount
			FROM `account`
			GROUP BY PositionID
		) AS MinCounts
);

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT	D.DepartmentName, P.PositionName, COUNT(*) AS PositionCount
FROM	`account` AS AC
INNER JOIN 
		department AS D
ON		AC.DepartmentID = D.DepartmentID
INNER JOIN
		`position` AS P 
ON 		AC.PositionID = P.PositionID 
GROUP BY 
		D.DepartmentName, P.PositionName;
        
-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì,…

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT 	TQ.TypeName, COUNT(*) AS QuestionCount
FROM	question AS Q
INNER JOIN 
		typequestion AS TQ
ON 		Q.TypeID = TQ.TypeID
GROUP BY 
		TQ.TypeName;

-- Question 14 & 15: Lấy ra group không có account nào
SELECT 	G.GroupName
FROM 	`Group` AS G
LEFT JOIN 
		GroupAccount AS GA 
ON 		G.GroupID = GA.GroupID
WHERE 	GA.GroupID IS NULL;

-- Question 16: Lấy ra question không có answer nào
SELECT 	Q.Content
FROM 	question AS Q
LEFT JOIN 
		answer AS ANS
ON 		Q.QuestionID = ANS.QuestionID
WHERE 	ANS.QuestionID IS NULL;

-- Exercise 2: Union
-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
SELECT 	A.*
FROM 	`Account` AS A
INNER JOIN 
		GroupAccount AS GA 
ON 		A.AccountID = GA.AccountID
WHERE 	GA.GroupID = 1;
-- b) Lấy các account thuộc nhóm thứ 2
SELECT 	A.*
FROM 	`Account` AS A
INNER JOIN 
		GroupAccount AS GA 
ON 		A.AccountID = GA.AccountID
WHERE 	GA.GroupID = 2;
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT 	A.*
FROM 	`Account` AS A
INNER JOIN 
		GroupAccount AS GA 
ON 		A.AccountID = GA.AccountID
WHERE 	GA.GroupID = 1
UNION 
SELECT 	A.*
FROM 	`Account` AS A
INNER JOIN 
		GroupAccount AS GA 
ON 		A.AccountID = GA.AccountID
WHERE 	GA.GroupID = 2;
-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
SELECT 	GroupName
FROM 	`Group` AS G
INNER JOIN 
		GroupAccount AS GA
ON 		G.GroupID = GA.GroupID
GROUP BY 
		GroupName
HAVING COUNT(*) > 5;
-- b) Lấy các group có nhỏ hơn 7 thành viên
SELECT 	GroupName
FROM 	`Group` AS G
INNER JOIN 
		GroupAccount AS GA
ON 		G.GroupID = GA.GroupID
GROUP BY 
		GroupName
HAVING COUNT(*) < 7;
-- c) Ghép 2 kết quả từ câu a) và câu b)
SELECT 	GroupName
FROM 	`Group` AS G
INNER JOIN 
		GroupAccount AS GA
ON 		G.GroupID = GA.GroupID
GROUP BY 
		GroupName
HAVING 	COUNT(*) > 5
UNION ALL
SELECT 	GroupName
FROM 	`Group` AS G
INNER JOIN 
		GroupAccount AS GA
ON 		G.GroupID = GA.GroupID
GROUP BY 
		GroupName
HAVING 	COUNT(*) < 7;























