-- 테이블을 복사하는 방법
use sqldb;
drop table if exists buytbl_copy;
-- buytbl의 데이터 전부를 쿼리를 해서 새로운 테이블인 buytbl_copy로 복사
create table buytbl_copy(
	select *
		from buytbl
);

select *
	from buytbl_copy;
-- 하지만 테이블을 복사를 하게 되더라도, PK FK등의 제약 조건은 복사가 되지 않는다.
desc buytbl_copy;

# 기본적 쿼리문 순서 (매우 중요)
# 무조건 아래와 같은 순서로 작성을 해야한다.
# select ...
#	from ...
#	where ...
#	group by ...
#	having ...
# 	order by ...

-- 고객이 구매한 건수를 확인해보는 쿼리문이다.
-- 문제는 중복되는게 많이 나온다.
-- 아울러, 집계가 되지 않아서 한 눈에 보기 어렵다
-- 하여,gruop by절을 이용하면 편리하다.


-- 아래 쿼리를 실행해보면 고객별로 구매한 건수가 한 눈에 들어온다.
-- 여기서 sum()이 나왔는데 이것은 집계함수이며, 아울러 group by를 할 때
-- 즉, 그룹을 지을 때 userid로 하겠다라는 의미이다. 일단, 집계함수류가 나오면
-- 무조건 group by절이 들어가야 한다는것을 기억하도록하자
-- 실제 현업에서 줫나 많이 쓴다.
select userid,sum(amount)
	from buytbl
    group by userid
    order by sum(amount) desc;
-- 아래는 알리아스를 사용하여 컬럼명을 바꾸어서 출력해봄    
select userid as'아이디',sum(amount) as'구매건수' 
	from buytbl
    group by userid
    order by sum(amount) desc;
    
-- 이제는 총 구매액 집계
-- 총구매액은 총구매량 * 단가가 될 것이다.
select *
	from buytbl;
-- 아래 쿼리는 고객별로 총구매액을 기준으로 내림차순으로 정렬하는 쿼리이다.
select userid as '아이디',sum(price*amount) as'총 구매액'
	from buytbl
    group by userid
    order by sum(price*amount) desc;

-- 아래 쿼리는 고객별로 평균 구매갯수를 알아보는 쿼리이다.
select userid as '아이디',avg(amount) as'평균 구매갯수'
	from buytbl
    group by userid
    order by avg(amount);
    
select avg(amount)	
	from buytbl;
    
-- max() min()
select name, height
	from usertbl;
-- 원하는 값을 얻을 수 없다 
-- name 별로 group by절을 적용시키니 10개의 데이터가 다 나온다.
select  name,max(height),min(height)
	from usertbl
    group by name;
    
    select  name,height
	from usertbl
    where height = (
		select max(height)
			from usertbl
    ) 
    or height = 
    (
    select min(height)
			from usertbl);

-- 건수를 집계하는 count()대해서 살펴보자
select count(*)
	from usertbl;
    
select count(*) as'휴대폰이 있는 사람'
	from usertbl
    where mobile1 is not null;

use employees;

select count(*)
	from employees;

-- 총 구매액으로 내림차순 정렬을 해놓은 쿼리문이다.
-- 근데 총구매액이 1000만원 이상만 보고싶다면 어떻게 하면 될까?
-- where절에 조건문을 제시하면 오류가 난다.
-- where 조건절에는 집계함수를 사용 할 수가 없다.(매우중요)
-- group by된 절을은 having조건을 줘야 한다.
select userid as'아이디',sum(amount) as'구매건수' 
	from buytbl
	where sum(price*amount) >1000
    group by userid
    order by sum(amount) desc;

-- having은 조건절이다.
select userid as'아이디',sum(amount) as'구매건수' 
	from buytbl
    group by userid
    having sum(price*amount) >1000
    order by sum(amount) desc;

-- with roll up 에 대해서 알아보자
-- 분류별로 소합계를 내어주고 마지막에 총합계를 보여준다.
-- num을 추가하게 되면 건바이건까지 다 출력
select groupname,sum(price*amount)
	from buytbl
    group by groupname,num
	with rollup;