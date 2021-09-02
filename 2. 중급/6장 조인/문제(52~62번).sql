#mydb를 이용합니다. 
use mydb;
#문제 52
#경리부 부서 소속사원의 이름과 입사일을 출력하시오.(emp, dept테이블 활용.)
select *
	from emp;
select *
	from dept;
select E.ename as '이름', E.hireadta as '전화번호'
	from emp as E
    inner join dept as D
    on D.deptno = E.deptno
    where D.dename = '경리부';

#문제 53
#직급이 과장인 사원의 이름, 부서명을 출력하시오.
select E.job as '직급', E.ename as '이름',D.dename as '부서명'
	from emp as E
    inner join dept as D
    on D.deptno = E.deptno
    where E.job = '과장';


#문제 54
#사원이름과 부서이름을 출력하세요.
select E.ename as '이름',D.dename as '부서명'
	from emp as E
    inner join dept as D
    on D.deptno = E.deptno
    order by E.ename;

#문제 55
#인천에서 근무하는 사원의 이름과 급여를 출력하시오
select E.ename as '인천에서 근무하는 사원',E.sal as '급여'
	from emp as E
    inner join dept as D
    on D.deptno = E.deptno
    where D.loc='인천'
    order by E.ename;


#문제 56
#다음 테이블을 만들어라
#테이블명 : membertbl
# 열이름		데이터형식		NULL허용	PK
#  id		int				x	
# name		varchar(20)		x	
# tel		varchar(13)		x	
# address	varchar(50)		x	

drop table if exists membertbl;

create table membertbl(
	id int not null,
    name varchar(20) not null,
    tel varchar(13) not null,
    address varchar(50) not null
);
select *
  from membertbl;

#문제 57
#아래와 같이 데이터를 삽입하라
# 1, '김우성', '010-6298-0394', '송파구 잠실2동'						
# 2, '김태희', '010-9596-2048', '강동구 명일동'						
# 3, '하지원', '010-0859-3948', '강동구 천호동'						
# 4, '유재석', '010-3045-3049', '강남구 서초동'
insert into membertbl values (1, '김우성', '010-6298-0394', '송파구 잠실2동'),
(2, '김태희', '010-9596-2048', '강동구 명일동'),
(3, '하지원', '010-0859-3948', '강동구 천호동'),
(4, '유재석', '010-3045-3049', '강남구 서초동');


#문제 58
#다음 테이블을 만들어라
#테이블명 : worker
#	열이름	데이터형식		NULL허용	PK
#	number 		int			x	
#	irum	varchar(20)		x	
#	hp		varchar(13)		x	
#	location 	varchar(50)	x	
drop table if exists worker;
create table worker(
	number int not null,
    irum varchar(20) not null,
    hp varchar(13) not null,
    location varchar(50) not null
);
select *
  from worker;
						
#문제 59
#아래와 같이 데이터를 삽입하라 
# 2, '김태희', '010-9596-2048', '강동구 명일동'						
# 3, '하지원', '010-0859-3948', '강동구 천호동'						
# 4, '유재석', '010-3045-3049', '강남구 서초동'						
# 5, '강호동', '010-2049-5069', '송파구 석촌동'						
# 10,'안성기', '010-3050-3049', '강남구 압구정동'						
insert into worker values (2, '김태희', '010-9596-2048', '강동구 명일동'),
(3, '하지원', '010-0859-3948', '강동구 천호동'),
(4, '유재석', '010-3045-3049', '강남구 서초동'),
(5, '강호동', '010-2049-5069', '송파구 석촌동'),
(10,'안성기', '010-3050-3049', '강남구 압구정동');


#문제 60
#위의 두 테이블의 내용을 다 출력하시오.
select * 
  from  membertbl
union all
select * 
  from worker;
  

#문제 61
#위의 두 테이블의 내용을 중복된 것을 제외하고 다 출력하시오
select * 
  from membertbl
union
select * 
  from worker;

#문제 62
#위의 두 테이블의 카티션 곱을 구하시오.
select count(*)
	from membertbl
    cross join worker;