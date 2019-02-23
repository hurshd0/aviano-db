I have created `aviano-db` which is used to understand principles of database design for beginners, and can also be used as toy database for front end projects. 

## Sample Car Rental System Database ERD
![car rental system erd](images/erd-design/aviano-erd.png)

## Sample SQL Queries
Following are sample `SQL` queries you can do on `aviano-db` to test.

### 1. Customer's Renal History
```sql
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
```
`Output`:
![](images/query_output/Result_8.PNG)

### 2. Calculate Customer's Base Rent
```sql
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
```
`Output`:
![](images/query_output/Result_9.PNG)

### 3. Calculate Customer's Equipment Rental Cost
```sql
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
```
`Output`:
![](images/query_output/Result_11.PNG)

### 4. Calculate Customer's Insurance Cost
```sql
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
```
`Output`:
![](images/query_output/Result_10.PNG)

### 5. Calculate Customer's Total Rental Cost
```sql
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
```
`Output`:
![](images/query_output/Result_12.PNG)

## DBMS used
MySQL 5.5

## USAGE
* Step 1. Clone/Download this repository
* Step 2. [Install `MySQL Server` on Windows/Linux/macOS](https://dev.mysql.com/downloads/mysql/) and **NOTE:** Your `root` password.
* Step 3. [Install `MySQL Workbench`](https://dev.mysql.com/downloads/workbench/)
* Step 4. Create connection to your MySQL Server, which could be locally or remote depending on where you installed the MySQL server.
* Step 5. Run `create-aviano-db.sql` from MySQL Workbench, when running make sure you have `root` privileges.

Now you are free to play with `SELECT` queries. 

## License
Unless otherwise specified, the database and its code on this repository is licensed under GPLv3 license. See the `LICENSE` file for more details.

