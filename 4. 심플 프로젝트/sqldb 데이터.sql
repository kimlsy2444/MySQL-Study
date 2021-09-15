DROP DATABASE IF EXISTS sqldb;
CREATE DATABASE sqldb;
USE sqlDB;

drop table if exists userTBL;
CREATE TABLE userTBL -- 회원 테이블
( userID  	CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  userName    	VARCHAR(10) NOT NULL, -- 이름
  birthYear   INT NOT NULL,  -- 출생년도
  addr	  	CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  mobile1	CHAR(3), -- 휴대폰의 국번(011, 016, 017, 018, 019, 010 등)
  mobile2	CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈제외)
  money    INT UNSIGNED,  -- 돈 
  amount   INT UNSIGNED, -- 계산금액
  mDate    	DATE  -- 회원 가입일
);

drop table if exists addressTBL;
CREATE TABLE addressTBL -- 배송시간 테이블
( 	
	address char(2) NOT NULL, -- 지역
    addresstime int not null -- 배송시간
);

drop table if exists buyTBL;
CREATE TABLE buyTBL -- 물건 테이블
( 	
	prodName 	CHAR(6) NOT NULL, --  물품명
	price     	INT  NOT NULL, -- 단가
	quantity    INT UNSIGNED -- 수량
);


-- 회원 테이블
INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울', '010', '11111111', 500,0, '2008-8-8');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북', '011', '22222222', 300,0, '2007-7-7');
INSERT INTO userTBL VALUES('KKJ', '김국진', 1965, '서울', '019', '33333333', 400,0, '2009-9-9');
INSERT INTO userTBL VALUES('KYM', '김용만', 1967, '서울', '010', '44444444', 900,0, '2015-5-5');
INSERT INTO userTBL VALUES('KJD', '김제동', 1974, '경남', '010', '55555555', 1000,0, '2013-3-3');
INSERT INTO userTBL VALUES('NHS', '남희석', 1971, '충남', '016', '66666666', 1200,0, '2017-4-4');
INSERT INTO userTBL VALUES('SDY', '신동엽', 1971, '경기', '010', '77777777', 300,0, '2008-10-10');
INSERT INTO userTBL VALUES('LHJ', '이휘재', 1972, '경기', '011', '88888888', 700,0, '2006-4-4');
INSERT INTO userTBL VALUES('LKK', '이경규', 1960, '경남', '018', '99999999', 1100,0, '2004-12-12');
INSERT INTO userTBL VALUES('PSH', '박수홍', 1970, '서울', '010', '00000000', 1200,0, '2012-5-5');

-- 배송시간 테이블
INSERT INTO addressTBL VALUES ('서울',1);
INSERT INTO addressTBL VALUES ('부산',2);
INSERT INTO addressTBL VALUES ('대구',3);
INSERT INTO addressTBL VALUES ('인천',4);
INSERT INTO addressTBL VALUES ('광주',5);
INSERT INTO addressTBL VALUES ('대전',6);
INSERT INTO addressTBL VALUES ('울산',7);
INSERT INTO addressTBL VALUES ('세종',8);
INSERT INTO addressTBL VALUES ('경기',9);
INSERT INTO addressTBL VALUES ('강원',10);
INSERT INTO addressTBL VALUES ('충북',11);
INSERT INTO addressTBL VALUES ('충남',12);
INSERT INTO addressTBL VALUES ('전북',13);
INSERT INTO addressTBL VALUES ('전남',14);
INSERT INTO addressTBL VALUES ('경북',15);
INSERT INTO addressTBL VALUES ('경남',16);
INSERT INTO addressTBL VALUES ('제주',17);

-- 물건 테이블
INSERT INTO buyTBL VALUES ('자동차',100,2);
INSERT INTO buyTBL VALUES ('컴퓨터',200,5);





-- 스토어드 프로시저생성
-- case문을 이용해서 등급표만들기
drop procedure if exists vipproc;
delimiter //
create procedure vipproc(in inusername varchar(10))
begin
	declare vipamount int; -- 계산금액 저장
    declare viprank varchar(5);  -- 등급 저장 변수
    
    select amount into vipamount
		from usertbl
	where username = inusername;
    
    -- byear변수에 저장된 출생년도 값을 이용해서 아래와 같이 떄를 구해보자.
    case 
		when (vipamount = 0) then      -- 0  유령
			set viprank = '유령고객';
		when (vipamount  <= 100) then  -- 1 ~ 100 실버
			set viprank = '실버';
		when (vipamount <= 400) then   -- 101 ~ 400 골드
			set viprank = '골드';
		when (vipamount  <=700) then   -- 401 ~ 700 플레티넘
			set viprank = '플레티넘';
		when (vipamount  > 700) then   -- 701 ~ 다이야	
			set viprank = '다이야';
        end case;
	
    -- tti와 inusername에 저장된 값을 이용하여 출력함
	select concat(inusername,'--->' ,'님의 등급은 바로 ', viprank, '입니다.') as '등급';
end //
delimiter ;
call vipproc('이경규');
call vipproc('강호동');




SELECT * FROM userTBL;
