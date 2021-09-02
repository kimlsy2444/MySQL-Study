-- 문제101			
-- 다음 1개의 테이블을 생성하세요(데이터베이스는 mydb3를 생성하여 사용하시오)			
-- 테이블명 : emp03			
-- 열이름		데이터형식		NULL허용	제약조건
-- empno	int		
-- ename	varchar(20)			x	
-- job		varchar(20)		
-- deptno	int	
drop database if exists mydb3;
create database mydb3;
use mydb3;

drop table if exists emp03;
create table emp03(
 empno	int	,
 ename	varchar(20),	
 job	varchar(20),
 deptno	int	
);

-- 문제102			
-- emp03테이블에 empno컬럼에 제약조건 unique를 추가하시오.
alter table emp03
	add constraint empno_unique
	unique(empno);

-- 문제103			
-- 아래 데이터를 emp03에 삽입하시오			
-- 1000, '김주화', '사원', 30			
-- 1000, '이길동', '사원', 40	
insert into emp03 values(1000, '김주화', '사원', 30); 
insert into emp03 values(1000, '이길동', '사원', 40); 

-- 그러나 이길동을 입력할때 에러가 난다.			
-- 에러 이유 : empno가 unique제약조건을 지니고 있기 때문에 			
-- 해결방법은 2가지이다.			
-- 첫 번째 해결방법 : empno에 들어가는 데이터를 중복되지 않게 수정을 한다.			
-- 두 번째 해결방법 : unique제약 조건을 삭제한다.			
 	 			

-- 문제104			
-- 첫 번째 해결방법을 삽입쿼리로 해결하여 작성하시오
insert into emp03 values (1001, '이길동', '사원', 40);		 			
select * from emp03;

-- 문제105			
-- 두 번째 해결방법도 역시 alter table을 이용하여 해결하여 작성하시오
alter table emp03
drop index empno_unique;

delete from emp03;

-- 문제106			
-- emp03테이블에 아래 컬럼을 추가하고 default 제약조건을 걸어 입력
-- 값이 없으면 서울로 나타내게 하시오			
-- location varchar(13)	

alter table emp03
	add location varchar(13) default  '서울';

-- 문제107			
-- 아래 데이터를 emp03에 삽입하고 조회를 하여 location이 서울로 나오는지
-- 직접 확인하시오.			
-- 1003, '신은비', '사원', 30	
insert into emp03 values (1003, '신은비', '사원', 30	);	
select *
	from emp03;