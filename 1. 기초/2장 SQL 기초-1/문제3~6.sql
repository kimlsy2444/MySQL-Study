#문제 3,4
CREATE TABLE EMP(

    deptNo int,
    deptName char(10),
    jop char(5),
    sal int,
    PRIMARY KEY (deptNo)
);

INSERT INTO EMP VALUES  (10,'인사팀','사원',250),
						(20,'재무팀','대리',300),
						(30,'법무팀','과장',350),
						(40,'영업팀','사원',250),
						(50,'설계팀','부장',500);
delete from EMP;

desc EMP;

SELECT *
FROM EMP;

#문제5
UPDATE emp
	set sal =180
	where jop = '사원';
#문제6

delete from emp
WHERE deptno = 30;

--  추출된 데이터를 엑셀 데이터로 내보내기를 하기 위해서 export클릭을 하면
-- .csv내보내기를 하고 아래 2가지 방법을 이용하여 글자깨짐을 방지하도록 한다.

-- 1. 엑셀 프로그램을 열고 데이터 텍스트 클릭 가져올 csv파일을 
-- 가져오면 가져오는 형식이 뜨는데 띄우고 쉼표로 구분을 해주면 된다.
-- 2. 저장된 .csv파일을 메모장으로 열어서 다른이름 저정 저장시 인코딩 ansi로 설정후 저장

-- 엑셀데이터를 테이블로 가져오기를 하고자 한다면 Mysql은 UTF-8형태로 지원을 하니
-- csv파일로 가져올때는 반드시 UTF-8로 가져와야 파일이 깨지지 않는다.