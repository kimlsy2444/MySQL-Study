-- 아래 쿼리문은 항상 쌍으로 실행을 현업에서는 한다.
-- 설명을 하자면, 만약 sqldb가 존재한다면 삭제를 하고
-- 다시 sqldb를 만들어라라는 의미를 지니고 있다.
drop database if exists sqldb;
create database sqldb;
use sqldb;

-- 회원테이블 작성
-- drop table if exists usertbl;
create table usertbl(
	userid varchar(8) not null primary key,  -- 사용자 아이디(PK)
    username varchar(10) not null,   -- 이름
    birthyear int not null,      -- 출생년도
    addr varchar(4) not null,    -- 주소
    mobile1 varchar(3),          -- 휴대폰의 앞자리 번호(010,016,011,017,019)
    mobile2 varchar(8),          -- 휴대폰의 나머지 번호(하이픈(-)을 제외
    height smallint,             -- 키(smallint는 2바이트임)
    mdate date                   -- 회원 가입일
);
-- 회원 구매 테이블 생성
-- drop table if exists buytbl;
create table buytbl(
	-- auto_increment명령어는 mysql엔진이 데이터가 들어올 때 마다, 1씩 자동증가시켜줌
    num int auto_increment not null primary key,
    -- userid는 여기서는 pk가 될수 없다. 그 이유는 한 테이블에는 pk는 오로지 
    -- 하나만 존재해야한다.
    userid varchar(8) not null,
	prodName varchar(6) not null,  -- 물품명
	groupName varchar(4),          -- 분류
    price int,                     -- 단가
    amount smallint not null,      -- 수량
    -- usertbl에 있는 userid를 참조해라.여기서는 usertbl이 외래키로써(fk)
    foreign key(userid) references usertbl(userid)
);

-- usertbl에 데이터를 삽입
insert into usertbl values 
('LSG', '이승기', 1987, '서울', '011', '11111111',182, '2008-08-08'),
('KBS', '김범수', 1979, '경남', '011', '22222222',173, '2012-04-04'),
('KKH', '김경호', 1971, '전남', '019', '33333333',177, '2007-07-07'),
('JYP', '조용필', 1950, '경기', '011', '44444444',166, '2009-04-04'),
('SSK', '성시경', 1979, '서울', null, null, 186, '2013-12-12'),
('LJB', '임재범', 1963, '서울', '016', '66666666',182, '2009-09-09'),
('YJS', '윤종신', 1969, '경남', null, null, 170, '2005-05-05'),
('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3'),
('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10'),
('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');


-- buytbl에 데이터를 삽입
insert into buytbl values
(null, 'KBS', '운동화', null, 30, 2),
(null, 'KBS', '노트북', '전자', 1000, 1),
(NULL, 'JYP', '모니터', '전자', 200,  1),
(NULL, 'BBK', '모니터', '전자', 200,  5),
(NULL, 'KBS', '청바지', '의류', 50,   3),
(NULL, 'BBK', '메모리', '전자', 80,  10),
(NULL, 'SSK', '책'    , '서적', 15,   5),
(NULL, 'EJW', '책'    , '서적', 15,   2),
(NULL, 'EJW', '청바지', '의류', 50,   1),
(NULL, 'BBK', '운동화', NULL  , 30,   2),
(NULL, 'EJW', '책'    , '서적', 15,   1),
(NULL, 'BBK', '운동화', NULL  , 30,   2);

select *
  from usertbl;
  
select *
  from buytbl;
  
