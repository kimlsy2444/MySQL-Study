#문제 1,2
CREATE DATABASE mydb;

USE mydb;

CREATE TABLE DEPT(
	
    DEPTNO int not null,
	DENAME varchar(14) not null,
    LOC varchar(30),
    PRIMARY KEY(DEPTNO)
);
INSERT INTO DEPT VALUES(10,'경리부','서울');
INSERT INTO DEPT VALUES(20,'인사부','인천');
INSERT INTO DEPT VALUES(30,'영업부','용인');
INSERT INTO DEPT VALUES(40,'전산부','수원');

drop table DEPT;

desc DEPT;

SELECT *
FROM DEPT;