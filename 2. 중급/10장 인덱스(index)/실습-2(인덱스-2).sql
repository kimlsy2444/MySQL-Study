 -- drop database if exists testdb;
 -- create database testdb;

create database if not exists testdb;
use testdb;

drop table if exists mixedtbl;
create table mixedtbl(
	userid char(8) not null,
    username varchar(10) not null,
    addr char(2)
);

-- 데이터 10건 삽입

insert into mixedtbl values('YJS','유재석',NULL);
insert into mixedtbl values('KDH','강호동',NULL);
insert into mixedtbl values('KKJ','김국진',NULL);
insert into mixedtbl values('KYM','김용만',NULL);
insert into mixedtbl values('KJD','김재동',NULL);
insert into mixedtbl values('MHS','남희석',NULL);
insert into mixedtbl values('SDY','신동엽',NULL);
insert into mixedtbl values('LHJ','이휘재',NULL);
insert into mixedtbl values('LKK','이경규',NULL);
insert into mixedtbl values('PSH','박수홍',NULL);

-- 위에 mixedtbl테이블은 PK가 unique not null 과 같은 제약 조건이없다
-- 하여, select를 하면 삽입된 순서데로 출력을 해준다.
-- 즉 인덱스가 없다.
select *
	from mixedtbl;
-- 아래의 코드는 innodb(my sql 엔진)가 지원하는 page의 크기는 16kb라는 사실을 알수가 있다.
show variables like 'innodb_page_size';
-- mixedtbl에 userid에 PK_mixedtbl란 명으로 PK를 추가해보자
-- 그럼 어떻게 되는가? 바로 userid가 PK가 됨과 동시에 클러스터형
-- 인덱스가 생성이 되고 오름차순 정렬이 이루어진다.

alter table mixedtbl
	add constraint PK_mixedtbl primary key(userid);
    
-- 확인해보면 인덱스를 확인 할 수가 있다.
show index from mixedtbl;

-- PK컬럼을 기준으로 오름차순 정렬이 되어 있는 것을 확인할 수가 있다.
-- 이렇게 된 것은 클러스터형 인덱스가 만들어진 것을 의미한다.
-- 즉 영어사전이 만들어 진 것이다.
select *
	from mixedtbl;
    
-- 이번에는 username에다가 unique 제약조건을 걸어보자
alter table mixedtbl
	add constraint UK_mixedtbl_username unique(username);

-- 한 테이블에 클러스터형 인덱스와 보조인덱스가 각각 같이 생성되어 있다.
-- 그럼 내부적으로 구성되는 것은 방금 그림과 같이 될 것이다.
-- 김용만 주소를 찾기 위해서는 클러스터형 인덱스를
-- 이용을 하면 2페이지만 읽으면 된다.

-- 클러스터형 인덱스는 리프페이지가 곧 데이터 페이지이기 때문이다.
-- 그에 반해서 보조인덱스는 데이터페이지는 건드리지 않고 별도의 공간의
-- 인덱스를 생성해서 거기 인덱스에 실제 데이터가 들어가 있는 주소와+#오프셋 
-- 값이 들어가가있어서 3번 페이지를 읽게 되는 것이다.

select *
	from mixedtbl;
    
-- sqldb를 초기화 시키자
use sqldb;

select *
	from usertbl;
-- 인덱스가 있는지 확인
show index from usertbl;
-- usertbl의 상태를 보는 것이다.
-- date_length가 클러스터형 인덱스의 크기이다. idx_length는 보조인덱스의 크기를 나타내는 것이다.
-- 지금은 없기 때문에 0으로 출력이 된것을 볼수가 있다.
show table status like 'usertbl';

-- addr컬럼에 보조인덱스를 생ㅅ어하는 것이다.
create index idx_usertbl_addr
	on usertbl(addr);
-- 보조 인덱스를 만들면 바로 테이블에 적용이 되는 것이 아니라
-- 직접테이블에 적용하는 코드를 실행해줘야 한다.
analyze table usertbl;
-- 보조인덱스를 테이블에 적용을 시키니 비로소 index_length가 16kb가 잡힌것을
-- 확인할 수 있다.
show table status like 'usertbl';

-- birthyear컬럼에다가 unique index를 만들어주고 실행하니 오류가 발생
-- 그 이유는 unique제약조건은 중복 불가이기 때문에 birthyear컬럼은
-- unique index의 자격으로 충분하지 않다.
create unique index idx_usertbl_birthyear
	on usertbl(birthyear);

-- username에 unique index가 잘 만들어졌다.
create unique index idx_usertbl_name
	on usertbl(username);

show index from usertbl;

-- 아래의 데이터를 삽입하면 오류가 발생한다. 분명 userid는 다른데 말이다.
-- 그 이유는 username을 우리가 위에서 unique index로 만들었다.
-- 중복 허용을 하지 않으니 오류가 나는 것이다.
-- 동명이인 때문에 이런 컬럼에 unique index를 잡으면 
-- 현실적으로 맞지 않다.
-- 하여 인덱스를 어느 컬럼에 설정을 해야할지는 정말 고민 많이 해야한다.
-- 정말 unique 한 것들 (주민등록번호,학번,전화번호 앞자리)으로 
-- 잡아주는 것이 현명하다.
insert into usertlb values('GYM','김용만',1960,'캐나다',null,null,170,null);
-- 그래서 위에 인덱스를 제거를 했다.
drop index idx_usertbl_name on usertbl;

show index from usertbl;

-- 2개의 컬럼을 이용해서 보조인덱스를 만들어보도록 하자
create index idx_usertbl_username_birthyear
	on usertbl(username,birthyear);

-- 확인을 해보니 2개의 컬럼으로 만든 인덱스가 seq가 1,2로 구분되어져서 잘만들어졌다.
show index from usertbl;

-- 아래와 같이 쿼리를 하게 되면 위에 만든 인덱스가 필히 사용되었을것이다.
-- 인덱스를 만든다고 하여 데이터에 영향을 끼치는 것은 전혀 없다.
-- 다만 속도가 빨리지던지 늦어지던지 둘중에 하나가 될 것이다.
-- execution plan(실행계획)보면 역시 idx_usertbl_username_birthyear
-- 인덱스를 사용한  것을 확인할 수가 있다.
-- 물론 이 내용이 지금이야 데이터가 몇 건 안되니 느끼지 못하지만 대용량 데이터 베이스에서는
-- 엄청난 속도 향상을 가져다 줄 것이다.
select *
	from usertbl
	where username = '김국진'
	and birthyear = 1965;

-- 국번을 가지고 보조인덱스를 만들어보자
create index idx_usertbl_mobile1
	on usertbl(mobile1);
show index from usertbl;

-- 위에서 만들어진 인덱스가 사용되었다.
-- 하지만 엔딕스로 설정한 컬럼의 데이터가 (중복)국한되어 있다면
-- 별로 효울적이지 못하다
-- 계속 인덱스에 갔다가 페이지에 갔다가 하기 때문에 그런 것이다.
-- 그래서 대용량 데이터 베이스에 해당 컬럼의 값이 다양한 것 (중복불가)
-- 한것 에다가 인덱스를 설정하는 것이 매우 바람직하다. 
select *
	from usertbl
where mobile1= '011';

show index from usertbl;

-- 이제는 인덱스를 제거 해보자
-- 인덱스를 제거할 때도 항상 보조인덱스를 먼저 제거를 해야한다.
-- 클러스터형 인덱스를 먼저 제거해버리면 보조인덱스에서 주조를 지정하는 작업
-- 을 DB엔진에서 다시 진행한다. DB엔진에 상당한 부담을 지우게 된다.
-- 제거 방법은 : 보조 인덱스제거 -> 클러스터형 인덱스를 제거

drop index idx_usertbl_addr on usertbl;
drop index idx_usertbl_mobile1 on usertbl;
drop index idx_usertbl_username_birthyear on usertbl;

-- 이제 클러스터형 인덱스를 제거해보자
-- 클러스터형 인덱스는 drop으로 하면 안된다.
-- alter table을 이용하자

-- 에러발생
alter table usertbl
	drop primary key;

show table status like 'buytbl';
desc buytbl;

-- 외래키의 이름을 알아내는 방법 시스템DB를 사용해서 알아낼수가 있다.
select *
	from information_schema.table_constraints
    where constraint_schema ='sqldb';
-- 외래키 제거
alter table buytbl
	drop foreign key buytbl_ibfk_1;
    
-- 기본키 제거
alter table usertbl
	drop primary key;
    
show index from usertbl;