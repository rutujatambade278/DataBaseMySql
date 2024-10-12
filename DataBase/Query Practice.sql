CREATE TABLE calendars (
    date DATE PRIMARY KEY,
    month INT NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL
);

DELIMITER //
CREATE PROCEDURE fillDates(IN startDate DATE,IN endDate DATE)
BEGIN
	DECLARE currentDate DATE DEFAULT startDate;
    insert_date: LOOP
		-- increase date by one day
		SET currentDate = DATE_ADD(currentDate, INTERVAL 1 DAY);
        -- leave the loop if the current date is after the end date
        IF currentDate > endDate THEN
			LEAVE insert_date;
        END IF;
        -- insert date into the table
        INSERT INTO calendars(date, month, quarter, year)
        VALUES(currentDate, MONTH(currentDate), QUARTER(currentDate), YEAR(currentDate));
		END LOOP;
END //
DELIMITER ;

CALL fillDates('2024-01-01','2024-12-31');

DELIMITER $$

CREATE PROCEDURE loadDates(
    startDate DATE, 
    day INT
)
BEGIN
    
    DECLARE counter INT DEFAULT 0;
    DECLARE currentDate DATE DEFAULT startDate;

    WHILE counter <= day DO
        CALL InsertCalendar(currentDate);
        SET counter = counter + 1;
        SET currentDate = DATE_ADD(currentDate ,INTERVAL 1 day);
    END WHILE;

END$$

DELIMITER ;