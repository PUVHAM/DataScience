USE testing_system_db;

-- Question 1: Done

-- Question 2: Lấy ra tất cả các phòng ban Department
SELECT 	DepartmentName 
FROM 	Department;

-- Question 3: Lấy ra id của phòng ban "Sale"
SELECT 	DepartmentID 
FROM 	Department
WHERE 	DepartmentName = 'Sale';

-- Question 4: lấy ra thông tin account có full name dài nhất
SELECT 	*
FROM 	`Account`
WHERE 	LENGTH(FullName) = 
		(	SELECT 	MAX(LENGTH(FullName)) 	
			FROM 	`Account`			);
        
-- Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id = 3
SELECT 	*
FROM 	`Account`
WHERE 	LENGTH(FullName) = 
		(	SELECT 	MAX(LENGTH(FullName)) 	
			FROM 	`Account` 	
            WHERE 	DepartmentID = 3	);

-- Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019
SELECT 	GroupName
FROM 	`group`
WHERE 	CreateDate < '2019-12-20%';
        
-- Question 7: Lấy ra ID của question có >= 4 câu trả lời
SELECT 	QuestionID
FROM 	`Answer`
GROUP BY 
		`QuestionID`
HAVING 	COUNT(*) >= 4;

-- Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019
SELECT 	`Code`
FROM 	exam
WHERE 	Duration >= 60 AND
		CreateDate < '2019-12-20%';

-- Question 9: Lấy ra 5 group được tạo gần đây nhất
SELECT 	*
FROM 	`Group`
ORDER BY 
		`CreateDate` DESC
LIMIT 	5;

-- Question 10: Đếm số nhân viên thuộc department có id = 2
SELECT COUNT(*)
FROM `Account`
WHERE DepartmentID = 2;

-- Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
SELECT FullName
FROM `Account`
WHERE FullName LIKE 'D%o';

-- Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019
DELETE FROM exam
WHERE CreateDate < '2019-12-20';

DELETE
FROM 	`ExamQuestion`
WHERE 	`ExamID` 	IN (SELECT `ExamID`
					FROM `Exam`
					WHERE `CreateDate` < '2019-12-20');

-- Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
DELETE
FROM 	`Answer`
WHERE 	`QuestionID` 	IN (SELECT `QuestionID`
						FROM `Question`
						WHERE `Content` LIKE 'Câu hỏi%');
                 
-- Question 14: Update thông tin của account có id = 5 thành tên "Lô Văn Đề" và email thành lo.vande@mmc.edu.vn
UPDATE 	`Account`
SET 	FullName = 'Lô Văn Đề', Email = 'lo.vande@mmc.edu.vn'
WHERE 	AccountID = 5;

-- Question 15: Update account có id = 5 sẽ thuộc group có id = 4
UPDATE 	`GroupAccount`
SET 	`GroupID` = 4
WHERE 	`AccountID` = 5;
                      

