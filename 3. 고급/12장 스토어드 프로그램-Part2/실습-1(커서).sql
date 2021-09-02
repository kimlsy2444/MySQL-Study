-- 커서 학습하기

use sqldb;

-- 커서(cursor)는 테이블울 쿼리를 한후 , 쿼리르의 결과인 행 집합을 한 행씩 처리하기
-- 위한 방식이다.
-- C언어나 자바에서 파일 입출력과 아주 유사한 개념이다.
-- 파일을 처리하기 위해서 먼저 파일을 열고 첫 번째 데이터를읽고 다음 데이터가 저장
-- 되어 있는 공간까지 파일 포인터가 이동한다.
-- 이런씩으로 파일의 끝(EOF- end of file)까지 반복한다
-- 마지막으로 파일 포인터를 닫는다.

-- 고객의 평균키를 구하는것, 단 커서를 이용해서
-- 아래 코드와 같이 집계함수를 이용해서 avg()쉽게 구할 수 있다.
-- select  avg(height)
-- 	from usertbl;

-- 커서를 이용한 평균키 구하기
drop procedure if exists cursorproc;
delimiter //
create procedure cursorproc()
begin
	declare userheight int; -- 고객 키 저장할 변수
    declare cnt int default 0; -- 고객의 인원수 
    declare total int default 0; -- 고객 키의 총합
    -- 플래그 변수 선언(행의 끝인지 아닌지 알아보는 변수)
    declare endofrow boolean default false;
	-- 아래와 같이 조회를 하면 키 값들이 출력이 될 것이다.
    -- 그리고 난후 cursor가 그 키값에 처음 부분에 위치하는 것이다.
    declare usercursor cursor for
    select height
		from usertbl;
	-- 만약에 커서가 이동하면서 마지막에 도달하게 되면
    -- 더이상 데이터를 발견못하면 아래 핸들러가 실행이 되어서
    -- endofrow가 true로 자동 실행된다.
    
	declare continue handler
		for not found set endofrow = true;
        open usercursor; -- 커서를 연다.
	-- 무한 루프를 돈다
	cursor_loop : loop
    -- 현재 usercursor가 가리키고 있는 height를 userheight에 저장함
    -- 저장한 후, usercursor는 다음 행으로 이동됨.
		fetch usercursor into userheight;
        -- 무한 루프를 빠져나가는 조건은 endofrow가 true로 되어야 한다.
        if(endofrow) then
			leave cursor_loop;
            end if;
	set cnt = cnt +1; -- 고객수 증가
    set total = total + userheight; -- 고객키를 계속 누적
    
    end loop cursor_loop;

	select concat('고객수 : ',cnt,'평균키 : ',(total/cnt));
    close usercursor; -- 커서를닫는다.

end//
delimiter ;

call cursorproc();


-- 한 가지 더 예제를 해보도록 하자
-- usertbl 에 grade컬럼을 추가해서 활용하자

alter table usertbl
	add grade varchar(10);
select *
	from usertbl;
    
-- 고객 등급 리스트를 ㄹ만들어주는 프로시져 만들기
drop procedure if exists gradeproc;
delimiter //
create procedure gradeproc()

begin
	declare id varchar(10); -- 사용자 아이디를 저장할 변수
    declare hap bigint;
    declare usergrade varchar(10); -- 고객등급 저장 변수
    -- 플래그 변수
    declare endofrow boolean default false;
  
    
    -- 커서를 아래 쿼리문에 선언
    -- 외부조인을 하는 이유는 하나도 구매하지 않은 고객들도 있기 떄문이다.
    declare usercursor cursor for
        
    select U.userid, sum(B.price * B.amount)
		from buytbl as B
        right outer join usertbl as U
        on B.userid = U.userid
        group by U.userid;
        
	-- 핸들러 선언
	declare continue handler
		for not found set endofrow = true;
   open usercursor; -- 커서 열기
    grade_loop :loop
    -- 쿼리문의 결과중에서 id와 sum값을 각각 변수에 대입을 함.
    -- 그리고 커서 다음 행으로 이동함
	fetch usercursor into id,hap;
    -- 무한루프 탈출 조건문 생성
    if (endofrow = true) then
    leave grade_loop;
    end if;
    
    case 
		when(hap >= 1500)then
			set usergrade= "최우수 고객";
		when(hap >= 1000)then
			set usergrade= "우수 고객";            
		when(hap >= 1)then
			set usergrade= "일반 고객";    
		else
			set usergrade= "유령 고객";   
		end case;
	-- 위의 case문에서 저장되어진 usergrade값을 테이블의 grade컬럼에
    -- 업데이트를 하고 있다.
    update usertbl
		set grade = usergrade
        where userid = id;
    
    
    end loop grade_loop;
    close usercursor;    
    end //
delimiter ;

call gradeproc();
 select U.userid, sum(B.price * B.amount),U.grade
		from buytbl as B
        right outer join usertbl as U
        on B.userid = U.userid
        group by U.userid;