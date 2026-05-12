create database StudentManagement;
use StudentManagement;

create table students (
	student_id varchar(5) primary key,
    full_name varchar(50) not null,
    total_debt decimal(10,2) default 0
);

create table subjects (
	subject_id varchar(5) primary key,
    subject_name varchar(50) not null,
    credits int check (credits > 0 )
);

create table grades (
	student_id varchar(5),
    foreign key(student_id) references students(student_id),
    subject_id varchar(5),
    foreign key(subject_id) references subjects(subject_id),
    score decimal(4,2) check (score between 0 and 10)
);

create table grade_log (
	log_id int primary key auto_increment,
    student_id varchar(5),
    foreign key (student_id) references students(student_id),
    old_score decimal(4,2),
    new_score decimal(4,2),
    change_date datetime default current_timestamp
);

insert into students(student_id, full_name, total_debt) values 
('S0001', 'Nguyen Van A', 20000),
('S0002', 'Le Van B', 300000),
('S0003', 'Pham Thi C', 400000),
('S0004', 'Nguyen Van D', 360000);

insert into subjects(subject_id, subject_name, credits) values  
('SB001', 'Giai tich', 3),
('SB002', 'Toan cao cap', 3),
('SB003', 'Lap trinh voi Python', 4),
('SB004', 'Co so du lieu', 3);

insert into grades(student_id, subject_id, score) values
('S0001', 'SB001', 9),
('S0002', 'SB002', 7),
('S0003', 'SB003', 6),
('S0004', 'SB004', 8);

insert into grade_log(log_id, student_id, old_score, new_score, change_date) values 
(1, 'S0001', 9, 10, '2026-05-15'),
(2, 'S0002', 7, 8, '2026-06-16'),
(3, 'S0003', 6, 7, '2026-07-13'),
(4, 'S0004', 8, 7, '2026-04-19');

-- cau 1
DELIMITER $$
create trigger tg_check_score
before insert on grades
for each row
begin 
	if NEW.score < 0 then set NEW.score = 0;
	else if NEW.score > 10 then set NEW.score = 10;
	end if;
end $$
DELIMITER ;

-- cau 2
start transaction;
insert into students(student_id, full_name, total_debt) 
values ('SV02','Ha Bich Ngoc', 0);
update students 
set total_debt = 5000000
where student_id =  'SV02';
commit

--