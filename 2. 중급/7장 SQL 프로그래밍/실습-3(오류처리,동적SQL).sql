-- 오류 처리, 동적 SQL문

drop procedure if exists errorProc;
delimiter //
create procedure errorProc()
begin 
	-- action(continue) 부분은 continue 하라는 것인데, 1146 이라는 오류가 뜨면
    -- 테이블이 없습니다 를 출력하는 것이다. 1146에러 코드는 테이블이 없을때 mysql에서
    -- 직접 발생시키는 오류코드 번호이다. sqlstate '42S02'도 역시 테이블이 존재하지 않을때
    -- 나타나는 오류 코드번호 이다. 
    -- 이론 강의에서 강의한 사이트나 코드 번호를 찾아서 넣어주면 오류 코드 구문을 작성 할 수 있다.
    -- 일반적으로 오류 코드가  방대하기 때문에
	-- 직접 알아보기쉽게 오류처리 구문을 넣어주면 디버깅할때 상당한 도움이 된다.
	declare continue handler for 1146 select '테이블이 없습니다.' as '오류메시지';
    declare continue handler for sqlstate '42S02' select '테이블이 없습니다.' as '오류메시지';
    select *
		from AAA;
end //
delimiter ;
call errorProc();

-- PK가 중복되었을때 오류처리를 하는 코드
drop procedure if exists pkErropProc;
delimiter //
create procedure pkErropProc()
begin
	-- 모든 오류를 다 받게 선언했다.
	declare continue handler for sqlexception
    begin
		show errors; -- 오류 메시지를 보여준다.
        select '기본키는 중복될 수 없습니다. 작업을 취소시킵니다.' as '메시지';
        rollback; -- 작업을 되돌린다.
	end;
    -- PK LKK는 이미 이경구가 들어가있으므로 오류를 분명히 발생시킬것이다.
	insert into usertbl values('LKK','리규강','평양',null,null,170,current_date());
		
end // 
delimiter ;
call pkErropProc();

-- 동적sql문, prepare, execute, using문
-- myquery를 변수라고 일단 생각하고 그 변수에 쿼리문을 대입한 것이다.
-- 즉, 준비만 한다는 것이다. 결과물이 출력되지 않는다. 일종의 메모리 할당 개념이다.
prepare myquery from 'select * from usertbl where userid = "LKK"';
execute myquery;
-- 메모리를 사용했으면 해제를 해줘야 한다.
deallocate prepare myquery;

drop table if exists mytable;
create table mytable(
	id int auto_increment primary key,
    mdate datetime
);

-- 아래 3줄을 여러번 실행하자
-- 현재 날짜와 시간을 curdate변수에 저장한다. 즉 실행시점의 날짜와 시간이 저장된다.
-- ex) 회원가입 구매시점, 출퇴근시간 어느 시점을 기록하고 싶을때 자주 사용된다.
set @curdate = current_timestamp();
prepare myquery from 'insert into mytable values(null,?)';
execute myquery using @curdate;
-- 메모리 해제
deallocate prepare myquery;

select *
	from mytable;