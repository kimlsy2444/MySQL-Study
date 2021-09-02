-- 문제 15				
-- 만들어놓은 mydb에 아래와 같이 테이블을 만들어라.				
-- 테이블명 : emp(기존에 존재하는것은 drop합니다.)				
-- 열이름		데이터형식		NULL허용		PK	기타
-- EMPNO 	int				x		O	
-- ENAME 	varchar(20)		x		x	
-- JOB   	varchar(8)		x		x	
-- MGR  	varchar(10)		O		x	
-- HIREDATE date			x		x	
-- SAL 		int				x		x	
-- COMM 	int				O		x	
-- DEPTNO 	int				x		x	FK 설정
use mydb;
drop table if exists emp;
create table emp(
	EMPNO int not null primary key,
    ENAME varchar(20) not null,
    JOB varchar(8)	not null,
    MGR varchar(10),
    HIREDATE date not null,	
    SAL int not null,
    COMM int null,	
    DEPTNO int not null,
    foreign key(deptno) references dept(deptno)
);
select * 
  from dept;

-- 문제16				
-- 만들어진 emp테이블에 아래의 데이터를 삽입하라				
-- 1001, '김사랑', '사원', 1013, '2007-03-01', 300, NULL, 20				
-- 1002, '한예슬', '대리', 1005, '2008-10-01', 250,  80, 30				
-- 1003, '오지호', '과장', 1005,'2005-02-10', 500,  100, 30				
-- 1004, '이병헌', '부장', 1008, '2003-09-02', 600, NULL, 20				
-- 1005, '신동협', '과장', 1005, '2010-02-09', 450,  200, 30				
-- 1006, '장동건', '부장', 1008, '2003-10-09', 480, NULL, 30				
-- 1007, '이문세', '부장', 1008, '2004-01-08', 520, NULL, 10				
-- 1008, '감우성', '차장', 1003, '2004-03-08', 500,  0, 30				
-- 1009, '안성기', '사장', NULL, '1996-10-04', 1000, NULL, 20				
-- 1010, '이병헌', '과장', 1003, '2005-04-07', 500, NULL, 10				
-- 1011, '조향기', '사원', 1007, '2007-03-01', 280, NULL, 30				
-- 1012, '강혜정', '사원', 1006, '2007-08-09', 300, NULL, 20				
-- 1013, '박중훈', '부장', 1003, '2002-10-09', 560, NULL, 20				
-- 1014, '조인성', '사원', 1006, '2007-11-09', 250, NULL, 10				
insert into emp values (1001, '김사랑', '사원', 1013, '2007-03-01', 300, null, 20);
insert into emp values (1002, '한예슬', '대리', 1005, '2008-10-01', 250, 80, 30);
insert into emp values (1003, '오지호', '과장', 1005, '2005-02-10', 500, 100, 30);
insert into emp values (1004, '이병헌', '부장', 1008, '2003-09-02', 600, null, 20);
insert into emp values (1005, '신동협', '과장', 1005, '2010-02-09', 450, 200, 30);
insert into emp values (1006, '장동건', '부장', 1008, '2003-10-09', 480, null, 30);
insert into emp values (1007, '이문세', '부장', 1008, '2004-01-08', 520, null, 10);
insert into emp values (1008, '감우성', '차장', 1003, '2004-03-08', 500, 0, 30);	
insert into emp values (1009, '안성기', '사장', null, '1996-10-04', 1000, null, 20);
insert into emp values (1010, '이병헌', '과장', 1003, '2005-04-07', 500, null, 10);
insert into emp values (1011, '조향기', '사원', 1007, '2007-03-01', 280, null, 30);
insert into emp values (1012, '강혜정', '사원', 1006, '2007-08-09', 300, null, 20);
insert into emp values (1013, '박중훈', '부장', 1003, '2002-10-09', 560, null, 20);
insert into emp values (1014, '조인성', '사원', 1016, '2007-11-09', 250, null, 10);		
select *
  from emp;	
-- 문제17				
-- 만들어 놓은 mydb에 아래와 같이 테이블을 만들어라.				
-- 테이블명 : salgrade				
-- 열이름	   데이터형식	NULL허용	PK	기타
-- GRADE 	int	    x	    O	자동증가
-- LOSAL 	int	    x		
-- HISAL 	int	    x		
drop table if exists salgrade; 	
create table salgrade(
	grade int not null auto_increment primary key,
    losal int not null,
    hisal int not null
);			
 				
-- 문제18				
-- salgrader테이블에 아래와 같이 데이터를 삽입하라				
-- null, 700, 1200				
-- null, 1200, 1400				
-- null, 1700, 2000				
-- null, 2000, 3000				
-- null, 3000, 9999				
set @@auto_increment_increment = 1;
insert into salgrade values(null, 700, 1200);
insert into salgrade values(null, 1200, 1400);
insert into salgrade values(null, 1700, 2000);
insert into salgrade values(null, 2000, 3000);
insert into salgrade values(null, 3000, 9999);
truncate salgrade;
select *
  from salgrade;
-- 문제19
-- dept테이블을 이용하여 사원의 이름과 급여와 입사일자만 출력하시오.
select ename, sal, hiredate
  from emp
 where deptno = any(select deptno 
					  from dept	);
                      
-- 문제20
-- dept테이블의 컬럼 중 deptno를 “부서번호”,  dname을 “부서명”으로 출력하는 SQL문을 작성하시오.
select deptno as '부서번호', dname as '부서명'
  from dept;

-- 문제21
-- emp테이블의 직급이 중복되지 않고 한 번씩 나열하는 SQL문 작성하시오.
select distinct job
  from emp;

-- 문제22
-- emp테이블을 이용하여 급여가 300 이하인 사원의 사원번호, 사원 이름, 급여를 출력하시오.
select empno, ename, sal
  from emp
 where sal <= 300;

-- 문제23
-- emp테이블을 이용하여 이름이 '오지호'인 사원의 사원번호, 사원명, 급여를 출력하세요
select empno, ename, sal
  from emp
 where ename = '오지호';
-- 문제24
-- 급여가 250이거나 300이거나 500인 사원들의 사원 번호와 사원명과 급여를 출력하세요.
-- 단, 2가지 방법으로 다 표현하세요. in()이용과 관계연산자를 이용하는 방법으로 하세요
select empno, ename, sal
  from emp
 where sal in(250,300,500);

select empno, ename, sal
  from emp
 where sal = 250
    or sal = 300
    or sal = 500;

-- 문제25
-- 급여가 250이거나 300이거나 500도 아닌 사원들을 출력하세요
-- 단, 2가지 방법으로 다 표현하세요. not in()이용과 관계연산자를 이용하는 방법으로 하세요
select empno, ename, sal
  from emp
 where sal not in(250,300,500);

select empno, ename, sal
  from emp
 where sal != 250
   and sal != 300
   and sal != 500;
-- 문제26
-- 사원들 중에서 이름이 '김'으로 시작하는 사람이거나 이름 중에 '기'를 포함하는 사원의 사원번호와 사원이름을 출력하세요
select empno, ename
  from emp
 where ename like '김%'
    or ename like '%기%'; 

-- 문제27
-- 상관이 없는 사원(사장이 되겠지요!)을 출력하세요.
select *
  from emp
 where mgr is null;