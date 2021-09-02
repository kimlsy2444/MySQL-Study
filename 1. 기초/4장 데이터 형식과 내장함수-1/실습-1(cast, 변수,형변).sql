use sqldb;
-- MYSQL의 엔진은 어떤 문자셋을 사용하고 있는지 알기 위한 코드
--  UTF-8 이라는 문자셋을 사용한다. 한글이 3바이트로 설정되어있다.
show variables like 'character_set_system';

-- 아래 cast문은 현재 문자열 date 데이터타입으로 캐스팅(변환)사쿄쥰더,
select cast('2020-10-12 12:33:12:478' as date) as '날짜';
select cast('2020-10-12 12:33:12:478' as time) as '시각';
-- datetime데이터 타입은 문자형 데이터 타입으로 저장이 된다.
select cast('2020-10-12 12:33:12:478' as datetime) as '날짜와 시각'; -- 8바이트
select now();
-- timestamp데이터 타입은 숫자형 데이터 타입으로 저장이 된다.
select timestamp(now()); -- 4바이트 

drop table if exists timetbl;
create table timetbl(
	 num int,
	date_timestamp timestamp not null,
    date_datetime datetime not null
    );

-- 타임존을 설정한다.
set time_zone = '+05:30';
insert into timetbl values (2, now(), now());
select *
	from timetbl;

select utc_timestamp(); -- UTC타임 출력

-- 이번에는 변수에 대해서 사용해보고 , 후반부 SQL프로그래밍에 변수가
-- 많이 등장하므로 개념을 익힐 필요가 있다.

set @var1 = 5;
set @var2 = 3;
set @var3 = 5.77;
set @var4 = '이름 : ';
select @var1;
select @var1 + @var2;
--  보기좋게 출력하기 위해서 아래와 같이 변수를 사용해봄ㄴ
select @var4, username
	from usertbl
    where height > 180;

-- 하지만 변수는 limit절에는 못쓴다.
select @var4, username
	from usertbl
    where height> 180;
-- limit @var2;
-- 동적 쿼리문 사용하기
-- 일단 아래 쿼리는 변수를 지정을 하고, myquery라는 명으로 ' ' 안에 있는
-- 쿼리문을 준비를 한다. ? 는 변수명을 대입하고 execute문을 실행하는 것이다.
-- 예를 들어 응용 SW에서 아용자로부터 입력을 받아서 출력을 한다면 이렇게 변수를 사용하면 좋을 것이다. 
-- prepare ... execute .. using문을 사용하면 된다.
-- 중요한 부분이니 잘 정리를 해두도록 하자.
set @var1 = 3;
prepare myquery
	from 'select username , height
			from usertbl
            order by height
            limit ?';
execute myquery using @var1;

-- 아래 쿼리를 실행을하면 buytbl의 amount평균을 나타낸다.
-- 하지만 소숫점을 반올림 하고 싶을때는 cast, convert를 사용하면 된다.
select avg(amount) as '평균구매갯수'
	from buytbl;
-- singned : 부호가 있는
-- unsingned : 부호가 없는
select cast(avg(amount) as signed integer) as '평균구매갯수'
	from buytbl;
    
select convert(avg(amount), signed integer) as '평균구매갯수'
	from buytbl;
    
-- 문자열 연결함수 (conact())
select num ,concat(cast(price as char(10)),' * ',cast(amount as char(4)),' =') as '단가*수량',
		price*amount as'구매액'
	from buytbl;
    
-- cast,convert함수를 쓰면 이것은 명시적 형변환에 속한다.
-- 아래코드는 묵시적 ,암시적, 자동 형변환 이라고 한다 셋다 같은말 혼돈하지말자.
select 100+'100';
-- select 100+cast('100'as signed int);
select concat('100','원입니다.');
-- concat()함수는 인자값으로 숫자가 들어있어도 문자로 묵시적 형변환이 일어난다. (문자열 연결함수 이기 때문)
select concat(100,'원입니다.');

-- false(거짓)은 0으로 대변이되고 , 0을 제외한 나머지 숫자는 true가 된다.
select 1 > '2mega';
select 1 < '2mega'; -- 양수의 대표적인 값은 1 음수의 대표적인 값은 -1
