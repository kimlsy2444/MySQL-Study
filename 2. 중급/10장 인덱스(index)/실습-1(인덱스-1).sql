use sqldb;

-- 일단 buytbl에있는 외래키 제거
alter table buytbl
	drop foreign key buytbl_ibfk_1;

-- 아래코드는 전체 데이터 베이스 안에 있는 테이블의 제약조건의 상세를 알수 있다.
select*
	from information_schema.table_constraints;

-- 자 자회를 하면, order by를 주지도 않았는데도 불구하고 삽입할때와는 다르게
-- 알파벳 순으로 정렬이 되어있음을 알수가 있다. 즉 ,클러스터 인덱스의 효과이다.
-- 영어 사전의 단어 역할을 하는 것이다
-- 다시말해 테이블에 PK설정을하면 그것이 곧 클러스터형 인덱스가 되어서
-- 정렬이 되어진다는 것이다.
select *
	from usertbl;
    
drop table if exists tbl1;
create table tbl1(
	a int primary key,
    b int,
    c int
 );
 
 -- tbl1에 인덱스를 살펴보면 명려어이다
 -- 보면 non-unique로 거꾸로 되어 있다. 0 이면 uniue라는 것이다
 -- 또한 key name 이 primary로 되어 있다면 클러스터형 인덱스이다
 -- primary가 아니라면, 보조인덱스라고 생각하면 된다. 아울러, a라는 필드가 primary키인것이다.
 show index from tbl1;
 
 drop table if exists tbl2;
create table tbl2(
	a int primary key, -- 클러스터형 인덱스
	-- unique 제약조건은 중복 불가이지만 null은허용
    -- null 의 중복도 허용된다고 앞서 강의를 한바 있다.
	b int unique,	-- 보조인덱스
	c int unique	-- 보조인덱스
    );
    
show index from tbl2;
    
drop table if exists tbl3;
create table tbl3(
	a int unique,
	b int unique,
	c int unique
	);
    -- 확인을 해보면 보조 인덱스로만 구성되어진 테이블이다.
    -- 하여 클러스터형 보조 인덱스가 필수인 것은 아니란 것을 알 수 있다. (권장 클러스터형 인덱스 존재)
	show index from tbl3;
    
drop table if exists tbl4;
create table tbl4(
	-- unique 제약 조건인데 not null 추가 그렇게 되면 클러스터형 인덱스가 된다.
     a int unique not null,
	 b int unique,
     c int unique,
     d int
	);
-- 확인해보면 a필드에 null값을 허용하지 아니한다라고 나온다
-- 그럼 클러스터형 인덱스가 되는 것이다.
-- 정리를 하자면, 클러스터형 인덱스는 2가지가 될 수가 있다.
-- 첫 번째는 PK,두 번째는 unique not null일 때 클러스터형 인덱스가 되는 것이다.
show index from tbl4;

insert into tbl4 values(3,3,3,3);
insert into tbl4 values(1,1,1,1);
insert into tbl4 values(4,4,4,4);
insert into tbl4 values(5,5,5,5);
insert into tbl4 values(2,2,2,2);

select *
	from tbl4;

-- 만약에 테이블에 PK와 unique not null이 같이 있으면 어떻게 될까?
-- 결과론적으로 애기하면 PK가 클러스터형 인덱스가 되고, unique not null은
-- 보조 인덱스가 되는 것이다.

drop table if exists tbl5;
create table tbl5(
	-- PK가 없다면 당연히 a가 클러스터형 인덱스가 되지만, 여기서는
    -- d필드가 PK이기 때문에 보조 인덱스가 된다는 것이다.
	a int unique not null,
    b int unique,
    c int unique,
    -- 항상 PK가 클러스터형 인덱스가 된다는 것을 기억을 하자.
    d int primary key
);

show index from tbl5;

select *
	from usertbl;
    
alter table usertbl
	drop primary key;
-- 위에 PK를 삭제를 하고 나서 아래와 같이 데이터를 추가해보나, userid별로
-- 정렬이 안이루어짐을 확인할 수가 있다.
insert into usertbl values('AAA','아아아',1988,'한국',null,null,190,'20101010');

-- username을 기본키로 설정하기
alter table usertbl
	add constraint pk_username primary key(username);

-- 조회를 해보면 username의 가나다... 순으로 자동정렬이 된 것을 볼수가 있다.
-- username이 영어사전의 단어라고 생각하면 된다.
-- 근데 이런 작업은 현업에서는 절때 하지 않는다
-- 개무친짓 ㅋㅋ 
-- PK를 드랍하고 추가하는 것은 현업에서 가히 상상 할 수도 없다
-- 배우는 과정이니 예제일뿐 절때 안한다 데이터가 날라가고 뒤죽박죽되며 시간도엄청걸린다.

select *
	from usertbl;