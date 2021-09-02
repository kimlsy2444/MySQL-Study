-- SQL 프로그래밍 기본적 문법
-- 1. if문, case문 

use sqldb;

-- num이라는 변수명으로 int(정수)타입으로 4바이트 apahfl(스택)에 할당해서,
-- num이라는 저장공간에 500을 저정한다.
-- if구문을 이용하여 num이 500이면 실행하고 500이 아니라면 else구문을 실행해라.
-- delimiter는 구분자이다.
-- 프로시져를 만드는 코드에는 주석을 달면 프로시져가 만들어 지지 않으므로
-- 주석을 달지 않도록 하자.

drop procedure if exists ifProc;
delimiter //	
create procedure ifProc()
begin
	declare num int; 
    set num = 500;
    
	if num = 500 then 
		select '500입니다.';
	else 
		select '500이 아닙니다.';
	end if;
end //
delimiter ;
-- ifProc()프로시저를 호출하는 프로그램
call ifProc();


-- 아래 프로시져는 입사한지 5년이 지났는지 직접 확인하는 프로그래밍이다,
-- 먼저 변수를 date타입으로 2개(현재,입사년도)를 선언하고 ,날짜 계산하기 위해서
-- days를 int 형으로 선언했다.
-- select hire_date into hiredate 는 hire_date컬럼의 내용울 변수 hiredatedp 대입하라는 
-- 쿼리문이다 hiredate를 이용하여 계산하면 된다.
-- 근무일수는 현재날짜 - 입사날짜이니깐 datediff()를 이용해서 구하고
-- 날짜 / 365로 하면 근무 년수가 나온다.
drop procedure if exists ifProc2;
delimiter $$
create procedure ifProc2()
begin
	declare hiredate date;
    declare curdate date;
    declare days int;
	
    select hire_date into hiredate
		from employees.employees
        where emp_no = 10001;
        
        set curdate = curdate();
        set days = datediff(curdate,hiredate);
        
        select contcat('근무일수', days);
        
      if(days / 365) >= 5 then
		select concat('입사한지 ', days/365, '년이 넘었군요. 축하합니다') as '입사경과 년수';
	else
		select concat('아직 ', days/365 , '년 밖에 안됐군요. 화이팅!') as '입사경과 년수';
	end if;       
end $$
delimiter ; 

call ifProc2();

-- 학점을 출력하는 SQL 프로그래밍을 해보도록 하자.
drop procedure if exists ifProc3;
delimiter // 
create procedure ifProc3()
begin
	declare score int;
    declare grade char(1);
    set score = 92;
    
	if score >= 90 then
		set grade = 'A';
	elseif score >= 80 then
		set grade = 'B';
	elseif score >= 70 then
		set grade = 'C';
	elseif score >= 60 then
		set grade = 'D';
	else 
		set grade ='F';
	end if;
	select concat('점수 : ', score) as '점수', concat('당신의 학점 : ' , grade) as '취득학점';
    
end //
delimiter ;
call ifProc3();


drop procedure if exists ifProc4;
delimiter // 
create procedure ifProc4()
begin
	declare score int;
    declare grade char(1);
    set score = 92;
	
	case
     when score >= 90 then
		set grade = 'A';
     when score >= 80 then
		set grade = 'B';
     when score >= 70 then
		set grade = 'C';
     when score >= 60 then
		set grade = 'D';
	else 
		set grade = 'F';
	end case;
	select concat('점수 : ', score) as '점수', concat('당신의 학점 : ' , grade) as '취득학점';
end // 
delimiter ;
call ifProc4();

-- sqldb를 초기화 시킨후, 아래 쿼리를 작성
use sqldb;
-- 총구매액을 기준으로 userid를 출력
select userid, sum(price*amount) as '총구매액'
	from buytbl
    group by userid
    order by (price*amount) asc;
    
select *	
	from buytbl;
    
-- 고객이름이 없으니 조인을 이용해서 usertbl과 엮도록 하자
-- 내부조인을 하게 되면 구매내역만 있는 고갹만 출력이 된다.
-- 외부조인을 다시 하여 구매 하지 않은 고객까지 출력을 해야한다. 
-- 그래야 고객의 등급을 나눌 수 있다.
select U.userid, U.username, sum(price*amount) as '총구매액'
	from buytbl as B
    inner join usertbl as U
    on B.userid = U.userid
    group by U.userid, U.username
	order by (price*amount) desc;
    
select U.userid, U.username, sum(price*amount) as '총구매액'
	from buytbl as B
    right outer join usertbl as U
    on B.userid = U.userid
    group by U.userid, U.username
	order by (price*amount) desc;
    
-- 고객 등급 나누어서 출력하기
-- select 문안에 하나의 컬럼처럼 고객등급을 case when then 구문으로 설정을 하는 부분
select U.userid, U.username, sum(price*amount) as '총구매액',
	case 
		when sum(price*amount) >= 1500 then '최우수고객'
        when sum(price*amount) >= 1000 then '우수고객'
        when sum(price*amount) >= 1 then '일반고객'
        else  '유령고객'
        end as '고객 등급' 
        
        from buytbl as B
    right outer join usertbl as U
    on B.userid = U.userid
    group by U.userid, U.username
	order by (price*amount) desc;

