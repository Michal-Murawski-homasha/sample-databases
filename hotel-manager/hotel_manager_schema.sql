-- Database: hotel_manager

-- DROP DATABASE IF EXISTS hotel_manager;

-- CREATE DATABASE hotel_manager
--     WITH
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'Polish_Poland.1250'
--     LC_CTYPE = 'Polish_Poland.1250'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1
--     IS_TEMPLATE = False;

DROP TABLE IF EXISTS city CASCADE;
DROP TABLE IF EXISTS street CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS master_cell CASCADE;
DROP TABLE IF EXISTS support_cell CASCADE;
DROP TABLE IF EXISTS functional_and_administrative_cell CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS employee_schedule CASCADE;
DROP TABLE IF EXISTS status CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS menu CASCADE;
DROP TABLE IF EXISTS restaurant CASCADE;
DROP TABLE IF EXISTS features CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS feature_of_room CASCADE;
DROP TABLE IF EXISTS reservations CASCADE;
DROP TABLE IF EXISTS invoices CASCADE;
	
CREATE TABLE city (
	city_id SERIAL NOT NULL,
	city_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (city_id)
);

CREATE TABLE street (
	street_id SERIAL NOT NULL,
	street_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (street_ID)
);

CREATE TABLE clients (
	client_id SERIAL NOT NULL,
	client_first_name VARCHAR(64) NOT NULL,
	client_last_name VARCHAR(64) NOT NULL,
	client_nip VARCHAR(16) NOT NULL,
	client_phone VARCHAR(24),
	client_email VARCHAR(255) NOT NULL,
	client_is_vistors BOOLEAN NOT NULL,
	city_id INT,
	city_code VARCHAR(8) NOT NULL,
	street_id INT,
	street_number VARCHAR(8),
	locale_number VARCHAR(8),
	client_discount INT,
	PRIMARY KEY (client_id),
	UNIQUE (client_email),
	CONSTRAINT fk_client_city
		FOREIGN KEY (city_id)
			REFERENCES city (city_id),
	CONSTRAINT fk_client_street
		FOREIGN KEY (street_id)
			REFERENCES street (street_id)
);

CREATE TABLE companies (
	company_id SERIAL NOT NULL,
	company_name VARCHAR(255) NOT NULL,
	company_regon VARCHAR(16) NOT NULL,
	company_nip VARCHAR(16),
	company_phone VARCHAR(24),
	company_email VARCHAR(255) NOT NULL,
	city_id INT,
	city_code VARCHAR(8) NOT NULL,
	street_id INT,
	street_number VARCHAR(16),
	locale_number VARCHAR(16),
	PRIMARY KEY (company_id),
	UNIQUE (company_email),
	CONSTRAINT fk_company_city
		FOREIGN KEY (city_id)
			REFERENCES city (city_id),
	CONSTRAINT fk_company_street
		FOREIGN KEY (street_id)
			REFERENCES street (street_id)
);

CREATE TABLE departments (
	department_id SERIAL NOT NULL,
	department_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (department_id)
);

CREATE TABLE master_cell (
	master_cell_id SERIAL NOT NULL,
	department_id INT,
	PRIMARY KEY (master_cell_id),
	CONSTRAINT fk_master_cell_department
		FOREIGN KEY (department_id)
			REFERENCES departments (department_id)
);

CREATE TABLE support_cell (
	support_cell_id SERIAL NOT NULL,
	department_id INT,
	PRIMARY KEY (support_cell_id),
	CONSTRAINT fk_support_cell_department
		FOREIGN KEY (department_id)
			REFERENCES departments (department_id)
);

CREATE TABLE functional_and_administrative_cell (
	functional_and_administrative_cell_id SERIAL NOT NULL,
	department_id INT,
	PRIMARY KEY (functional_and_administrative_cell_id),
	CONSTRAINT fk_functional_and_administrative_department
		FOREIGN KEY (department_id)
			REFERENCES departments (department_id)
);

CREATE TABLE employees (
	employee_id SERIAL NOT NULL,
	employee_first_name VARCHAR(64) NOT NULL,
	employee_last_name VARCHAR(64) NOT NULL,
	employee_nip VARCHAR(16) NOT NULL,
	employee_phone VARCHAR(24),
	employee_email VARCHAR(255) NOT NULL,
	city_id INT,
	city_code VARCHAR(8) NOT NULL,
	street_id INT,
	street_number VARCHAR(8),
	locale_number VARCHAR(8),
	department_id INT,
	PRIMARY KEY (employee_id),
	UNIQUE (employee_email),
	CONSTRAINT fk_employee_city
		FOREIGN KEY (city_id)
			REFERENCES city (city_id),
	CONSTRAINT fk_employee_street
		FOREIGN KEY (street_id)
			REFERENCES street (street_id),
	CONSTRAINT fk_employee_department
		FOREIGN KEY (department_id)
			REFERENCES departments (department_id)
);

CREATE TABLE employee_schedule (
	employee_schedule_id SERIAL NOT NULL,
	employee_id INT NOT NULL,
	work_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_time TIME,
	PRIMARY KEY (employee_schedule_id),
	CONSTRAINT fk_employee_schedule_employee
		FOREIGN KEY (employee_id)
			REFERENCES employees (employee_id)
);

CREATE TABLE status (
	status_id SERIAL NOT NULL,
	status_name VARCHAR(255) NOT NULL,
	status_code VARCHAR(8) NOT NULL,
	PRIMARY KEY (status_id),
	UNIQUE (status_code)
);

CREATE TABLE orders (
	order_id SERIAL NOT NULL,
	order_code VARCHAR(8) NOT NULL,
	status_id INT,
	client_id INT,
	company_id INT,
	employee_id INT,
	PRIMARY KEY (order_id),
	UNIQUE (order_code),
	CONSTRAINT fk_order_status
		FOREIGN KEY (status_id)
			REFERENCES status (status_id),
	CONSTRAINT fk_order_client
		FOREIGN KEY (client_id)
			REFERENCES clients (client_id),
	CONSTRAINT fk_order_company
		FOREIGN KEY (company_id)
			REFERENCES companies (company_id),
	CONSTRAINT fk_order_employee
		FOREIGN KEY (employee_id)
			REFERENCES employees (employee_id)
);

CREATE TABLE tasks (
	task_id SERIAL,
	task_name VARCHAR(255),
	status_id INT,
	employee_id INT,
	PRIMARY KEY (task_id),
	CONSTRAINT fk_task_status
		FOREIGN KEY (status_id)
			REFERENCES status (status_id),
	CONSTRAINT fk_task_employee
		FOREIGN KEY (employee_id)
			REFERENCES employees (employee_id)
);

CREATE TABLE menu (
	menu_id SERIAL NOT NULL,
	mealtime_status_id INT,
	meal_type_status_id INT,
	other_status_id INT,
	dish_name VARCHAR(255) NOT NULL,
	dish_price NUMERIC(19, 2) NOT NULL,
	available_from TIME NOT NULL,
	available_to TIME NOT NULL,
	PRIMARY KEY (menu_id),
	CONSTRAINT fk_menu_mealtime_status
		FOREIGN KEY (mealtime_status_id)
			REFERENCES status (status_id),
	CONSTRAINT fk_menu_meal_type_status
		FOREIGN KEY (meal_type_status_id)
			REFERENCES status (status_id),
	CONSTRAINT fk_menu_other_status
		FOREIGN KEY (other_status_id)
			REFERENCES status (status_id)
);

CREATE TABLE restaurant (
	restaurant_id SERIAL NOT NULL,
	menu_id INT,
	order_id INT,
	task_id INT,
	PRIMARY KEY (restaurant_id),
	CONSTRAINT fk_restaurant_menu
		FOREIGN KEY (menu_id)
			REFERENCES menu (menu_id),
	CONSTRAINT fk_restaurant_order
		FOREIGN KEY (order_id)
			REFERENCES orders (order_id),
	CONSTRAINT fk_restaurant_task
		FOREIGN KEY (task_id)
			REFERENCES tasks (task_id)
);

CREATE TABLE features (
	feature_id SERIAL NOT NULL,
	feature_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (feature_id)
);

CREATE TABLE rooms (
	room_id SERIAL NOT NULL,
	room_name VARCHAR(255) NOT NULL,
	numbers_of_places_in_room INT NOT NULL,
	room_price NUMERIC(19, 2) NOT NULL,
	number_of_floor INT NOT NULL,
	room_occupancy_status_id INT NOT NULL,
	room_readines_status_id INT NOT NULL,
	PRIMARY KEY (room_id),
	CONSTRAINT fk_room_occupancy_status
		FOREIGN KEY (room_occupancy_status_id)
			REFERENCES status (status_id),
	CONSTRAINT fk_room_readines_status
		FOREIGN KEY (room_readines_status_id)
			REFERENCES status (status_id)
);

CREATE TABLE feature_of_room (
	feature_of_room_id SERIAL NOT NULL,
	room_id INT NOT NULL,
	feature_id INT NOT NULL,
	PRIMARY KEY (feature_of_room_id),
	CONSTRAINT fk_feature_of_room_room
		FOREIGN KEY (room_id)
			REFERENCES rooms (room_id),
	CONSTRAINT fk_feature_of_room_feature
		FOREIGN KEY (feature_id)
			REFERENCES features (feature_id)
);

CREATE TABLE reservations (
	reservation_id SERIAL NOT NULL,
	room_id INT NOT NULL,
	client_id INT,
	company_id INT,
	reservation_date_from DATE NOT NULL,
	reservation_date_to DATE NOT NULL,
	reservation_note VARCHAR(255),
	PRIMARY KEY (reservation_id),
	CONSTRAINT fk_reservation_room
		FOREIGN KEY (room_id)
			REFERENCES rooms (room_id),
	CONSTRAINT fk_reservation_client
		FOREIGN KEY (client_id)
			REFERENCES clients (client_id),
	CONSTRAINT fk_reservation_company
		FOREIGN KEY (company_id)
			REFERENCES companies (company_id)
);

CREATE TABLE invoices (
	invoice_id SERIAL NOT NULL,
	invoice_code VARCHAR(255) NOT NULL,
	status_id INT NOT NULL,
	client_id INT,
	employee_id INT,
	company_id INT,
	amount NUMERIC(19, 2) NOT NULL,
	PRIMARY KEY (invoice_id),
	CONSTRAINT fk_invoice_status
		FOREIGN KEY (status_id)
			REFERENCES status (status_id),
	CONSTRAINT fk_invoice_client
		FOREIGN KEY (client_id)
			REFERENCES clients (client_id),
	CONSTRAINT fk_invoice_employee
		FOREIGN KEY (employee_id)
			REFERENCES employees (employee_id),
	CONSTRAINT fk_invoice_company
		FOREIGN KEY (company_id)
			REFERENCES companies (company_id)
);