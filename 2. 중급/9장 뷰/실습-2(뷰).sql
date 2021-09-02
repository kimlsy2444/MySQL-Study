use sqldb;

-- 집계함수와 group by 와 order by view 작성

create or replace view v_sum
as 
	select userid as 'USER ID', sum(price*amount) as '합계'
	from buytbl
    group by userid
    order by sum(price * amount) desc;

-- 뷰룰 통한 select의 결과는 잘 나오는 것을 알 수가 있다.
select *
	from v_sum;

-- 아래의 결과와 같이 집계함수와 group by 가 들어가 있는 뷰는 데이터를
-- 변경할 수 없음을 기억하도록 하자.

-- update v_sum
-- 	set '합계' = 2000
--     where `USER ID` = 'PSH';

-- information_schema는 시스템 데이터베이스이다.
-- 확인을 해보면 is_updatable을 보면 no로 설정이 되어있다
-- 하여 이 v_sum은 뷰로써는 수정,삭제 삽입이 되질 안된다 라는것이다
-- 집계함수를 사용한 뷰는 절대 수정이나 삭제가 이루어지지 않는다.
-- union all, join, distinct , grop by도 역시 되지 않는다.
select *
	from information_schema.views
where table_schema = 'sqldb'
	and table_name = 'v_sum';

-- 키가 177 이상인 사람을 조회하는 뷰를 생성해보자
create or replace view v_hegint177
as 
	select *
		from usertbl
        where height >= 177;
-- 실행되며 테이블에서도 삭제된다.
delete from v_hegint177
where height = 178;

select *
	from v_hegint177;

select *
	from usertbl;
-- 삽입은 된다 하지만 조회를 하면 나오지 않는다
-- 왜? 뷰가 177 이상만 조히를 하니까 나오질 않는다.
insert into v_hegint177 values('SEH','신은혁',2008,'구미',null,null,140,'2010-05-05');

-- 근데 혼란이 온다. 177이상인 데이터만 입력을 받기 위해서 with check option 구문을 사용하면된다.
-- 사용하면 된다
alter view v_hegint177
as 
select *
	from usertbl 
    where height >= 177
    with check option;
    insert into v_hegint177 values('KKK','김기군',2008,'구미',null,null,140,'2010-05-05');
    
-- 복합뷰(조인뷰)도 아래와 같이 만들 수 있다.
create or replace view v_userbuytbl
as
	select U.userid as 'USER ID', U.username as 'USER NAME',
		   B.prodname as 'PROD NAME', U.addr as '주소'
	from usertbl U
	inner join buytbl B
    on U.userid = B.userid;
    
-- 복합뷰(조인뷰)에 데이터 삽입이 안된다.
insert into v_userbuytbl values('PKL','박경림','경기');


-- 테이블을 제거했다 .그럼 뷰는 어떻게 되는가?
drop table buytbl, usertbl;

-- 뷰가 참조하고 있는 실체(테이블)가 제거 되었으니 뷰는 실행이 안된다.
select *
	from v_userbuytbl;
-- 이 때는 뷰가 참조하고 있는 테이블이 어떤것인지 아래와 같이 확인을 해보면
-- 명확하게 알수가 있다.
check table v_userbuytbl;
