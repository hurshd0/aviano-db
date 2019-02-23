use `aviano-db`;

-- -----------------------------------------------------
-- Show tables		
-- -----------------------------------------------------
SHOW TABLES;
-- -----------------------------------------------------
-- Describe Queries		
-- -----------------------------------------------------
DESCRIBE customer;
DESCRIBE equipment;
DESCRIBE equipment_type;
DESCRIBE fuel_option;
DESCRIBE insurance;
DESCRIBE location;
DESCRIBE rental;
DESCRIBE rental_has_equipment_type;
DESCRIBE rental_has_insurance;
DESCRIBE rental_invoice;
DESCRIBE vehicle;
DESCRIBE vehicle_has_equiment;
DESCRIBE vehicle_type;

-- -----------------------------------------------------
-- Index Queries		
-- -----------------------------------------------------
SHOW INDEX FROM customer;
SHOW INDEX FROM equipment;
SHOW INDEX FROM equipment_type;
SHOW INDEX FROM fuel_option;
SHOW INDEX FROM insurance;
SHOW INDEX FROM location;
SHOW INDEX FROM rental;
SHOW INDEX FROM rental_has_equipment_type;
SHOW INDEX FROM rental_has_insurance;
SHOW INDEX FROM rental_invoice;
SHOW INDEX FROM vehicle;
SHOW INDEX FROM vehicle_has_equiment;
SHOW INDEX FROM vehicle_type;



-- -----------------------------------------------------
-- SELECT Queries to display test date	
-- -----------------------------------------------------

SELECT * FROM `aviano-db`.customer;
SELECT * FROM `aviano-db`.equipment;
SELECT * FROM `aviano-db`.equipment_type;
SELECT * FROM `aviano-db`.fuel_option;
SELECT * FROM `aviano-db`.insurance;
SELECT * FROM `aviano-db`.location;
SELECT * FROM `aviano-db`.rental;
SELECT * FROM `aviano-db`.rental_has_equipment_type;
SELECT * FROM `aviano-db`.rental_has_insurance;
SELECT * FROM `aviano-db`.rental_invoice;
SELECT * FROM `aviano-db`.vehicle;
SELECT * FROM `aviano-db`.vehicle_has_equiment;
SELECT * FROM `aviano-db`.vehicle_type;




SELECT * FROM location;

SELECT 
    name AS 'Car type', rental_value AS 'Rental cost per day'
FROM
    vehicle_type;

SELECT 
    *
FROM
    fuel_option;

SELECT 
    *
FROM
    insurance;

SELECT 
    name AS 'Equipment type',
    rental_value AS 'Rental cost per day'
FROM
    equipment_type;

SELECT 
    brand AS 'Car Mfg.',
    model AS 'Car Model',
    mileage AS 'Mileage',
    color AS 'Color'
FROM
    vehicle;

SELECT 
    v.brand AS 'Car Mfg.',
    v.model AS 'Car Model',
    v.mileage AS 'Mileage',
    v.color AS 'Color',
    CONCAT_WS(',', l.city, l.state, l.zipcode) AS 'Current Car Location'
FROM
    vehicle AS v
        JOIN
    location AS l ON v.current_location_id = l.id;
    
    
SELECT 
    CONCAT_WS(',', c.first_name, c.last_name) AS 'Customer Name',
    vt.name AS 'Car Type',
    fo.name AS 'Fuel Option Selected',
    CONCAT_WS(',', l1.city, l1.state) AS 'Pickup Location',
    r.start_date as 'Pickup Date',
    CONCAT_WS(',', l2.city, l2.state) AS 'Drop-off Location',
    r.end_date as 'Drop-off Date'
    
FROM
    rental AS r
        JOIN
    customer AS c ON r.customer_id = c.id
        JOIN
    vehicle_type AS vt ON r.vehicle_type_id = vt.id
        JOIN
    fuel_option AS fo ON r.fuel_option_id = fo.id
        JOIN
    location AS l1 ON r.pickup_location_id = l1.id
        JOIN
    location AS l2 ON r.drop_off_location_id = l2.id;

SELECT 
    c.first_name,
    c.last_name,
    TIMESTAMPDIFF(YEAR, c.dob, CURDATE()) AS age
FROM
    customer AS c;
    
    
SELECT 
    CONCAT_WS(',', c.first_name, c.last_name) AS 'Customer Name',
    vt.name AS 'Car Type',
    r.start_date,
    r.end_date,
	vt.rental_value AS 'Car Rent per Day',
    DATEDIFF(r.end_date, r.start_date) AS 'Total Days Car Rented',
    vt.rental_value * DATEDIFF(r.end_date, r.start_date) AS 'Base Rent'
FROM
    rental AS r,
    vehicle_type AS vt,
    customer as c
WHERE
    r.vehicle_type_id = vt.id AND r.customer_id = c.id;
    
 SELECT 
    CONCAT_WS(',', c.first_name, c.last_name) AS 'Customer Name',
    DATEDIFF(r.end_date, r.start_date) AS 'Total Days Car Rented',
    SUM(i.cost) AS 'Insurance Cost per day',
    (SUM(i.cost) * DATEDIFF(r.end_date, r.start_date)) AS 'Total Insurance Cost'
FROM
    rental AS r
        JOIN
    customer AS c ON r.customer_id = c.id
        JOIN
    rental_has_insurance AS rhi ON r.id = rhi.rental_id
        JOIN
    insurance AS i ON rhi.insurance_id = i.id
GROUP BY r.id;   
    
    
    
    
    
SELECT 
    CONCAT_WS(',', c.first_name, c.last_name) AS 'Customer Name',
    SUM(et.rental_value) AS 'Equipment Rental Cost',
    DATEDIFF(r.end_date, r.start_date) AS 'Total Days Car Rented',
    (SUM(et.rental_value) * DATEDIFF(r.end_date, r.start_date)) AS 'Total Equipment Rental Cost'
FROM
    rental AS r
        JOIN
    customer AS c ON r.customer_id = c.id
        JOIN
    rental_has_equipment_type AS rhet ON r.id = rhet.rental_id
        JOIN
    equipment_type AS et ON rhet.equipment_type_id = et.id
GROUP BY r.id;    
    
    

SELECT 
    CONCAT_WS(',', c.first_name, c.last_name) AS 'Customer Name',
    ri.car_rent AS 'Base Rent',
    ri.equipment_rent_total AS 'Total Equipment Cost',
    ri.insurance_cost_total AS 'Total Insurance Cost',
    ri.discount_amount AS 'Discount Amount',
    ri.net_amount_payable AS 'Net Amount'
FROM
    rental_invoice AS ri
        JOIN
    rental AS r ON ri.rental_id = r.id
        JOIN
    customer AS c ON r.customer_id = c.id;


