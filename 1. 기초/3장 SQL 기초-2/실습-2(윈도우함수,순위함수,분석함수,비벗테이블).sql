use sqldb;
-- 순위 매기기 row_number() over()
-- row_number() 같은 키가 존재해도 순위를 정해버린다.
select row_number() over(order by height desc) as '키 순위', username,addr,height
	from usertbl;

-- 같은 키가 존재하면 이름으로 순위 정해보기
select row_number() over(order by height desc,username asc) as '키 순위', username,addr,height
	from usertbl;
    
-- 같은 키가 존재하면 동일한 등수로 만들고 동일한 등수의 수만큼 띄우고 순위를 정하기 
-- rank() over() 일반적으로 가장 많이 사용되는 순위함수
select rank() over(order by height desc) as '키 순위', username,addr,height
	from usertbl;
-- dense_rank() over()
-- 같은 키가 존재함녀 동일한 등수로 만들고 동일한 등수 수만큼 띄우지 않고 순위를 정하기
select dense_rank() over(order by height desc) as '키 순위', username,addr,height
	from usertbl;

-- over(partition by 컬럼명),에 따라서 그룹지어서 그룹안에서 순위를 정하기
select row_number() over(partition by addr order by height desc) as '지역별키 순위', username,addr,height
	from usertbl;
    
select rank() over(partition by addr order by height desc) as '지역별키 순위', username,addr,height
	from usertbl;
    
-- ntile(정수), 해당하는 row개수에 그룹으로 나누어주는 함수
select ntile(2) over(order by height desc)  as '반 번호',username,addr,height
	from usertbl;

-- 분석 함수
-- lead(칼람명,offset,default) : 현재 row를 기준으로 다음행 참조
-- lag(칼람명,offset,default)  : 현재 row를 기준으로 이전행 참조
select  username,addr,height as '키',
	height - (lead(height,1,0) over(order by height desc)) as '다음사람과의 키차이'
		from usertbl;
        
select  username,addr,height as '키',
	height - (lag(height,1,0) over(order by height desc)) as '다음사람과의 키차이'
		from usertbl;

-- 지역별 최대키와 차이
-- first_vlaue(컬럼) : 정렬된 값중에서 첫 번째 값을 의미한다.
-- last_vlaue(컬럼)  : 정렬된 값중에서 맨 마지막 값을 의미한다.
select  username,addr,height as '키',
	height - (first_value(height) over(partition by addr order by height desc)) as '지역별 최대키 와 차이' 
		from usertbl;

-- last_value() 사용할 때는 반드시 over절에 
-- rows between unbounded preceding and unbounded following : 정렬결과 처음과 끝을 대상으로 함
select  username,addr,height as '키',
	height - (last_value(height) over(partition by addr order by height desc rows between unbounded preceding and unbounded following)) as '지역별 최소키 와 차이' 
		from usertbl;

-- 누적 백분율 함수 cume_dist() : 0~1사이를 리턴을 해준다.
select  username,addr,height as '키',
	(cume_dist() over(partition by addr order by height desc))  * 100 as '누적 인원 백분율'
		from usertbl;


-- 간단한 피벗 테이블 만들기
drop table if exists pivot;
create table pivot(
	uname varchar(10),
    season varchar(5),
    amount int
);

insert into pivot values
('김범수','겨울',10),('윤종신','여름',15),
('김범수','가을',25),('김범수','봄',5),
('김범수','봄',37),('윤종신','겨울',40),
('김범수','여름',14),('김범수','겨울',22),
('김범수','겨울',22),('윤종신','여름',64);

select *
	from pivot;
    
-- 피벗 테이블을 만드는 첫 번째 방법(sum(),case when ... then ...end)
select uname,
	sum(case when season = '봄' then amount end) as'봄',
	sum(case when season = '여름' then amount end) as'여름',
	sum(case when season = '가을' then amount end) as'가을',
	sum(case when season = '겨울' then amount end) as'겨울'
	from pivot
	group by uname;

-- 피벗 테이블을 만드는 두 번째 방법(sum(),if())
select uname,
	-- 만약 season이 봄이면 amount을 sum 해라
	sum(if  (season = '봄' , amount,0)) as'봄',
	sum(if  (season = '여름', amount,0)) as'여름',
	sum(if  (season = '가을', amount,0)) as'가을',
	sum(if  (season = '겨울', amount,0)) as'겨울'
	from pivot
	group by uname;

select season,
	-- 만약 season이 봄이면 amount을 sum 해라
	sum(if(uname = '김범수' , amount,0)) as'김범수',
	sum(if(uname = '윤종신', amount,0)) as'윤종신',
    sum(amount) as '합계'
	from pivot
	group by season
    order by sum(amount);