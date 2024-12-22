-- 先单独执行创建数据库
CREATE DATABASE IF NOT EXISTS lab CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 确认数据库创建成功
SHOW DATABASES;

-- 然后再使用数据库并创建表
USE lab;

-- 学生表
CREATE TABLE IF NOT EXISTS student (
    student_id   INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)        NOT NULL,
    username     VARCHAR(50)        NOT NULL,
    password     VARCHAR(255)       NOT NULL COMMENT '建议使用加密存储',
    age          INT               CHECK (age > 0 AND age < 150),
    sex          TINYINT          COMMENT '1:男 2:女',
    tel          VARCHAR(20)       CHECK (tel REGEXP '^[0-9]{11}$'),
    role         TINYINT          DEFAULT 2 COMMENT '1:管理员 2:学生',
    created_at   TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY idx_username (username),
    KEY idx_role (role)
);

-- 实验室表
CREATE TABLE IF NOT EXISTS lab (
    lab_id             INT PRIMARY KEY AUTO_INCREMENT,
    lab_name           VARCHAR(100) NOT NULL,
    enable_reserve_num INT          NOT NULL COMMENT '可预约人数',
    reserved_num       INT          DEFAULT 0 COMMENT '已预约人数',
    lab_description    TEXT         COMMENT '实验室描述',
    status            TINYINT      DEFAULT 1 COMMENT '1:正常 0:维护中',
    created_at         TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CHECK (reserved_num <= enable_reserve_num),
    KEY idx_status (status)
);

-- 预约信息表
CREATE TABLE IF NOT EXISTS lab_reserve (
    reserve_id    INT PRIMARY KEY AUTO_INCREMENT,
    lab_id        INT          NOT NULL,
    lab_name      VARCHAR(100) NOT NULL,
    student_id    INT          NOT NULL,
    student_name  VARCHAR(50)  NOT NULL,
    reserve_num   VARCHAR(50)  NOT NULL COMMENT '预约编号',
    tel           VARCHAR(20),
    reserve_time  DATETIME     NOT NULL COMMENT '预约时间',
    status        TINYINT      DEFAULT 1 COMMENT '1:有效 0:已取消',
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (lab_id) REFERENCES lab (lab_id),
    FOREIGN KEY (student_id) REFERENCES student (student_id),
    UNIQUE KEY idx_reserve_num (reserve_num),
    KEY idx_reserve_time (reserve_time),
    KEY idx_status (status)
);

-- 插入管理员账号
INSERT INTO student (student_name, username, password, age, sex, tel, role) 
VALUES ('管理员', 'admin', 'admin123', 18, 1, '15812358887', 1); 