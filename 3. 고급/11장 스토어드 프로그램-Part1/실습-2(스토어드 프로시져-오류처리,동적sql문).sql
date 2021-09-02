use sqldb;
-- 스토어드 프로시져에서 오류처리에 관련된 코드
drop procedure if exists erroproc;
delimiter //
create procedure erroproc()
begin
	declare i int;
    -- 합계(정수형) 오버플로우 발생 예정 (오류처리 핸들러 작동)
    declare sum int; 
    -- 합계(정수형), 오버플로 직접의 값을 출력하는 용도
    declare savesum int;
    -- 오버플로우 발생하면 실행하는 handler를등록
    declare exit handler for sqlexception 
    begin
        show errors; -- 오류코드를 보여준다
		select concat('int 데이터 타입의 오버플로우 직접의 합계 : ',savesum);
        select concat('오버플로우 직전의 i 값 : ',i);
     
    end;
    
    set i = 0;
    set sum = 0;
    -- 아래 반복분은 무한루프를 돈다.
    while (true)do
		set savesum = sum; -- 오버플로우 직전의 합계
        set sum = sum + i; -- 오버플로우 발생 예정 발생하면 핸들러 실행
        set i = i + 1;
        end while;
end //
delimiter ;

call erroproc();
-- 만들어 놓은 프로시져의 즉 현재 저장된 프로시져의 이름 및 내용을 알고자 할때는
-- 아래와 같이 시스템 DB 이용하여 출력해보면 된다.

select routine_name, routine_definition
	from information_schema.routines -- 시스템DB의 routines라는 테이블 
    where routine_schema = 'sqldb'
		and routine_type ='PROCEDURE';
        
-- 프로시져의 매개변수의 값을 알고자 한다면 시스템DB를 이용하면 된다.
select specific_name, parameter_mode,data_type ,dtd_identifier 
	from information_schema.parameters;
    
-- 특정 DB에 있는 특정 프로시져만 보고 싶다면 아래 코드로 작성을 하면 된다.
show create procedure sqldb.userproc3;

-- 테이블명을 입력 매개변수로 가지는 코드
drop procedure if exists nameproc;
delimiter //
create procedure nameproc(in tblname varchar(20)) -- 테이블이름이 매개변수
begin
	declare exit handler for sqlexception 
    begin
		show errors;
	end;
  
	select concat('tblname : ', tblname);
    select *
		from tblname;
end //
delimiter ;
-- 호출을 해보면 오류가 난다.
-- 원래 기본적으로 매개변수으로는 테이블명은 넘어갈 수가 없다.
call nameproc('usertbl');

-- 위와 같은 경우는 동적 sql문을 이용해서 사용하면 된다.
drop procedure if exists nameproc;
delimiter //
create procedure nameproc(in tblname varchar(20)) -- 테이블이름이 매개변수
begin
	set @sqlquery = concat('select * from ',tblname);
    -- 동적sql 구문을 myquery에 준비한다.
    prepare myquery from @sqlquery;
    execute myquery;			-- 준비된 sql문을 실행한다.
    deallocate prepare myquery; -- 메모리에 할당된 동적 sql문을 해제한다.
    
end //
delimiter ;
