# shopdb라는 데이터베이스를 만드는 것
CREATE DATABASE shopdb;
# use명령어는 '~사용하겠다'
USE shopdb;

# membertbl을 만드는 쿼리문
CREATE TABLE memberTBL (
	memberID varchar(10) not null,
    memberName varchar(10) not null,
    memberAddress varchar(30),
    primary key(memberID)
);

# membertbl을 제거하는 명령어
drop table membertbl;
# membertbl의 테이블 상태를 보는 명령어
desc membertbl;

# membertbl에 있는 모든 열의 값들을 다 출력하는 쿼리문
select *
  from membertbl;

# 데이터를 membertbl에다가 저장하는 쿼리문
# not null이라는 제약조건은 ""저장을 시켜주지만, null이라고 저장을 하면 이거는 null이라고 인정을 하여
# 저장을 시켜주지 아니한다.
insert into membertbl values('Shin','신동욱','');
insert into membertbl values('Dang','당탕이','경기도 부천시 중동');
insert into membertbl values('Jee','지운이','서울 은평구 중산동');
insert into membertbl values('Han','한주연','인천 남구 주안동');
insert into membertbl values('Sang','상길이','경기 성남시 분당구');

#데이터를 삭제해주는 명령어
delete from membertbl;

create table producttbl(
	productName varchar(10) not null,
	cost int not null,	
    makeDate date,
    company varchar(10) not null,
    amount int not null,
    primary key(productName)
);

desc producttbl;

insert into producttbl values('컴퓨터',10,'2013-01-01','삼성',17);
insert into producttbl values('세탁기',20,20140901,'LG',3);
insert into producttbl values('냉장고',30,20150102,'대우',22);

select *
  from producttbl;
  
  

  