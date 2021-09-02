-- 스토어드 함수
use sqldb;

-- function을 만들수 있는 신뢰를 계정에게 주었는지 안주었는지 확인하는 시스템 변수
show global variables like 'log_bin_trust_function_creators';
-- function을 만들 수 있도록 신뢰성을 계정한테 주는 것이다.
set global log_bin_trust_function_creators =1;

drop function if exists userfunc;
delimiter //
-- 매개변스를 int타입 2개 받겠다는 function이다.
create function userfunc(value1 int, value2 int)
	returns int -- 리턴값의 데이터타입이 int타입이다.
begin
	return value1+ value2; -- value1+ value2가 리턴값이 된다
end //
delimiter ;

-- 스토어드 함수는 반드시 select 구문안에서 호출이 이루어져야 한다.
select userfunc(1000,-700);

-- 출생년도를 입력하면 나이를 반환하는 스토어드 함수를 만들어보자.
drop function if exists getagefunc;
delimiter //
-- 매개변수 int형을 하나 받아서 그값을 이용하여 int형 데이터 리턴
create function getagefunc(byear int)
	returns int
begin
	declare age int;
    -- 나이계산
    set age = year(curdate()) - byear;
    return age;
end //
delimiter ;

select getagefunc(1997) as '만나이';
select getagefunc(1978) into @age1978;
select getagefunc(2007) into @age2007;

select concat('2007 - 1978 차이 : ', @age1978 -@age2007);

-- 아래와 같은 용도로 스토어드 함수는 많이 사용됨
-- 하지만 빈도수는 프로시져가 훨씬 많이 사용된다.
select userid, username, getagefunc(birthyear) as '만나이' 
	from usertbl;
-- 저장되어 있는 스토어드 함수의 내용을 보고싶다면..
show create function getagefunc;

--  스토어드 함수를 제거하고 싶다면
drop function getagefunc;

-- 정리 -- 

-- 스토어드 프로시져와 스토어드 함수는 매우 유사하지만 활요도는
-- 스토어드 프로시져가 많이 활용된다.
-- 하지만, 때에 따라서는 스토어드 함수도 사용을 할 때도 있다.
-- 일단 차이점을 보자면 아래와 같다.
-- 1. 스토어드 프로시져
-- 매개변수값에 in , out 을 사용가능하다.
-- 별도의 리턴구문이 없다.
-- 꼭 리턴값이 필요하다면 여러 개의 out매개변수를 사용해서 값을 반환이 얼마든지 가능하다.
-- call로 호출한다.
-- begin ~ end 사이에 select문이 사용가능하다. ***
-- 여러 sql문이나 계산 등 다양한 용도로 사용이 가능하다.

-- 2. 스토어드 함수 
-- 매개변수값에 in , out을 불가능하다
-- 전달되는 모든 매개변수는 입력 매개변수이다.
-- retuns문으로 반환할 값의 데이터 형식 지정을 해줘야 한다.
-- begin ~ end 사이에 return문으로 하나의 값을 반드시 반환을 해줘야한다.
-- select 문장 안에서 호출을 해야한다는 것이다.
