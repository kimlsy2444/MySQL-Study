use sqldb;

-- name컬럼에 있는 내용중에서 '김경호'인것만 행을 출력한다. 
select *
	from usertbl
    where name ='김경호';
    
-- 관계연산자와 and를 이용하여 조건을 주었다.
-- and는 둘다 참이여만 참을 반환을 해준다.
-- 출생년도(1970을 포함하여) 이후의 조건과 키가 182이상인 조건을 둘 다 만족하는
-- 데이터를 출력한다.

select userid,name
from usertbl
where birthyear >= 1970
 and height >= 182;
 -- or조건은 둘 중 하나가 참이면 무조건 참을 반환하기 때문에
 -- 1970년 이후이거나 키가 182이상인 데이터들을 다 출력한다.
 select userid,name
from usertbl
where birthyear >= 1970
 or height >= 182;
 
 -- 키가 180이상이고, 183이하인 조건을 충족하는 쿼리문을 작성
 select *
from usertbl
where height >= 180
 and height <= 183;
 
 -- 아래 코드 between(사이) ~and구문으로 바꾸었다.
 -- 위의 코드보다 between(사이) ~and구문 훨씬 가독성이 좋다.
 -- 상당히 현업에서 많이 사용된다. 아울러 수치데이터 (연속적인 데이터)에 많이 사용된다.
 select *
 from usertbl
 where height between 180 and 183;
 
 select *
	from usertbl
    where addr ='경남'
    or addr ='전남'
    or addr ='경북'
    or addr ='전북';

-- in은 수치데이터(연속적인 데이터)가 아닌 이산적(떨어져 있는)데이터에 사용된다. 
-- 가독성이 위의 코드보다 훨씬 좋다.
  select *
	from usertbl
   where addr in('경남','전남','경북','전북');
   
   -- 경남을 제외한 나머지 전부 출력
   select *
	from usertbl
   where addr not in('경남');
   
   -- 성이 김씨인 데이터를 다 출력하라.
   -- like와 %구문은 통상 검색할 때 자주 사용  현업에서
   select *
	from usertbl
	where name like '김%';
    
    -- 한 글자에 대한 것은_()로써 대체하여 검색할 수도 있다.
    select *
    	from usertbl
		where name like '김_';
        
