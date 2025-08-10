

use visit_management;
go


insert into roles (role_name) values ('admin'), ('receptionist');


insert into users (username, password_hash, role_id)
values
('admin', 'admin123', 1),
('recept', 'recept123', 2);


insert into patients (patient_name, phone)
values
('john doe', '123456789'),
('jane smith', '987654321');


insert into doctors (doctor_name, specialization)
values
('dr. adams', 'cardiology'),
('dr. baker', 'general medicine');


insert into visit_types (type_name) values ('consultation'), ('follow-up'), ('emergency');


insert into fee_schedule (visit_type_id, fee_amount)
values
(1, 500.00),
(2, 300.00),
(3, 1000.00);


insert into visits (patient_id, doctor_id, visit_type_id, visit_datetime, duration_minutes, fee)
values
(1, 1, 1, '2025-08-09 09:00:00', 30, 500.00),
(2, 2, 3, '2025-08-09 10:00:00', 45, 1000.00);


insert into activity_log (user_id, action_description, status)
values
(1, 'added new visit for john doe', 'success'),
(2, 'searched visits for dr. baker', 'success');
