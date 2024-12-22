CREATE DATABASE IF NOT EXISTS lab;

USE lab;

-- 学生表
CREATE TABLE IF NOT EXISTS student
(
    student_id   INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)        NOT NULL,
    username     VARCHAR(50) UNIQUE NOT NULL,
    password     VARCHAR(50)        NOT NULL,
    age          INT,
    sex          INT COMMENT '1:男 2:女',
    tel          VARCHAR(20),
    role         INT COMMENT '1:管理员 2:学生'
);

-- 插入管理员账号
INSERT INTO student (student_id, student_name, username, password, age, sex, tel, role) VALUES (1, '管理员', 'admin', 'admin123', 18, 1, '15812358887', 1);

-- 实验室表
CREATE TABLE IF NOT EXISTS lab
(
    lab_id             INT PRIMARY KEY AUTO_INCREMENT,
    lab_name           VARCHAR(100) NOT NULL,
    enable_reserve_num INT          NOT NULL COMMENT '可预约人数',
    reserved_num       INT DEFAULT 0 COMMENT '已预约人数',
    lab_description    TEXT COMMENT '实验室描述'
);

-- 预约信息表
CREATE TABLE IF NOT EXISTS lab_reserve
(
    reserve_id   INT PRIMARY KEY AUTO_INCREMENT,
    lab_id       INT          NOT NULL,
    lab_name     VARCHAR(100) NOT NULL,
    student_id   INT          NOT NULL,
    student_name VARCHAR(50)  NOT NULL,
    reserve_num  VARCHAR(50)  NOT NULL COMMENT '预约编号',
    tel          VARCHAR(20),
    reserve_time DATETIME     NOT NULL COMMENT '预约时间',
    create_time  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lab_id) REFERENCES lab (lab_id),
    FOREIGN KEY (student_id) REFERENCES student (student_id)
);