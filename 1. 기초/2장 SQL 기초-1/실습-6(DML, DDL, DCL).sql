-- 통상 sql은 아래와 같은 분류로 나뉜다
-- 1. DML (Data Manipulation Language) : 데이터 조작언어
--    DML은 얼마든지 취소가 가능하다. rollback이란 키워드로 가능 
--    ex) select, insert, delete, update

-- 2. DDL(Data Definition Language) : 데이터 정의 언어
--    DDL은 취소가 안된다. 실행하면 바로 물리적 저장공간에 바로 적용된다.
--    ex)create, drop, alter, truncate(테이블의 구조를 그대로 남긴체 데이터를 다 지워준다.)

-- 3. DCL(Data Control Language) : 데이터 제어언어
--    유저에게 어떤 권한을 부여하거나 빼앗을 때 사용하는 구문
--    ex)grant, revoke

use sqldb;
drop table if exists testtbl1;
create table testtbl1(
	id int,
    username varchar(3),
    age int
);


insert into testtbl1 values (1,'홍길동',33);
select*
	from testtbl1;
-- 원하는 필드에만 저장하고 싶다면 아래와 같이 쿼리를 작성하면 된다.
-- 저장하지 않은필드는 당연히 null이 된다.
insert into testtbl1(id,username) values (2,'김연아');
select *
	from testtbl1;
    
insert into testtbl1(username,age,id) values ('장규리',25,3);
-- 필드르 사용자 맘대로 설정해서 넣어줄 수도 있다. 
select *
	from testtbl1;
-- insert into testbl1(username,age,id) values ('장규리','이서연',3);


-- auto_increment구문은 DB엔진이 자동으로 행이 추가 될때마다 1씩 증가된다.
drop table if exists testtbl2;
create table testtbl2(
	id int auto_increment primary key,
    username varchar(3),
    age int
);

insert into testtbl2 values (null,'송하영',25),
							(null,'백지헌',19),
							(null,'이새롬',25);
select *
	from testtbl2;
 
 delete from testtbl2
	where id=2;
    
insert into testtbl2 values(null,'이채영',22);
insert into testtbl2 values(10,'이서연',22);

-- auto_increment한 필드가 마지막으로 삽입된 것을 조회할 때는 last_insert_id()함수를 이용하는것이 좋다
select last_insert_id();

-- 테이블에 관련된 수정을 하고자 하면 alter를 이용하면 된다.
alter table testtbl2 auto_increment = 100;
insert into testtbl2 values(null,'이나경',22);
select *
	from testtbl2;
    
    
drop table if exists testtbl3;
create table testtbl3(
	id int auto_increment primary key,
    username varchar(3),
    age int
);

alter table testtbl3 auto_increment = 1000;


-- 아래코드는 생소하다 , 하지만 알아야하는 서버 변수이다.
-- set구문 다음 @@ 붙으면 서버변수라고 생각을 하자.
-- 아래와 같이 코드를 줬다면 증가를 1씩 하는게 아니라, 3씩 하게끔 설정을 하는 것이다.
set @@auto_increment_increment = 3;

insert into testtbl3 values (null,'박지원',24);
insert into testtbl3 values (null,'노지선',24);
insert into testtbl3 values (null,'송하영',25);

select *
	from testtbl3;
-- truncate구문은 DDL이기 때문에 트랜잭션에 해당하지 않기 때문에 대용량 데이터를 한번에
-- 지우고자 할때 truncate를 사용하는 것이 훨씬 효율적이다.
truncate testtbl3;