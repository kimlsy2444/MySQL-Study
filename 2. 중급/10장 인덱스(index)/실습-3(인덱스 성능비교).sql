create database if not exists indexdb;
use indexdb;
-- 약 30만건의 데이터가 들어있다.
select count(*)
	from employees.employees;
    
-- 먼저 데이터를 복사해서 테이블을 생성해보자
-- 1. 인덱스가 없는 테이블
drop table if exists emp;
create table emp(
		select *
			from employees.employees
            order by rand() -- order by rand()는 순서를 임의로 가지고 있다.
);
select *
	from emp;
    
-- 2. 클러스터형인덱스가 없는 테이블
drop table if exists emp_c;
create table emp_c(
		select *
			from employees.employees
            order by rand() -- order by rand()는 순서를 임의로 가지고 있다.
);
select *
	from emp_c;
    
-- 3. 보조인덱스가 없는 테이블
drop table if exists emp_se;
create table emp_se(
		select *
			from employees.employees
            order by rand() -- order by rand()는 순서를 임의로 가지고 있다.
);
select *
	from emp_se;
    
-- 테이블별로 데이터가 잘 섞엿는지 확인해보자
-- 해당 pc마다 다다름
select *
	from emp 
    limit 5;
    
select *
	from emp_c 
    limit 5;
    
select *
	from emp_se
    limit 5;
    
show table status;

-- emp_c테이블에다가 PK 즉 클러스터형 인덱스를 추가해보자
alter table emp_c
	add constraint primary key(emp_no);

select *
	from emp_c;

-- emp_se테이블에 보조인덱스를 추가해보자
alter table emp_se
	add index idx_emp_no(emp_no);
    
select *
	from emp_se;

-- 다시 아래의 내용을 실행해보면 먼가 다르다
-- emp는 인덱스가 없으므로 그대로 나올 것이다.
-- emp_c는 클러스터형 인덱스가 추가 되었기 때문에 emp_no로 오름차순 정렬이
-- 이루어졌다.(루트페이지와 리프페이지를 만든다고 시간이 걸렸다.)
-- emp_se는 보조인덱스를 추가했으므로 역시 인덱스 페이지를 만드는데 데이터의 주소값을
-- 지니고 있는 부분만 정렬이 될 것이고 실제 데이터 변경이 없다.

select *
	from emp 
    limit 5;
    
select *
	from emp_c 
    limit 5;
    
select *
	from emp_se
    limit 5;
-- 만들어진 인덱스를 테이블에 적용하기

analyze table emp,emp_c,emp_se;

show index from emp; -- 인덱스 업음
show index from emp_c; -- PK즉 클러스터형 인덱스 있음
show index from emp_se; -- 보조 인덱스 있음

-- 클러스터형 인덱스는 데이터 그 자체가 인덱스를 내포하고 있다. (영어 사전개념)
-- index_length는 보조인덱스를 나타내는 것이다.
-- 하여,emp_se는 데이터크기가 잡혀져 있는 것을 확인할 수가 있다.
-- 인덱스도 역시 저장공간을 차지한다라고 했다.

show table status;
