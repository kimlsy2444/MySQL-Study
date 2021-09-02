
drop database if exists tabledb;
create database tabledb;
use tabledb;

drop table if exists usertbl;
create table usertbl(
	userid char(8) not null primary key,
    username varchar(10) not null,
    birthyear int not null,
    addr char(2) null,
    mobile1 char(3) null,
    mobile2 char(8) null,
    height smallint null,
    mdate date null
 );
 -- 위의 테이블을 만들고 PK를 설정해주면 ,자동적으로 클러스터형 index가 만들어진다.
 -- 이 부분은 index에서 집중적으로 다룰 것이니 ,일단 PK설정시 index가 만들어진다는 것만 기억하자
 -- 아래 테이블을 만들고 외래키를 설정하는데, 외래키를 설정시에는 참조하는 테이블의
 -- 컬럼명과 동일한 이름으로 해주고 데이터타입도 일치하게 해주는 것이 관례이다.
 
 
 drop table if exists buytbl;
create table buytbl(
	num int not null auto_increment primary key,
	userid char(8) not null,
	prodname char(6) not null,
    groupname char(4) null,
    price int not null,
    amount smallint not null
    -- 외래키 추가부분은 통상 외래키가 있는 테이블이 자식 테이블이 되고
    -- PK가 있는 테이블이 부모 테이블이 된다.
    -- 외래키가 꼭 PK하고 연동되는 것이 아니다. unique제약 조건을 
    -- 가지고있는 컬럼과 연동이 왼다.
	-- foreign key(userid) references usertbl(userid)
    -- 외래키의 이름을 직접 지정해주는 코드이다.
	-- constraint FK_usertbl_buytbl foreign key(userid) references usertbl(userid)    
 );
-- 아래 코드는 테이블의 인덱스에 대한 것을 보는코드 이다.
show index from buytbl;

-- 아래코드는 mysql에 생성되어져 있는 모드 DB에 있는 table에 제약조건을 보는 코드이다.
select *
	from information_schema.table_constraints;

-- 외래키를 alter table을 가지고 외래키를 추가하는 코드 (현업에서 자주 사용되는 코드)
alter table buytbl
add constraint FK_usertbl_buytbl
foreign key(userid) references usertbl(userid);

-- 외래키를 alter table을 가지고 외래키를 삭제하는 코드
alter table buytbl
drop foreign key FK_usertbl_buytbl;



INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울', '010', '11111111', 178, '2008-8-8');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북', '011', '22222222', 182, '2007-7-7');
INSERT INTO userTBL VALUES('KKJ', '김국진', 1965, '서울', '019', '33333333', 171, '2009-9-9');


-- 아래 코드를 입력하고 실행시키면 에러가 난다
-- 바로 KYM에서 오류가 발생한다.
-- 바로 부모 테이블이 되는 usertbl에 KYM이라는 데이터가 없기 때문이다.
-- 회원정보가 없는데 어떻게 구매를 할수 있냐?
-- 해결방법은 2가지 있다.
-- 외래키의 기능을 해제 하거나 데이터를 추가한다 
INSERT INTO buyTBL VALUES(NULL, 'KHD', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO buyTBL VALUES(NULL, 'KYM', '모니터', '전자', 200,  1);

-- 외래키의 기능을 해제 시킨다.
set foreign_key_checks = 0;

-- 외래키의 기능을 활성화 시킨다.
set foreign_key_checks = 1;