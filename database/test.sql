DROP SCHEMA IF EXISTS `test` ;
CREATE SCHEMA IF NOT EXISTS `test` DEFAULT CHARACTER SET utf8 ;
USE `test` ;


-- -----------------------------------------------------
-- Table `customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `customer` ;
CREATE TABLE IF NOT EXISTS `customer` (
    `id` INT NOT NULL,
    `first_name` VARCHAR(45) NOT NULL,
    `last_name` VARCHAR(45) NOT NULL,
    `dob` DATE NOT NULL,
    `driver_license_number` VARCHAR(12) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(12) NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `driver_license_number_UNIQUE` (`driver_license_number` ASC),
    UNIQUE INDEX `email_UNIQUE` (`email` ASC)
)  ENGINE=INNODB;

-- -----------------------------------------------------
-- Before Insert Trigger for table `customer`
-- -----------------------------------------------------
DELIMITER $$
CREATE TRIGGER age_check BEFORE INSERT ON customer
    FOR EACH ROW 
BEGIN 
	DECLARE age INT UNSIGNED;
    SELECT TIMESTAMPDIFF(YEAR, new.dob, CURDATE()) INTO age FROM DUAL;
    IF (age < 21) THEN
    SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'customerage_checkcheck constraint on customer.dob failed';
    END IF;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Data for table `customer`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `customer` (`id`, `first_name`, `last_name`, `dob`, `driver_license_number`, `email`, `phone`) VALUES (1, 'Kelby', 'Matterdace', '1974-05-22', 'V435899293', 'kmatterdace0@oracle.com', '181-441-7828');
INSERT INTO `customer` (`id`, `first_name`, `last_name`, `dob`, `driver_license_number`, `email`, `phone`) VALUES (2, 'Orion', 'De Hooge', '2000-08-07', 'Z140530509', 'odehooge1@quantcast.com', '948-294-5458');
COMMIT;

ROLLBACK;

SELECT 
    *
FROM
    customer;
    


