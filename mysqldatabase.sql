/* ================================
   FEE MANAGEMENT SYSTEM (FINAL)
   ================================ */

DROP DATABASE IF EXISTS fee_management_system;
CREATE DATABASE fee_management_system;
USE fee_management_system;



/* ================================
   STUDENT SESSION (CORE MASTER)
   ================================ */
CREATE TABLE student_session (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    academic_year INT NOT NULL,
    semester INT NOT NULL,

    UNIQUE (student_id, academic_year, semester),

    FOREIGN KEY (student_id)
        REFERENCES student(student_id)
        ON DELETE CASCADE
);


/* ================================
   PAYMENT
   ================================ */
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    tuition_paid DECIMAL(10,2) DEFAULT 0,
    exam_paid DECIMAL(10,2) DEFAULT 0,
    hostel_paid DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_mode VARCHAR(50),
    transaction_id VARCHAR(100),
    receipt_no VARCHAR(50),
    payment_date DATE,
    status VARCHAR(20),

    FOREIGN KEY (session_id)
        REFERENCES student_session(session_id)
        ON DELETE CASCADE
);

/* ================================
   CONCESSION (TUITION ONLY)
   ================================ */
CREATE TABLE concession (
    concession_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    concession_type VARCHAR(100),
    concession_amount DECIMAL(10,2),
    approved_by VARCHAR(100),
    approved_date DATE,

    FOREIGN KEY (session_id)
        REFERENCES student_session(session_id)
        ON DELETE CASCADE
);

/* ================================
   FINE
   ================================ */
CREATE TABLE fine (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    fine_reason VARCHAR(200),
    fine_amount DECIMAL(10,2),
    fine_date DATE,
    status VARCHAR(20),

    FOREIGN KEY (session_id)
        REFERENCES student_session(session_id)
        ON DELETE CASCADE
);

/* ================================
   SMS LOG
   ================================ */
CREATE TABLE smslog (
    sms_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    phone_no VARCHAR(15),
    message TEXT,
    status VARCHAR(20),
    sent_time DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (session_id)
        REFERENCES student_session(session_id)
        ON DELETE CASCADE
);
/* ================================
   report 
   ================================ */
CREATE TABLE report (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    receipt_no VARCHAR(50),
    student_name VARCHAR(100),
    course VARCHAR(100),
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    date DATE,
    approved_by VARCHAR(100),

    CONSTRAINT fk_report_payment
    FOREIGN KEY (payment_id)
    REFERENCES payment(payment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
/* ================================
   fee_head
   ================================ */
CREATE TABLE fee_head (
    head_id INT AUTO_INCREMENT PRIMARY KEY,
    head_name VARCHAR(100) NOT NULL
);
INSERT INTO fee_head (head_name) VALUES
('Tuition Fee'),
('Exam Fee'),
('Bus Fee'),
('Library Fee'),
('Miscellaneous');
/* ================================
   fee_structure
   ================================ */
CREATE TABLE fee_structure_detail (
    fsd_id INT AUTO_INCREMENT PRIMARY KEY,
    course VARCHAR(100),
    academic_year INT,
    semester INT,
    head_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (head_id) REFERENCES fee_head(head_id)
);
/* ================================
   custom_field_value
   ================================ */
CREATE TABLE custom_field_value (
    value_id INT AUTO_INCREMENT PRIMARY KEY,
    field_id INT,
    reference_id INT,            -- student_id / payment_id
    field_value TEXT,

    FOREIGN KEY (field_id) REFERENCES custom_field_master(field_id)
);
/* ================================
   custom_field_master
   ================================ */
CREATE TABLE custom_field_master (
    field_id INT AUTO_INCREMENT PRIMARY KEY,
    belongs_to VARCHAR(50),      -- student, payment, hostel, etc.
    field_type VARCHAR(50),      -- text, number, select, date
    field_name VARCHAR(100),
    grid_col INT DEFAULT 12,
    field_values TEXT,           -- for dropdown (comma separated)
    is_required TINYINT DEFAULT 0,
    show_on_table TINYINT DEFAULT 0,
    status TINYINT DEFAULT 1
);
CREATE TABLE courses (
    course_code VARCHAR(20) PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    approved_intake INT NOT NULL, 
    duration_years INT NOT NULL,    -- 3
    total_semesters INT NOT NULL,   -- 6
    year_of_established INT NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

CREATE TABLE academic_periods (
    academic_year VARCHAR(9) NOT NULL,   -- 2023-2024
    semester_number INT NOT NULL,         -- 1 to 6
    study_year INT NOT NULL,              -- 1,2,3
    semester_type ENUM('Odd','Even') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    PRIMARY KEY (academic_year, semester_number)
);

CREATE TABLE students (
    student_id VARCHAR(20) PRIMARY KEY,
    student_name VARCHAR(30) NOT NULL,
    dob DATE NOT NULL,

    mother_tongue VARCHAR(20),
    gender ENUM('Male', 'Female'),
    religion VARCHAR(20),
    community VARCHAR(20),
    caste VARCHAR(30),

    aadhar_no CHAR(12) UNIQUE,
    umis_no VARCHAR(20) UNIQUE,
    emis_no VARCHAR(20) UNIQUE,

    blood_group ENUM('A+','A-','B+','B-','O+','O-','AB+','AB-'),
    phone VARCHAR(15),
    email VARCHAR(30),
    address TEXT,
    student_photo VARCHAR(255),

    course_code VARCHAR(20) NOT NULL,
    date_of_joining DATE NOT NULL,
    batch_year VARCHAR(9) NOT NULL,     -- 2023-2026
    reg_no BIGINT NOT NULL UNIQUE,

    current_year INT DEFAULT 1,
    current_semester INT DEFAULT 1,

    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (course_code) REFERENCES courses(course_code)
);
CREATE TABLE hostel (
  hostel_id INT PRIMARY KEY,
  student_name VARCHAR(100),
  register_no VARCHAR(30),
  department VARCHAR(50),
  block VARCHAR(20),
  room_no VARCHAR(10),
  bed_no VARCHAR(10),
  fee_amount DECIMAL(10,2),
  fee_status VARCHAR(20)
);

CREATE TABLE transport (
  transport_id INT PRIMARY KEY,
  driver_name VARCHAR(100),
  driver_contact VARCHAR(15),
  route_name VARCHAR(100),
  start_point VARCHAR(100),
  end_point VARCHAR(100),
  vehicle_no VARCHAR(20) UNIQUE,
  capacity INT,
  status VARCHAR(20)
);
