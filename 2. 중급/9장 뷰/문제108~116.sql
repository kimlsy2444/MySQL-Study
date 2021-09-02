-- mydb를 이용하자.
use mydb;
-- 문제108
-- emp테이블의 데이터를 가지고 emp_copy 테이블로 복사를 하되 empno, ename, 
-- deptno컬럼들만으로 구성된 테이블을 만들어보자.
drop table if exists emp_copy;
create table emp_copy(
	select empno,ename,deptno
		from emp
);

select *
	from emp_copy;

-- 문제109
-- 뷰를 만드는데 emp_copy를 이용하자. 뷰 이름은 emp_view30으로 한다.
-- 만드는 조건은 부서번호가 30인 데이터만 가지는 뷰를 만들어보자. 
-- 또한 만든 뷰를 이용해서 데이터를 조회하여 보자.
drop view if exists emp_view30;
create or replace view emp_view30
as 
	select *
		from emp_copy;
        
select *
	from emp_view30;

-- 문제110
-- emp_copy에 데이터를 저장을 emp_view30을 통해 추가해보자. 
-- 추가한 후 뷰와 원래 테이블의 데이터를 조회 해보자.
-- 1111,'aaaa', 30
insert into emp_view30 values(1111,'aaaa', 30);
select *
	from emp_copy;
    
select *
	from emp_view30;

-- 문제111
-- emp_copy테이블과 dept테이블을 inner join을 하는 emp_view_dept를 
-- 만들어보시오. 또한 그 뷰를 통해 조회를 해보시오
drop view if exists emp_view_dept;
create or replace view emp_view_dept
as 
	select *
		from emp_copy as E
        inner join  dept as D
        on E.deptno = D.deptno;

-- 문제112
-- 뷰의 사용의 장점은 보안에 유리하다고 했다. 그럼 emp테이블에서 공개되지 말아야 할 
-- 내용이 있습니다. 당연히 급여와 보너스가 되겠지요.
-- 이 컬럼을 제외하는 emp_view를 만들어보세요.
drop view if exists emp_view;
create or replace view emp_view
as 
	select EMPNO, ENAME, JOB,MGR,HIREADTA
		from emp;
	
select *
	from emp_view;

-- 문제113
-- 문제109번에서 만든 emp_view30을 수정 해보자. 기존의 뷰에 급여 컬럼과 
-- 보너스 컬럼을 추가해서 emp_view30을 만드시오.

alter view emp_view30
as 
	select  empno, ename, deptno, sal, comm
		from emp;


-- 문제114
-- emp_view30 뷰를 이용하여 급여가 600이상인 사람에 대해서
-- 부서번호를 20으로 변경해보시오
update  emp_view30
	set deptno = 20
    where sal >= 600;

select *
	from emp_view30;
-- 문제115
-- 부서별 최대 급여와 최소 급여를 출력하는 sal_max_min_view를 emp, dept테이블을
-- 이용하여 만들어보시오.
select *
	from emp;
select *
	from dept;

drop view if exists sal_max_min_view;
create or replace view sal_max_min_view
as 
	select E.deptno,D.dename,max(sal) ,min(sal)
		from emp as E
        inner join dept as D
        on E.deptno = D.deptno
        group by deptno
        order by deptno;

	select *
		from sal_max_min_view;

-- 문제116
-- 지금까지 만든 뷰를 다 제거해보시오.
drop view if exists sal_max_min_view;
drop view if exists emp_view30;
drop view if exists emp_view;
drop view if exists emp_view_dept;
