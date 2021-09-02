use sqldb;
-- 내부조인은 조건에 해당하는 행만 리턴하는 조인이였다.
-- 외부조인은 구매기록이 없는 고객까지 다출력을 하고 싶다면
-- left outer join을 사용하면 된다.
-- 다시말해, lefr outer join을 기준으로 해서 왼쪽 테이블 즉
-- usertbl의 모든 데이터를 다 출력하라른 것이다 이것이 바로
-- left outer join이다.

select *
	from buytbl;
    
select *
	from usertbl;

-- 구매내역이 없는 회원정보까지 다 출력하는 쿼리문
select U.userid, U.username, B.prodname, U.addr,
	   concat(U.mobile1, U.mobile2) as '연락처'
		from usertbl as U
        left outer join buytbl as B 
        on U.userid = B.userid
        order by U.userid;
	
-- right outer join은 left outer join에서 테이블의 자리만
-- 바꿔주면 되는 것이다.
select U.userid, U.username, B.prodname, U.addr,
	   concat(U.mobile1, U.mobile2) as '연락처'
		from buytbl as B
        right outer join usertbl as U
        on U.userid = B.userid
        order by U.userid;
        
-- outer join을 이용하여 구매내역이 없는 고객리스트 출력해보자
select U.userid, U.username, B.prodname, U.addr,
	   concat(U.mobile1, U.mobile2) as '연락처'
		from buytbl as B
        right outer join usertbl as U
        on U.userid = B.userid
        where B.prodname is null
        order by U.userid;
        
        
-- 아래 3개의 테이블을 이용하여 학생중에 동아리에 가입하지 않은 
-- 사람만 추출해내는 쿼리문을 작성해보자.
select *
	from stdtbl;
    
select *
	from stdclubtbl;

select *
	from clubtbl;
    
select S.stdname, S.addr, C.clubname, C.roomno
	from stdtbl as S
    left outer join stdclubtbl as SC
    on S.stdname = SC.stdname
   left outer join clubtbl as C
   on SC.clubname = C.clubname
   where C.clubname is null
   order by S.stdname;
   
-- 아래 쿼리는 left outer join right outer join을 이용해서 3개의 테이블을 
-- 엮어서 학생이 한명도 가입하지 않은 동아리를 추출하는 쿼리문이 된다.
-- 왜 right outer join을 사용했을까? 동아리명을 다 출력해야 되니깐.
select C.clubname, C.roomno, S.stdname,S.addr
	from stdtbl as S
    left outer join stdclubtbl as SC
    on S.stdname = SC.stdname
    right outer join clubtbl as C
    on SC.clubname = C.clubname
    where S.stdname is null
    order by C.clubname;
    
    
-- 그런데 뒤의 두 개의 결과값을 동시에 보고싶을때는 어떻게 할까?
-- 두 쿼리의 결과값을 연결해주는 키워드가 필요하다
-- 그게바로 union이다 union은 합집합이다. 중복은 제거한다.

select S.stdname, S.addr, C.clubname, C.roomno
	from stdtbl as S
    left outer join stdclubtbl as SC
    on S.stdname = SC.stdname
   left outer join clubtbl as C
   on SC.clubname = C.clubname
   where C.clubname is null
union
select C.clubname, C.roomno, S.stdname,S.addr
	from stdtbl as S
    left outer join stdclubtbl as SC
    on S.stdname = SC.stdname
    right outer join clubtbl as C
    on SC.clubname = C.clubname
    where S.stdname is null;

-- union은 중복제거
select *
	from stdtbl
union 
select *
	from stdtbl;

-- unionall은 중복제거를 하지 않는다.
select *
	from stdtbl
union all
select *
	from stdtbl;
    
-- 상호 조인에 대해서 알아보자
-- cross join의 결과 개수는 두 테이블의 행의 개수를 곱하여 나온 개수가 된다.
-- 카티션곱(Cartesain Product)이라고 부른다. 통상적으로 대용량데이터를 생성할때 사용한다.
-- buytbl : 12개의 행, usertbl : 10개의 행
select *
	from buytbl
    cross join usertbl;

use employees;
-- employees : 300,024
select *
	from employees;

-- employees : 443,308
select *
	from titles;  

-- 약 1330억개의 행이 나온다.
select count(*)
	from employees
    cross join titles;
    
-- 컴뻗는다. ㄴㄴ 
-- select *
-- 	from employees
--     cross join titles;

-- 셀프조인 테이블 하나로 두번 이상 엮어서 결과값을 추출해내는 방법이다.
-- 셀프조인은 주로 테이블이 계층적인 구조를 수평적인 관계로 바꾸는 역할을 해준다.

use sqldb;
drop table if exists emptbl;
create table emptbl(
	emp char(3) not null primary key,
    manager char(3),
    emptel varchar(8)
);

insert into emptbl values ('나사장', null, '0000'),
('김재무', '나사장', '2222'),('김부장', '김재무', '2222-1'),('이부장', '김재무', '2222-2'),
('우대리', '이부장', '2222-2-1'),('지사원', '이부장', '2222-2-2'),('이영업', '나사장', '1111'),
('한과장', '이영업', '1111-1'),('최정보', '나사장', '3333'),('윤차장', '최정보', '3333-1'),
('이주임', '윤차장', '3333-1-1');

select *
	from emptbl
    where emp ='이부장';

-- 아래코드는 우대리의 상관인 이부장의 전화번호를 추출해내는 쿼리문이다.
-- emptbl을 마치 2개가 있는 것처럼 만들어서 분리해서 생각하고 조건을 설정할때
--  manager필드와 emp 필드가 같고
-- 개념이 조금 어렵다.
select A.emp as '부하직원', B.emp as '직속상관', B.emptel
	from emptbl as A
    inner join emptbl as B
    on A.manager = B.emp
    where A.emp='우대리';
    
-- not in 과 in을 알아보자. 
-- non in 서브 쿼리나 데이터값을 제외할 때 사용되는 것이고
-- in은 포함할때 사용하는 것이다.
-- 핸드폰 번호가 없는 사람들을 제외하고 출력하는 쿼리문을 만들어 보자

-- not in
select username,concat(mobile1,mobile2) as '연락처'
	from usertbl
    where username not in(
		select username
        from usertbl
        where mobile1 is null
    );
-- in
select username,concat(mobile1,mobile2) as '연락처'
	from usertbl
    where username in(
		select username
        from usertbl
        where mobile1 is null
    );
