DROP DATABASE IF EXISTS car_sale_managment;
CREATE DATABASE car_sale_managment;
USE car_sale_managment;

-- CUSTOMER:
-- ● CustomerID: mã khách hàng, primary key, auto increment.
-- ● Name: tên của khách hàng.
-- ● Phone: số điện thoại của khách hàng.
-- ● Email: địa chỉ email của khách hàng.
-- ● Address: địa chỉ của khách hàng.
-- ● Note: tóm tắt mô tả về khách hàng.

-- Table: CUSTOMER
DROP TABLE IF EXISTS CUSTOMER;
CREATE TABLE CUSTOMER(
	CustomerID 			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Name`		 		NVARCHAR(30) NOT NULL,
    Phone 				VARCHAR(20),
    Email 				VARCHAR(255),
    Address 			VARCHAR(255),
    Note 				TEXT
);

-- CAR:
-- ● CarID: mã oto, primary key.
-- ● Maker: tên hãng sản xuất (chỉ có thể là 3 giá trị: ‘HONDA’, ‘TOYOTA’,
-- ● ‘NISSAN’).
-- ● Model: tên của mẫu xe.
-- ● Year: năm sản xuất.
-- ● Color: màu của xe (black, white, yellow...).
-- ● Note: tóm tắt mô tả về xe.

-- Table: CAR
DROP TABLE IF EXISTS CAR;
CREATE TABLE CAR(
	CarID 				TINYINT UNSIGNED NOT NULL PRIMARY KEY,
    Maker		 		ENUM('HONDA', 'TOYOTA', 'NISSAN') NOT NULL,
    Model 				NVARCHAR(50) NOT NULL,
    `Year` 				YEAR NOT NULL,
    Color 				VARCHAR(20),
    Note 				TEXT
);

-- CAR_ORDER:
-- ● OrderID: mã đơn hàng, primary key, auto increment.
-- ● CustomerID: mã khách hàng, foreign key.
-- ● CarID: mã oto, foreign key.
-- ● Amount: số lượng oto, default value = 1.
-- ● SalePrice: giá bán oto.
-- ● OrderDate: ngày bán .
-- ● DeliveryDate: ngày giao hàng.
-- ● DeliveryAddress: địa chỉ giao hàng.
-- ● Staus: trạng thái của đơn hàng (0: đã đặt hàng, 1: đã giao, 2: đã hủy), mặc định
-- ● trạng thái là đã đặt hàng.
-- ● Note: tóm tắt mô tả về đơn hàng.

-- Table: CAR_ORDER
DROP TABLE IF EXISTS CAR_ORDER;
CREATE TABLE CAR_ORDER(
	OrderID				TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    CustomerID			TINYINT UNSIGNED NOT NULL,
	CarID 				TINYINT UNSIGNED NOT NULL,
    Amount 				INT DEFAULT 1,
    SalePrice 			DECIMAL(10,2) NOT NULL,
    OrderDate 			DATE,
    DeliveryDate 		DATE,
    DeliveryAddress 	NVARCHAR(255),
    `Status` 			TINYINT DEFAULT 0,
    Note 				TEXT,
    FOREIGN KEY (CustomerID) 	REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (CarID) 		REFERENCES CAR(CarID)
);

INSERT INTO CUSTOMER 	(Name			, Phone			, Email						, Address																	, Note) 
VALUES					('Nguyễn Văn A'	, '0123-456-789', 'nguyenvana@example.com'	, '123 Đường Lê Lợi, Phường 1, Quận Gò Vấp, Thành phố Hồ Chí Minh'			, 'Khách hàng thường xuyên'),
						('Trần Thị B'	, '0987-654-321', 'tranthib@example.com'	, '456 Đường Nguyễn Huệ, Phường 2, Quận 5, Thành phố Hồ Chí Minh'			, 'Khách hàng VIP'),
						('Lê Thanh C'	, '0333-222-444', 'lethanhc@example.com'	, '789 Đường Trần Phú, Phường 3, Quận 10, Thành phố Hồ Chí Minh'			, 'Khách hàng mới'),
						('Phạm Văn D'	, '0777-888-999', 'phamvand@example.com'	, '234 Đường Hùng Vương, Phường 4, Quận Bình Thạnh, Thành phố Hồ Chí Minh'	, 'Khách hàng thân thiết'),
						('Hoàng Thị E'	, '0555-666-777', 'hoangthie@example.com'	, '567 Đường Lý Tự Trọng, Phường 5, Quận 1, Thành phố Hồ Chí Minh'			, 'Khách hàng ưu tiên');
                        
INSERT INTO CAR (CarID, Maker, Model, Year, Color, Note) 
VALUES			(1, 'HONDA', 'Civic', 2022, 'Black', 'Compact sedan'),
				(2, 'TOYOTA', 'Corolla', 2023, 'White', 'Sedan'),
				(3, 'NISSAN', 'Altima', 2021, 'Blue', 'Mid-size sedan'),
				(4, 'HONDA', 'Accord', 2024, 'Red', 'Mid-size sedan'),
				(5, 'TOYOTA', 'Camry', 2020, 'Silver', 'Mid-size sedan');
                
INSERT INTO CAR_ORDER (CustomerID, CarID, Amount, SalePrice, OrderDate, DeliveryDate, DeliveryAddress, `Status`, Note) VALUES
(1, 1, 2, 25000, '2023-05-20', '2023-05-25', '123 Đường Lê Lợi, Phường 1, Quận Gò Vấp, Thành phố Hồ Chí Minh', 2, 'Đặt mua hai xe Honda cho khách hàng 1'),
(2, 2, 1, 30000, '2024-05-19', '2024-05-24', '456 Đường Nguyễn Huệ, Phường 2, Quận 5, Thành phố Hồ Chí Minh', 0, 'Đặt mua một xe Toyota cho khách hàng 2'),
(3, 3, 3, 27000, '2024-05-18', '2024-05-23', '789 Đường Trần Phú, Phường 3, Quận 10, Thành phố Hồ Chí Minh', 0, 'Đặt mua ba xe Nissan cho khách hàng 3'),
(5, 2, 1, 28000, '2024-05-17', '2024-05-22', '234 Đường Hùng Vương, Phường 4, Quận Bình Thạnh, Thành phố Hồ Chí Minh', 1, 'Đặt mua một xe Toyota cho khách hàng 1'),
(4, 1, 2, 25500, '2024-05-16', '2024-05-21', '567 Đường Lý Tự Trọng, Phường 5, Quận 1, Thành phố Hồ Chí Minh', 1, 'Đặt mua hai xe Honda cho khách hàng 2');

-- 2. Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã mua và sắp sếp tăng dần theo số lượng oto đã mua.

SELECT	C.`Name`, CO.Amount
FROM 	customer C
INNER JOIN
		CAR_ORDER CO
ON		C.CustomerID = CO.CustomerID
ORDER BY
		CO.Amount ASC;
        
-- 3. Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều oto nhất trong năm nay.
DROP FUNCTION IF EXISTS f_MostSoldCarMaker;
DELIMITER $$

CREATE FUNCTION f_MostSoldCarMaker() RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE most_sold_maker VARCHAR(255);
    SELECT 	Maker 	INTO most_sold_maker
    FROM (
			SELECT 	C.Maker, SUM(CO.Amount) AS Total_Sold
			FROM 	CAR_ORDER CO
			INNER JOIN 
					CAR C 
			ON 		CO.CarID = C.CarID
			WHERE 	YEAR(co.OrderDate) = YEAR(CURDATE()) 
			GROUP BY 
					C.Maker
			ORDER BY 
					Total_Sold DESC
			LIMIT 1
	) AS most_sold_car_maker;

    RETURN most_sold_maker;
END$$

DELIMITER ;

SELECT f_MostSoldCarMaker();

-- 4. Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của những năm trước. In ra số lượng bản ghi đã bị xóa.
DROP PROCEDURE IF EXISTS sp_DelCancelOrder;
DELIMITER $$

CREATE PROCEDURE sp_DelCancelOrder()
BEGIN
    DECLARE del_count INT;

    -- Xóa các đơn hàng đã bị hủy của những năm trước
    DELETE FROM
			CAR_ORDER
    WHERE 	Status = 2 AND 
			YEAR(OrderDate) < YEAR(CURDATE());

    SELECT 	ROW_COUNT() INTO del_count;

    SELECT 	del_count AS DelCancelOrder;
END$$

DELIMITER ;

CALL sp_DelCancelOrder();

-- 5. Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn
-- hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng
-- oto và tên hãng sản xuất.
DROP PROCEDURE IF EXISTS sp_UserStatus;
DELIMITER $$

CREATE PROCEDURE sp_UserStatus(IN in_CustomerID INT)
BEGIN
    SELECT CU.`Name` AS CustomerName, CO.OrderID, CO.Amount, C.Maker
    FROM customer CU
    INNER JOIN car_order CO ON CU.CustomerID = CO.CustomerID
    INNER JOIN car C ON CO.CarID = C.CarID
    WHERE CU.CustomerID = in_CustomerID;
END$$
DELIMITER ;

CALL sp_UserStatus(2);


-- 6. Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
-- vào database (DeliveryDate < OrderDate + 15).
DROP TRIGGER IF EXISTS Trg_CheckDate;

DELIMITER $$
CREATE TRIGGER Trg_CheckDate
BEFORE INSERT ON car_order
FOR EACH ROW
BEGIN
	IF NEW.DeliveryDate < DATE_ADD(NEW.OrderDate, INTERVAL 15 DAY) THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'DeliveryDate must be at least 15 days after OrderDate.';
	END IF;
END$$ 
DELIMITER ;

SHOW TRIGGERS;





























