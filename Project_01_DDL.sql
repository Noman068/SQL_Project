
create database visit_management;
go
use visit_management;
go


create table roles (
    role_id int identity(1,1) primary key,
    role_name varchar(50) not null unique
);


create table users (
    user_id int identity(1,1) primary key,
    username varchar(50) not null unique,
    password_hash varchar(255) not null,
    role_id int not null,
    foreign key (role_id) references roles(role_id)
);


create table patients (
    patient_id int identity(1,1) primary key,
    patient_name varchar(100) not null,
    phone varchar(20) null
);


create table doctors (
    doctor_id int identity(1,1) primary key,
    doctor_name varchar(100) not null,
    specialization varchar(100) null
);


create table visit_types (
    visit_type_id int identity(1,1) primary key,
    type_name varchar(50) not null unique
);


create table fee_schedule (
    visit_type_id int not null primary key,
    fee_amount decimal(10,2) not null,
    foreign key (visit_type_id) references visit_types(visit_type_id)
);


create table visits (
    visit_id int identity(1,1) primary key,
    patient_id int not null,
    doctor_id int not null,
    visit_type_id int not null,
    visit_datetime datetime not null,
    duration_minutes int not null,
    fee decimal(10,2) not null,
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id),
    foreign key (visit_type_id) references visit_types(visit_type_id)
);


create table activity_log (
    log_id int identity(1,1) primary key,
    user_id int not null,
    action_description varchar(255) not null,
    action_time datetime not null default getdate(),
    status varchar(50) not null,
    foreign key (user_id) references users(user_id)
);
