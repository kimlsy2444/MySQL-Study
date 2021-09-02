-- mydb데이터 베이스를 이용
-- 문제28
-- emp테이블에서 급여가 500이 초과되는 사원 중을 출력하는 쿼리문을 작성하시오.

use mydb;
select *
	from emp
	where sal > 500;
    
-- 문제29
-- 서브쿼리를 사용하여 테이블 emp_copy에 emp테이블의 모든 레코드를 추가하는 쿼리문을  작성하시오.
--     1단계 : emp 테이블 조회(건수 확인)
--     2단계 : emp_copy테이블 만들기(emp와 동일)
--     3단계 : 레코드 복사하기
--     4단계 : emp_copy테이블 조회(건수확인)

select count(*)
	from emp;
drop table if exists emp_copy;
create table emp_copy(
	select *
		from emp
);

select *
	from emp_copy;

select count(*)
	from emp_copy;

-- 문제30
-- 서브쿼리를 이용하여 emp_copy 테이블에 저장된 사원 정보 중 과장들의 최소 급여보다 많은 급여를 받는 
-- 사원들의 이름과 급여와 직급을 출력하되, 과장의 출력하지 않는 SQL 문을 완성하시오.

select ENAME, SAL, JOB	
	from emp_copy
    where sal > (select min(sal) from emp_copy where job='과장')
	and job != '과장';

-- 문제31
-- emp_copy테이블에 저장된 사원 정보 중 인천에 위치한 부서에 소속된 사원들의 급여를 100인상하는 
-- SQL 문을 작성하시오(서브쿼리 작성시 dept테이블 이용)

select *
	from  emp_copy
    where deptno = 20;

update emp_copy
	set sal = sal +100
	where deptno = (select deptno from dept where  loc ='인천');


-- 문제32
-- emp_copy테이블에서 경리부에 소속된 사원들만 삭제하는 SQL문을 작성하시오.(서브쿼리 dept이용)

select *
	from  emp_copy;

delete from emp_copy
	where deptno =  (select deptno from dept where dename ='경리부');
    
-- 문제33
-- emp를 이용하여 서브쿼리를 이용해서 ‘이문세’와 동일한 직급을 가진 사원을 출력하는 
-- SQL문을 완성하시오.

select *
	from emp
    where ename ='이문세';
    
select *
	from emp
    where job = (select job from emp where ename = '이문세');

-- 문제34
-- 서브쿼리를 이용하여 ‘이문세’의 급여와 동일하거나 더 많이 받는 사원명과 급여를 
-- 출력하는 SQL문을 작성하시오.

select *
	from emp
    where ename ='이문세';
    
select *
	from emp
    where sal >= (select sal from emp where ename = '이문세');
    
-- 문제35
-- 서브쿼리를 이용하여 ‘인천’에서 근무하는 사원의 이름, 부서 번호를 출력하는 SQL문을 작성하시오.

select *
	from dept;

select ename, hireadta
	from emp
    where deptno = (select deptno from dept where loc = '인천');


-- 다중행 서브쿼리
-- 문제36
-- 급여가 500을 초과하는 사원과 같은 부서에 근무하는 사원의 이름, 월급, 부서번호를 출력하시오
-- (서브쿼리에 중복된 값이 나올 수 있으니 distinct 를 이용하자)

select ename, sal, deptno
	from emp 
    where deptno in (select distinct deptno from emp where sal>500);
    
-- 문제37
-- 서브쿼리를 이용하여 30번 부서의 최대급여보다 많은 급여를 받는 사원의 이름과 월급을 출력하시오

select ename, sal 
	from emp
    where (select max(sal) from emp where deptno = 30)< sal;
    
-- 문제38
-- 30번 부서의 최소급여보다 많은 급여를 받는 사원의 이름과 월급을 출력하시오

select ename, sal 
	from emp
    where (select min(sal) from emp where deptno = 30) < sal;
    
    
-- 문제39
-- emp테이블을 이용하여 급여 최고액, 최저액, 총액 및 평균 급여 출력하시오.
  
  select max(sal) as '최고액', min(sal) as '최저액', sum(sal) as '총액', avg(sal) as'평균'
	from emp;


    

    



   

	
        
            
	
            
    
		
    
    



  