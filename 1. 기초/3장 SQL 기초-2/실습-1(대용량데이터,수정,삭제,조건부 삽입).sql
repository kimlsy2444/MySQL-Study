select *
	from employees.employees;
    
drop table if exists testtbl4;
create table testtbl4(
	id int,
    fname varchar(20),
	lname varchar(20)
);

-- testtbl4에 대용량 데이터를 바로 삽입하는 코드

insert into testtbl4
	select emp_no, first_name, last_name
		from employees.employees;
 
 select *
	from testtbl4;

-- 테이블을 만들면서 바로 select를 이용하는 것이다.

drop table if exists testtbl5;
create table testtbl5(
		select emp_no, first_name, last_name
		from employees.employees
);

 select *
	from testtbl5;

-- 이제는 update구문을 대해서 알아보도록 하자
-- update ...set ..where형태로 쓴다.
-- 만약 where(조건절)이 없다면 ,모든 데이터를 수정해버린다. 현업에서도 상당한 실수가 잦다.
-- 주의

select *
	from testtbl4
    where fname ='Kyoichi';

-- update를 할 때는 먼저 수정할 대상을 select문으로 확인하고 복사해서 붙여넣고
-- updaate문으로 다시 수정을 해서 아래와 같이 사용을 하면 안전하다.
update testtbl4
	set lname ='없음'
    where fname ='Kyoichi';
    
-- 간혹 가다가 전체를 대상으로 update를 치는 경우도 있다.
-- 제품 닫가가 올라갔을때 전직원으 월급 5%인상이 되었다던디 등등
-- where 절이 필요가 없다.
select *
	from buytbl;
    
update buytbl
	set price = price * 1.5;
    
-- delete문에서도 역시 where가 없다면 모든 데이터를 다 지우는 것이다.
-- where절을 반드시 넣도록 한다.

select *
	from testtbl4
    where fname = 'Aamer';

delete from testtbl4
	where fname ='Aamer';
    
    
create table bigtbl1(
	select *
		from employees.employees
);

create table bigtbl2(
	select *
		from employees.employees
);


create table bigtbl3(
	select *
		from employees.employees
);

-- 아래와 같이 데이터를 지우는데 3가지 방법이 있다.
-- 속도적인 면을 살펴보면 drop -> truncate -> delete순으로 빠르다.
-- delete구문은 트랜잭션으로 인하여 지우기 때문에 느릴수 밖에 없다.
-- 하여 테이블과 함께 데이터를 다 지우고 싶다면 drop을 권장하고
-- 테이블의 구조는 남아있게 할려면 truncate(DDL) 구문을 쓰기를 권장한다.
-- 하지만,현업에서 drop,truncate구문은 잘 사용하지 않는다. 데이터는 중요하기 때문에
drop table bigtbl1;
delete from bigtbl2;
truncate table bigtbl3;

select *
	from bigtbl1;

select *
	from bigtbl2;
    
select *
	from bigtbl3;


drop table if exists membertbl;
create table membertbl(
	select userid, name, addr
		from usertbl
        limit 3
);

select *
	from membertbl;

-- 테이블을 위와 같이 만들면 ,제약조건은 따로 복사가 안된다.
-- alter구문을 이용해서 직접 제약 조건을 설정을 해보도록 하자
desc membertbl;
desc usertbl;
    

-- alter라는 DDL구문은 테이블을 수정할 때 사용한다.
-- 아래는 memebertbl테이블에 PK를 추가하는 구문이다.
alter table membertbl
	add constraint pk_membertbl primary key(userid);
    
select *
	from membertbl;

-- 데이터를 삽입하기 위해서 아래와 같이 코드를 작성을하면 삽입이 안된다
-- PK중복 때문에 안된다.
-- PK는 데이터 무결성을 지키는 제약 조건이다.
insert into membertbl values ('BBK','바비코','LA');
insert into membertbl values ('SKJ','신국주','서울');
insert into membertbl values ('CHUNLI','춘리','상해');

-- insert ignore int구문은 PK가 중복되는 것을 무시하고 아래 2개의 삽입은 
-- 정상적으로 이루어지게 했다.
insert ignore into membertbl values ('BBK','바비코','LA');
insert ignore into membertbl values ('SKJ','신국주','서울');
insert ignore into membertbl values ('CHUNLI','춘리','상해');


-- on duplicate key update구문은 현업에서 잘 사용하지 않는다.
-- 하지만 OCP ,SQLD 자격증 시헙에 나오기 때문에 이론적으로 알아야할 필요는 있다.
insert into membertbl values ('BBK','바비코','LA')
	on duplicate key update name = '바비코',addr = 'LA';
    
insert into membertbl values ('SKS','신기석','대구')
	on duplicate key update name = '신기석',addr = '대구';
