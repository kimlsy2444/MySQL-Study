use tabledb;

drop table if exists prodtbl;
-- 아래 테이블에서는 PK나 FK같은 제약조건을 주지 않았다
create table prodtbl(
	prodcode char(3) not null,
	prodid char(4) not null,
    proddate datetime not null,
    prodcur char(10) null
    -- constraint PK_prodtbl_prodcode_prodid primary key(prodcode, prodid)
);

select *
	from prodtbl;
show index from prodtbl;

insert into prodtbl values('AAA','0001',20191010,'판매완료');
insert into prodtbl values('AAA','0002',20191010,'매장진열');
insert into prodtbl values('BBB','0001',20191012,'재고창고');
insert into prodtbl values('CCC','0001',20191013,'판매완료');
insert into prodtbl values('CCC','0002',20191014,'판매완료');



-- 위에서 입력한 데이터를 보면 PK로 설정할 컬럼이 없다.
-- 두개의 컬럼을 조합해서 PK만들면 된다.

alter table prodtbl
add constraint PK_prodtbl_prodcode_prodid 
primary key(prodcode,prodid);

-- 테이블 삭제
-- usertbl테이블이 삭자게 되지 않는다 usertbl이 참조하는 buytbl이 있다.
-- 외래키로써 두 테이블은 관계를 맺고 있어서 삭제가 되지 않는다.
-- 하여 usertbl을 삭제를 하려면 먼저 buytbl을 삭제를 하고 그후에 usertbl을
-- 삭제를 할 수가 있다.
-- 아니면, 외래키 기능 해제시키거나, alter table을 이용하요 buytbl에 있는
-- 외래키를 drop시키고 삭제가 가능하다.
drop table usertbl;
-- 1번째 방법은 자식테이블 즉 외래키가 있는 테이블을 drop을 하고
-- 부모 테이블을 삭제한다
drop table buytbl;

-- 2번째 방법은 자식테이블의 외래키의 기능을 삭제하거나 기능 해제 코드를 넣어서
-- usertbl을 삭제한다.
set foreign_key_checks = 1;
alter table buytbl
drop foreign key FK_usertbl_buytbl;

CREATE TABLE `usertbl` (
  `userid` char(8) NOT NULL,
  `username` varchar(10) NOT NULL,
  `birthyear` int NOT NULL,
  `addr` char(2) DEFAULT NULL,
  `mobile1` char(3) DEFAULT NULL,
  `mobile2` char(8) DEFAULT NULL,
  `height` smallint DEFAULT NULL,
  `mdate` date DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `buytbl` (
  `num` int NOT NULL AUTO_INCREMENT,
  `userid` char(8) NOT NULL,
  `prodname` char(6) NOT NULL,
  `groupname` char(4) DEFAULT NULL,
  `price` int NOT NULL,
  `amount` smallint NOT NULL,
  PRIMARY KEY (`num`),
  KEY `FK_usertbl_buytbl` (`userid`),
  CONSTRAINT `FK_usertbl_buytbl` FOREIGN KEY (`userid`) REFERENCES `usertbl` (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

