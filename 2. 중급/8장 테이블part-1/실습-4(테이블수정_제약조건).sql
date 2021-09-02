use sqldb;
-- usertbl이 제거가 되지 않는 이유는 멀까요?
-- buytbl과 FK가 설정이 되어 있기 때문에 제거가 안되는 것이다.
-- buytbl을 제거하고 usertbl을 제거하면 된다.
drop table buytbl;
drop table usertbl;

drop table if exists usertbl;
CREATE TABLE userTBL -- 회원 테이블
( userID  	CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  userName  VARCHAR(10),
  birthYear INT,
  addr	  	CHAR(2),
  mobile1	CHAR(3),
  mobile2	CHAR(8),
  height    SMALLINT,
  mDate    	DATE
  -- nation varchar(10) not null default 'KOREA' -- default제약조건 추가
);

drop table if exists buytbl;
CREATE TABLE buyTBL -- 회원 구매 테이블
(  num 	INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   userID  	CHAR(8), 
   prodName CHAR(6),
   groupName CHAR(4),
   price INT,
   amount SMALLINT   
);

INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울', '010', '11111111', 178, '2008-8-8','USA');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북', '011', '22222222', 182, '2007-7-7',default);
INSERT INTO userTBL VALUES('KKJ', '김국진', 1865, default, '019', '33333333', 171, '2009-9-9', default);
INSERT INTO userTBL VALUES('KYM', '김용만', 1967, '서울', '010', '44444444', 177, '2015-5-5',default);

select *
  from usertbl;
delete from usertbl;

-- alter table을 이용해서 default제약조건 추가
alter table usertbl
	  alter column addr set default '서울';

desc usertbl;
truncate usertbl;

INSERT INTO buyTBL VALUES(NULL, 'KHD', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO buyTBL VALUES(NULL, 'KYM', '모니터', '전자', 200,  1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '모니터', '전자', 200,  5);
select *
  from buytbl;

-- 외래키 제약 조건을 추가를 할려고 하니 안된다.
-- usertbl에는 PSH라는 userid가 없기 때문이다.
alter table buytbl
	add constraint FK_usertbl_buytbl
    foreign key(userid) references usertbl(userid);

show index from buytbl;

delete from buytbl
where userid = 'PSH';

truncate buytbl;

-- 근데 먼저 buytbl에 외래키를 설정을 해놓코도 아래와 같이 데이터를 삽입하고 싶다면
-- foreign key기능을 off시키는 방법도 있다.
-- off를 시키지 않으면 usertbl에 userid가 없는 데이터들은 삽입이 되지 않는다걸 확인해봤다.
-- 하여 아래와 같은 방법으로 삽입을 한것이다.
-- 하지만, 아래와 같은 방법은 절대 권장하지 않는다.
-- 먼저 회원을 가입시키고 그 회원이 물건을 사게 만들어야지 아무나 물건을 사면 이상하다.
-- 절차가 맞지 않다.하여 usertbl에 데이터을 먼저 삽입하고 buytbl에 데이터 넣는 것이 
-- 당연한 절차이다.
set foreign_key_checks = 0; -- 외래키 체크 기능을 off
INSERT INTO buyTBL VALUES(NULL, 'KHD', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO buyTBL VALUES(NULL, 'KYM', '모니터', '전자', 200,  1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '모니터', '전자', 200,  5);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '청바지', '의류', 50,   3);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '메모리', '전자', 80,  10);
INSERT INTO buyTBL VALUES(NULL, 'KJD', '책'    , '서적', 15,   5);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '책'    , '서적', 15,   2);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '청바지', '의류', 50,   1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '책'    , '서적', 15,   1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '운동화', NULL   , 30,   2);
set foreign_key_checks = 1; -- 외래키 체크 기능을 on

-- 이번에는 제대로 데이터를 저장해보자.
INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울', '010', '11111111', 178, '2008-8-8');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북', '011', '22222222', 182, '2007-7-7');
INSERT INTO userTBL VALUES('KKJ', '김국진', 1965, '서울', '019', '33333333', 171, '2009-9-9');
INSERT INTO userTBL VALUES('KYM', '김용만', 1967, '서울', '010', '44444444', 177, '2015-5-5');
INSERT INTO userTBL VALUES('KJD', '김제동', 1974, '경남', NULL , NULL      , 173, '2013-3-3');
INSERT INTO userTBL VALUES('NHS', '남희석', 1971, '충남', '016', '66666666', 180, '2017-4-4');
INSERT INTO userTBL VALUES('SDY', '신동엽', 1971, '경기', NULL , NULL      , 176, '2008-10-10');
INSERT INTO userTBL VALUES('LHJ', '이휘재', 1972, '경기', '011', '88888888', 180, '2006-4-4');
INSERT INTO userTBL VALUES('LKK', '이경규', 1960, '경남', '018', '99999999', 170, '2004-12-12');
INSERT INTO userTBL VALUES('PSH', '박수홍', 1970, '서울', '010', '00000000', 183, '2012-5-5');

INSERT INTO buyTBL VALUES(NULL, 'KHD', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO buyTBL VALUES(NULL, 'KYM', '모니터', '전자', 200,  1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '모니터', '전자', 200,  5);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '청바지', '의류', 50,   3);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '메모리', '전자', 80,  10);
INSERT INTO buyTBL VALUES(NULL, 'KJD', '책'    , '서적', 15,   5);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '책'    , '서적', 15,   2);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '청바지', '의류', 50,   1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '책'    , '서적', 15,   1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '운동화', NULL   , 30,   2);

-- check제약조건
-- 원래 오라클이나 mssql에는 check제약조건이 존재한다. 하지만 mysql에서는 지원을 
-- 하지 않는다.추후에 배울 trigger를 통해서 해결할 수 있으니 별문제가 없다.
alter table usertbl
	add constraint CK_birthyear
    check (birthyear >= 1900 and birthyear <= year(curdate()));

set foreign_key_checks = 0;
update usertbl
  set userid = 'KKK'
where userid = 'KHD';
set foreign_key_checks = 1;

select *
  from usertbl;

select * 
  from buytbl;

-- 두 테이블을 조인하여 아래와 같이 결과를 도출하면 분명 buytbl에는 12건에 데이터 있지만,
-- 9건만에 출력이 되지 않는다.왜? KHD가 KKK로 바뀌었기 때문에 당연히 결과값이 나오지 않는다.  
select U.userid, U.username, B.prodname, U.addr
  from usertbl U
  inner join buytbl B
  on U.userid = B.userid;

-- 외부조인을 해봐도 결과는 KHD가 없다. KHD가 있었던 부분이 null로 나오는 것을 확인할 수가 있다.  
select U.userid, U.username, B.prodname, U.addr
  from usertbl U
  right outer join buytbl B
  on U.userid = B.userid;
-- 원복하기
set foreign_key_checks = 0;
update usertbl
  set userid = 'KHD'
where userid = 'KKK';
set foreign_key_checks = 1;

-- 근데 KHD가 KKK로 바꿔달라고 하면 외래키를 추가할 때 on update cascade구문을
-- 사용하면 buytbl에 있는 데이터도 KHD가 KKK로 자동으로 바뀐다.

alter table buytbl
	drop foreign key FK_usertbl_buytbl;

alter table buytbl
	add constraint FK_usertbl_buytbl
    foreign key(userid) references usertbl(userid)
    -- 이 구문이 들어감으로써 usertbl의 PK가 변경되면서 따라서 buytbl의 FK인 userid도 따라서 바뀐다.
    on update cascade;

update usertbl
  set userid = 'KKK'
where userid = 'KHD';

-- 확인해보면 KKK로 다 바뀐것을 확인할수가 있다.
select U.userid, U.username, B.prodname, U.addr
  from usertbl U
  right outer join buytbl B
  on U.userid = B.userid;

delete from usertbl
  where userid = 'KKK';

alter table buytbl
	add constraint FK_usertbl_buytbl
    foreign key(userid) references usertbl(userid)
    on update cascade  -- 수정시 따라서 수정
    on delete cascade; -- 삭제시 따라서 삭제