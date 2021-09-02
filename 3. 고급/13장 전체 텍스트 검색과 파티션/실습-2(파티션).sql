-- 파티션에 대해서 알아보자
create database if not exists partdb;
use partdb;

drop table if exists parttbl;
create table parttbl(
	userid char(8) not null, -- parttion을 사용할때 PK로 설정하면 안된다 정렬이되기때문
    username varchar(10) not null,
    birthyear int not null,
    addr char(2) not null
)

partition by range(birthyear) (
	partition part1 values less than (1970),  -- 1970년 미만 저장할 파티션
    partition part2 values less than (1972),  -- 1970년 이상,1972년 미만까지 저장할 파티션
    partition part3 values less than maxvalue -- 1972년 이후 저장할 파티션
);

insert into parttbl (userid, username, birthyear, addr)
	select userid, username, birthyear, addr
	from sqldb.usertbl;

-- 10건이 잘 저장되었다. 조히를 하면 결과를 살펴보면
-- 위에 테이블을 만들떄, 파티션 1,2,3를 주었는데 ,그 형식대로
-- 저장되었다는 것을 확인을 할 수가 있다.


-- 시스템 DB인 information_schema를 이용하여 파티션이 나누어진 것을
-- 확인 할 수가 있다.
select *
	from information_schema.partitions
where table_schema = 'partdb';


select *
	from parttbl
    where birthyear < 1970;

-- 파티션 중에서 part1을 사용했을음 알수가 있다.
explain
	select *
		from parttbl
	where birthyear < 1970;

-- 파티션 나누기
alter table parttbl
	reorganize partition part3 into (
		partition part3 values less than(1974),
        partition part4 values less than maxvalue
    );
-- 위의 파티션 나눈 내용을 실제 테이블에 적용시킴
optimize table parttbl;

select *
	from information_schema.partitions
where table_schema = 'partdb';

-- 파티션 합치기
alter table parttbl
	reorganize partition part1, part2 into(
		partition partsum values less than (1972)
    );
optimize table parttbl;

select *
	from information_schema.partitions
where table_schema = 'partdb';

-- 파티션 삭제하기
alter table parttbl drop partition partsum;
optimize table parttbl;

-- partsum 이라는 파티션이 삭제되었으므로, parttbl 에는 데이터가 3개일 것이다.
select *
	from parttbl;

-- 결론 파티션을 나누너가 합치거나 등 하는 것은 제약사항이 상당히 까다롭다.
-- 하여 현업에서도 별로 사용하지 않는다. 다만 ,개념정도는 알아두도록 하자.
    





