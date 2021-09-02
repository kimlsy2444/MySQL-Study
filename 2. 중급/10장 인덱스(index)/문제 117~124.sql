use mydb;
-- 문제 117 
-- emp 테이블 이용 emp_index 테이블 만들기
drop table if exists emp_index;
create table emp_index(
	select *
		from emp
);
-- 118
-- 제약조건 확인 코드 작성
show index from emp_index;

-- 119
-- emp_index에서 empno에 pk제약조건 추가
-- PK_emp_index_pk 로 지정
-- 이렇게 만든 인덱스의 명칭은? : (클러스터형 인덱스)
alter table emp_index
	add constraint 
    primary key PK_emp_index_pk(empno);
-- 120
-- ename에 unique 제약 조건을 걸어 보조 인덱스 생성
-- 인덱스명 UK_emp_index_name
-- 이름이 곂치면 다른이름으로 수정
alter table emp_index
	add constraint UK_emp_index_name
    unique key(ename);
select *
	from emp_index;

delete from emp_index
where empno = 1010;
   
-- 121 
-- 테이블에 인덱스 적용시키는 코드를 작성하고 인덱스 조회해라

analyze table emp_index;
show index from emp_index;

-- 122
-- job컬럼에 unique제약 조건을 걸어 보조인덱승 생성
-- 인덱스면 UK_emp_index_job (생성이 안될것이다)
-- 그이유? : job 에 중복 되는 데이터가 있기 때문 유니크 생성조건이 성립안됨
alter table emp_index
	add constraint UK_emp_index_job
    unique key(job);

-- 123 
-- 인덱스 전부 삭제하기
select *
	from emp_index;
    
drop index UK_emp_index_name on emp_index;

alter table emp_index
	drop primary key;
    
-- 124 
-- 인덱스를 언제 사용해야 하는가?
-- 아는데로 서술하시오

-- 1. where절에 자주 사용되는 열에 인덱스 사용
-- 2. 데이터의 중복도가 없는 곳에 인덱스 생성
-- 3. 조인에 자주 사용되는 열의 경우 인덱스 생성


