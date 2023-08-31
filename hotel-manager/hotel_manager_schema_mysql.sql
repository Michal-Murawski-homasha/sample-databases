SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS hotel_manager;
CREATE SCHEMA hotel_manager;
USE hotel_manager;

CREATE TABLE cities (
	city_id INT (11) NOT NULL AUTO_INCREMENT,
	city_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (city_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE streets (
	street_id INT (11) NOT NULL AUTO_INCREMENT,
	street_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (street_ID)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE clients (
	client_id INT (11) NOT NULL AUTO_INCREMENT,
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
			REFERENCES cities (city_id),
	CONSTRAINT fk_client_street
		FOREIGN KEY (street_id)
			REFERENCES streets (street_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE companies (
	company_id INT (11) NOT NULL AUTO_INCREMENT,
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
			REFERENCES cities (city_id),
	CONSTRAINT fk_company_street
		FOREIGN KEY (street_id)
			REFERENCES streets (street_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE departments (
	department_id INT (11) NOT NULL AUTO_INCREMENT,
	department_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (department_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE master_cell (
	master_cell_id INT (11) NOT NULL AUTO_INCREMENT,
	department_id INT,
	PRIMARY KEY (master_cell_id),
	CONSTRAINT fk_master_cell_department
		FOREIGN KEY (department_id)
			REFERENCES departments (department_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE support_cell (
	support_cell_id INT (11) NOT NULL AUTO_INCREMENT,
	department_id INT,
	PRIMARY KEY (support_cell_id),
	CONSTRAINT fk_support_cell_department
		FOREIGN KEY (department_id)
			REFERENCES departments (department_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE functional_and_administrative_cell (
	functional_and_administrative_cell_id INT (11) NOT NULL AUTO_INCREMENT,
	department_id INT,
	PRIMARY KEY (functional_and_administrative_cell_id),
	CONSTRAINT fk_functional_and_administrative_department
		FOREIGN KEY (department_id)
			REFERENCES departments (department_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE employees (
	employee_id INT (11) NOT NULL AUTO_INCREMENT,
	employee_first_name VARCHAR(64) NOT NULL,
	employee_last_name VARCHAR(64) NOT NULL,
	employee_nip VARCHAR(16) NOT NULL,
	employee_phone VARCHAR(24),
	employee_email VARCHAR(255) NOT NULL,
	employee_password VARCHAR(255) NOT NULL,
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
			REFERENCES cities (city_id),
	CONSTRAINT fk_employee_street
		FOREIGN KEY (street_id)
			REFERENCES streets (street_id),
	CONSTRAINT fk_employee_department
		FOREIGN KEY (department_id)
			REFERENCES departments (department_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE employee_schedule (
	employee_schedule_id INT (11) NOT NULL AUTO_INCREMENT,
	employee_id INT NOT NULL,
	work_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_time TIME,
	PRIMARY KEY (employee_schedule_id),
	CONSTRAINT fk_employee_schedule_employee
		FOREIGN KEY (employee_id)
			REFERENCES employees (employee_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE status (
	status_id INT (11) NOT NULL AUTO_INCREMENT,
	status_name VARCHAR(255) NOT NULL,
	status_code VARCHAR(8) NOT NULL,
	PRIMARY KEY (status_id),
	UNIQUE (status_code)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE orders (
	order_id INT (11) NOT NULL AUTO_INCREMENT,
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
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE tasks (
	task_id INT (11) NOT NULL AUTO_INCREMENT,
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
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE menu (
	menu_id INT (11) NOT NULL AUTO_INCREMENT,
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
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE restaurant (
	restaurant_id INT (11) NOT NULL AUTO_INCREMENT,
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
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE features (
	feature_id INT (11) NOT NULL AUTO_INCREMENT,
	feature_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (feature_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE rooms (
	room_id INT (11) NOT NULL AUTO_INCREMENT,
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
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE feature_of_room (
	feature_of_room_id INT (11) NOT NULL AUTO_INCREMENT,
	room_id INT NOT NULL,
	feature_id INT NOT NULL,
	PRIMARY KEY (feature_of_room_id),
	CONSTRAINT fk_feature_of_room_room
		FOREIGN KEY (room_id)
			REFERENCES rooms (room_id),
	CONSTRAINT fk_feature_of_room_feature
		FOREIGN KEY (feature_id)
			REFERENCES features (feature_id)
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE reservations (
	reservation_id INT (11) NOT NULL AUTO_INCREMENT,
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
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE invoices (
	invoice_id INT (11) NOT NULL AUTO_INCREMENT,
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
)
ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

ALTER DATABASE hotel_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;