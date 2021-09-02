-- 문제136			
-- 아래와 같은 테이블을 mydb2에 작성하시오			
-- 테이블명 : sungjuk			
-- 열이름	데이터형식		NULL허용	제약조건
-- hakbun	int			X		PK
-- hakname	varchar(10)	X	
-- kor		int 		X	
-- eng		int			X	
-- mat		int			X	
-- tot		int		
-- average	int		
-- ranking	int	
use mydb2;	
drop table if exists sungjuk;
create table sungjuk(
	hakbun	int	not null primary key,
	hakname	varchar(10)	not null,	
	kor		int not null,
	eng		int	not null,
	mat		int	not null,
	tot		int,	
	average	int,
	ranking	int	
);
-- 아래의 데이터를 추가하시오			
-- 1, '일길동', 90 ,70, 80			
-- 2, '김민수', 100 ,80, 60			
-- 3, '김은수', 90 ,75, 88			
-- 4, '하연주', 100 ,100, 34			
-- 5, '오지랍', 100 ,70, 50			
-- 6, '최정연', 90 ,75, 77			
insert into sungjuk values (1, '일길동', 90 , 70, 80, null, null, null);
insert into sungjuk values (2, '김민수', 100, 80, 60, null, null, null);
insert into sungjuk values (3, '김은수', 90 , 75, 88, null, null, null);
insert into sungjuk values (4, '하연주', 100,100, 34, null, null, null);
insert into sungjuk values (5, '오지랍', 100, 70, 50, null, null, null);
insert into sungjuk values (6, '최정연',  90, 75, 77, null, null, null);

select * from sungjuk;

-- 문제137			
-- sungjuk테이블을 이용하여 점수 총합과 평균을 구하는 			
-- 스토어드 프로시져를 구하시오.(단, 커서를 이용하시오.)
-- 프로시져명 : sungjuk_proc()	
drop procedure if exists sungjuk_proc;
delimiter //
create procedure sungjuk_proc()
begin
	declare tmphakbun int default 0;
    declare tmpkor int default 0;
    declare tmpeng int default 0;
    declare tmpmat int default 0;
    declare tmptot int default 0;
    declare tmpavg int default 0;
    
    declare endofrow boolean default false;
    
    declare sungjuk_cursor cursor for
    
    select hakbun,kor,eng,mat
		from sungjuk;
        
	declare continue handler 
		for not found set endofrow = true;
        open sungjuk_cursor;
        
        cursor_loop : loop
        fetch sungjuk_cursor into tmphakbun, tmpkor, tmpeng, tmpmat;
        
        if(endofrow) then
        leave cursor_loop;
        end if;
        
	set tmptot = tmpkor + tmpeng + tmpmat;
    set tmpavg = tmptot /3; 
    
	update sungjuk 
		set tot = tmptot, average = tmpavg
		where hakbun = tmphakbun;    
         
    end loop cursor_loop;
    close sungjuk_cursor;
end //
delimiter ;

call sungjuk_proc();
select * from sungjuk;

-- 문제138			
-- sungjuk테이블의 총합을 기준으로 하여 rank(순위)를 추가하는 			
-- 프로시져를 만들어보시오.(역시, 커서를 이용합니다.)
-- 프로시져명 : rank_proc()	

drop procedure if exists rank_proc;
delimiter //
create procedure rank_proc()
begin
	declare tmprank int default 0;
    declare tmphakbun int;

	declare endofrow boolean default false;
	declare rank_cursor cursor for
      
    select hakbun
		from sungjuk
        order by tot desc;
        
	declare continue handler 
		for not found set endofrow = true;
        
        open rank_cursor;
        
		cursor_loop : loop
		fetch rank_cursor into tmphakbun;
    
		if(endofrow) then
		leave cursor_loop;
		end if;
        
     set tmprank = tmprank+1;
     
     update sungjuk 
		set ranking = tmprank
        where hakbun = tmphakbun; 
        
	end loop cursor_loop;
    close rank_cursor;
end //
delimiter ;

  call rank_proc();
select * from sungjuk;

-- 문제139			
-- 두 개의 정수와 연산자(+, -, /, *, /, %)를 매개변수로 받아서 			
-- 실행되는 스토어드 함수를 만들어보시오.(단 리턴값은 int형으로 합니다.)	
-- 함수명 : calc_func();		
-- select 함수명(10, 5, '%')	
show global variables like 'log_bin_trust_function_creators';
set global log_bin_trust_function_creators =1;
drop function if exists calc_func;
delimiter //
create function calc_func(value1 int, value2 int, op varchar(5))
	returns int
begin

    if(op ='+')then
       return value1 + value2;
       
	elseif (op ='-')then
      return value1 - value2;
      
	elseif (op ='/')then
      return value1 / value2;

	elseif (op ='*')then
      return value1 * value2;
      
	elseif (op ='%')then
      return value1 % value2;
      
	end if;
end //
delimiter ;
select calc_func(10,5,'-');


-- 문제140			
-- 커서를 이용하여 mydb에 있는 emp테이블의 내용을 또 다른 테이블을 만들어서 모두 출력하는
-- 프로시져를 만들어 보시오.	
-- 프로시져명 : print_proc();			
-- 출력결과			
-- 0	
use mydb;
select *
	from emp;

drop table if exists print_emp;
create table print_emp(
	tempno int,
    tename varchar(20),
    tjob varchar(8),
    tmgr varchar(10),
    thiredate date,
    tsal int,
    tcomm int,
    tdeptno int
);

drop procedure if exists print_proc;
delimiter //
create procedure print_proc()
begin
	declare tmp_empno int;
    declare tmp_ename varchar(20);
    declare tmp_job varchar(8);
    declare tmp_mgr varchar(10);
    declare tmp_hiredate date;
    declare tmp_sal int;
	declare tmp_comm int;
    declare tmp_deptno int;
    
    declare endofrow boolean default false;
    
    declare print_cursor cursor for
    
    select *
		from emp;
        
	declare continue handler 
		for not found set endofrow = true;
        
		open print_cursor;
        
		cursor_loop : loop
		fetch print_cursor into tmp_empno, tmp_ename, tmp_job, tmp_mgr, tmp_hiredate, tmp_sal, tmp_comm, tmp_deptno;
        
	if(endofrow) then
		leave cursor_loop;
		end if;
        
	insert into print_emp values(tmp_empno, tmp_ename, tmp_job, tmp_mgr, tmp_hiredate, tmp_sal, tmp_comm, tmp_deptno);
    
    end loop cursor_loop;
    close print_cursor;
    
end // 
delimiter ;
call print_proc();
select *
	from print_emp;

-- 문제141			
-- 커서를 이용하여 또 다른 테이블을 이용하여, emp테이블의 보너스(comm)를 받는 
-- 사원명, 부서명, 급여, 보너스를 출력하는 프로시져를 만들어보시오.
-- 프로시져명 : comm_proc()
drop table if exists print_table_2;
create table print_table_2(
	print_ename varchar(20),
	print_deptno_ int,
    print_sal int,
    print_comm int,
    print_dename varchar(14)
);


drop procedure if exists comm_proc;
delimiter //
create procedure comm_proc()
begin
	
    declare tmp_ename varchar(20);
	declare tmp_deptno int;
    declare tmp_sal int;
	declare tmp_comm int;
    declare tmp_dename varchar(14);

    
    declare endofrow boolean default false;
    declare print_cursor2 cursor for
    
    select E.ename,E.deptno,E.sal,E.comm,D.dename
		from emp as E
        inner join dept as D
        on E.deptno = D.deptno
        where E.comm is not null
        and E.comm != 0;
                
    	declare continue handler 
        
		for not found set endofrow = true;
		open print_cursor2;
        
        cursor_loop : loop
       
        fetch print_cursor2 into  tmp_ename, tmp_deptno, tmp_sal, tmp_comm,tmp_dename;
        
        if(endofrow) then
		leave cursor_loop;
		end if;
		
        insert into print_table_2 values(tmp_ename, tmp_deptno, tmp_sal, tmp_comm,tmp_dename);
       
	end loop cursor_loop;
    close print_cursor2;
    
end //
delimiter ;
call comm_proc();

select *
	from print_table_2;



