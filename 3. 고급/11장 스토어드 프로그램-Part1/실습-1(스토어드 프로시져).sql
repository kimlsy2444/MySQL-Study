use sqldb;

drop procedure if exists userproc;

delimiter //
create procedure userproc()
-- 현업에서 스토어드 프로시져의 내용은 통상 begin~end 사이에 내용으로 이루어진다.
-- 물론 지금은 쿼리문이 적지만 프로그래밍을 하다보면 몇천줄이 될수있다.
-- 이장에서는 begin ~  end 사이의 내용을 집중적으로 배우고 호출하면서
-- 얼마나 편리한 기능인지 살펴 보도록하자
begin
	select *
		from usertbl;
end //

delimiter ;

-- 위에서 만든 프로시져 호출 방법
call userproc();

-- 입력매개변수(인자값) 있을 때의 프로그래밍
drop procedure if exists userproc2;
-- 여기서는 in이란 매개변수를 이용해서 쿼리문의 조건의 대입값을  활용을 하는경우
delimiter //
create procedure userproc2(in inusername varchar(10))

begin
	select *
		from usertbl
        where username = inusername;
end //
delimiter ;

-- 매개변수 inusername의 데이터 형식에 맞게끔 값을 반드시 일치시켜야 한다.
call userproc2("유재석");
call userproc2("이경규");
-- 매개변수에 타입과 일치하지 않는 값을 주니 아무런 결과값을 주지 아니한다.
call userproc2(10);

-- 매개변수가 2개인것
drop procedure if exists userproc3;
delimiter //
create procedure userproc3(in userbirth int, in userheight int)
begin
	select *
		from usertbl
        where birthyear > userbirth -- 출생년도 비교
			and height > userheight; -- 키를 비교
end //

delimiter ;
-- 1970년 이후에 태어났고, 키가 178초과 조건을 만족하는 데이터를 검색하는 것
call userproc3(1970, 178);


-- 출력 매개변수 대해서 알아보자
drop procedure if exists userproc4;
-- 여기서는 입력매개변수가1개ㅡ 출력 매개변수가 1개로 되어있다.
-- sqldb에는 testtbl이 없다.
-- 그럼에도 procedure가 만들어지는데는 영향이 없다
-- 실행만 안하면 문제가 없다는 것을 의미한다. 즉,call 할때는 반드시
-- testtbl테이블이 있어야 pricedure가 실행된다.
delimiter //
create procedure userproc4(in txtvalue char(10), out outvalue int)
begin
	-- txtvalue값이 testtbl에 자동 저장된다.
	insert into testtbl values(null, txtvalue);
    select max(id) into outvalue
		from testtbl;
	

end//

delimiter ;
-- userproc4에 필요한 testtbl을 정의하자.
drop table if exists testtbl;
create table testtbl(
	id int auto_increment primary key,
    txt char(10)
);

-- @가 붙으면 변수
call userproc4('테스트',@value);
call userproc4('테스트1',@value);

select concat("현재 입력된 아이디 값 --> ", @value);

-- --------------------------------
-- 제어문을 이용한 스토어드 프로시져 생성 --

drop procedure if exists ifelseproc;
delimiter //
create procedure ifelseproc(in inusername char(10))
begin
	declare byear int; -- 변수선언
    -- where 절에서 입력 매개변수로 넘어오는 값을 가지고 조회를 해서
    -- 출생년도(birthyear)를 변수 byear에 대입하고 있다.
    select birthyear into byear
		from usertbl
	where username = inusername;
    -- 대입된 변수값을 가지고 아래 코드를 작성하는 것이다.
    if(byear>= 1970) then
		select concat(inusername,'님은 나이가 중후하시군요');
	else
        select concat(inusername,'님은 나이가 많으시군요');
	end if;
end //

delimiter ;

call ifelseproc('이경규');
call ifelseproc('유재석');


-- case문을 이용해서 띠를 구하기
drop procedure if exists caseproc;
delimiter //
create procedure caseproc(in inusername varchar(10))

begin
	declare byear int; -- 출생년도 저장 변수
    declare yearof varchar(5);  -- 띠 저장 변수
    
    select birthyear into byear
		from usertbl
	where username = inusername;
    
    -- byear변수에 저장된 출생년도 값을 이용해서 아래와 같이 떄를 구해보자.
    case 
		when (byear % 12 = 0) then
			set yearof = '원숭이';
		when (byear % 12 = 1) then
			set yearof = '닭';
		when (byear % 12 = 2) then
			set yearof = '개';
		when (byear % 12 = 3) then
			set yearof = '돼지';
		when (byear % 12 = 4) then
			set yearof = '쥐';
		when (byear % 12 = 5) then
			set yearof = '소';
		when (byear % 12 = 6) then
			set yearof = '호랑이';
		when (byear % 12 = 7) then
			set yearof = '토끼';
		when (byear % 12 = 8) then
			set yearof = '용';
		when (byear % 12 = 9) then
			set yearof = '뱀';
		when (byear % 12 = 10) then
			set yearof = '말';
		else 
			set yearof ='양';
        end case;
	
    -- tti와 inusername에 저장된 값을 이용하여 출력함
	select concat(inusername,'--->' ,'님의 띠는 바로 ', tti, '입니다.');
    
end //
delimiter ;

call caseproc('이경규');
call caseproc('강호동');

-- 반복문 예제 구구단 만들기
-- 구구단 내용을 저장할 테이블을 생성
create table if not exists gugutbl(
	txt varchar(100)
);

drop procedure if exists whileproc;
delimiter //
create procedure whileproc()
begin
	declare str varchar(100); -- 각 단을 문자열로 저장하는 변수
    declare i int;
    declare j int;
    
    set i = 2;
    while (i < 10)do -- 외부 루트
		set str = '';
        set j = 1; -- 구구단 뒷자리는 1부터 시작
        
        while (j<10) do -- 내부 루트
			set str = concat(str,'  ',i,'*',j,'=',i*j);
			set j = j+1;
		end while;
        
		set i = i+1; -- 단의 수를 증가
		-- 한 단이 끝나면 문자열 str값을 테이블에 저장하는 코드
		insert into gugutbl values (str);
	end while;
end //
delimiter ; 

call whileproc();
-- 프로시져의 결과깂이 어차피 테이블에 저장이 되었기 때문에 테이블 조회를 해야
-- 결과값을 볼수가 있는 것이다.
	select *
		from gugutbl;