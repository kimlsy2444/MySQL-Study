-- mydb를 이용하세요.
use mydb;
-- 문제125			
-- emp테이블이 이용하여 사원번호와 이름을 조회하는 프로시져를 만들어보시오			.
-- 아울러 만든 프로시져를 호출하여 출력결과를 확인하시오.			
-- 프로시져명 : q125
drop procedure if exists q125;
delimiter //
create procedure q125()
begin
	select empno, ename
		from emp;
end //
delimiter ;
call q125();


-- 문제126			
-- emp테이블을 이용하여, 프로시져 호출시 ename을 매개변수 값으로 주면 프로시져에서 			
-- 매개변수 값에 해당하는 행의 모든 값을 출력하는 프로시져를 만들어보시오.			
-- 프로시져명 : q126
drop procedure if exists q126;
delimiter //
create procedure q126(in in_ename char(10))
begin
    select *
		from emp
        where ename = in_ename;
end //
delimiter ;
call q126('김사랑');


 			
-- 문제127
-- dept테이블을 이용하여, 프로시져 호출시 dname을 매개변수 값으로 주면 프로시져에서  			
-- 매개변수 값에 해당하는 행의 모든 값을 출력하는 프로시져를 만들어보시오.			
-- 아울러 만든 프로시져를 호출하여 출력결과를 확인하시오.
-- 프로시져명 : q127	
drop procedure if exists q127;
delimiter //
create procedure q127(in in_dname char(10))
begin
    select *
		from dept
        where dename = in_dname;
end //
delimiter ;
call q127('경리부');

-- 문제128
-- emp테이블을 이용하여, 프로시져 호출시 매개변수가 직급, 입사년도를 입력 시에 직급이 
-- 사원이면서, 입사년도가 2004-01-01이후에 입사한 행을 출력하는 프로시져를 만들어 
-- 보시오. 아울러 만든 프로시져를 호출하여 출력결과를 확인하시오.
-- 프로시져명 : q128			
drop procedure if exists q128;
delimiter //
create procedure q128(in in_job char(10),in in_hiredate date)
begin
    select *
		from emp
        where in_job = job and in_hiredate >= '2004-01-01';
end //
delimiter ;
call q128('사원','2004-01-01');
select *
	from emp;

            
            
-- 문제129
-- emp테이블을 이용하여 매개변수를 사원번호를 주면 그 사원이름을 출력하는 프로시져를 
-- 작성해보시오	. ex) call 프로시져명(사원번호, 변수)			
-- 아울러, 리턴받은 변수값을 이용하여 출력해보시오.
-- 프로시져명 : q129
drop procedure if exists q129;
delimiter //
create procedure q129(in in_empno int , out out_ename varchar(10))
begin
    select ename into out_ename
		from emp
        where in_empno = empno;
end //
delimiter ;
call q129(1001, @answer);
select (@answer);
select *
	from emp;
    
    
-- 문제130(if, elseif, else이용)			
-- emp테이블을 이용하여, 매개변수로 이름을 주어, 직급이 부장 이상이면 "이제 정년이 
-- 다되어가는군요!"를 출력하고, 대리에서 차장까지는 "더욱더 분발하셔야겠네요"를 출력하며,			
-- 사원은 "초지일관 하세요"를 출력하는 프로시져를 만들어보시오.			
-- ex) call 프로시져('박중훈');			
-- 이제 정년이 다되어가는군요!			
-- 프로시져명 : q130 
drop procedure if exists q130;
delimiter //
create procedure q130(in in_ename varchar(10))
begin
	declare message varchar(30);
    declare in_job varchar(10);
    
    select job into in_job
		from emp
        where in_ename = ename;
        
   if(in_job = '사장' or in_job = '부장') then
		set message = '이제 정년이 다 되어가는군요!';
	 elseif(in_job = '차장' or in_job = '과장' or in_job = '대리') then
		set message = '더욱더 분발하셔야겠네요';
	 else
		set message = '초지일관 하세요';
	 end if;
        select message;
        
end //
delimiter ;
call q130('박중훈');
call q130('김사랑'); 			

-- 문제131			
-- 문제130의 내용을 case문으로 작성해보세요.			
-- 프로시져명 : q131
drop procedure if exists q131;
delimiter //
create procedure q131(in in_ename varchar(10))
begin
	declare message varchar(30);
    declare in_job varchar(10);
    
    select job into in_job
		from emp
        where in_ename = ename;
	case 
		when(in_job = '사장')  then
			set message = '이제 정년이 다 되어가는군요!';
		when(in_job = '부장')  then
			set message = '이제 정년이 다 되어가는군요!';
		when(in_job = '과장')  then
			set message = '더욱더 분발하셔야겠네요';
		when(in_job = '차장')  then
			set message = '더욱더 분발하셔야겠네요';
		when(in_job = '대리')  then
			set message = '더욱더 분발하셔야겠네요';
		else
			set message = '초지일관 하세요';
    end case;
		      select message;
  
        
end //
delimiter ;
call q131('박중훈');
call q131('김사랑'); 		
 			
-- 문제132			
-- 아래와 같이 테이블을 만들어라. 			
-- 테이블명 : multiple			
-- 컬럼			데이터타입		제약조건	기타
-- no			int			pk		자동증가
-- prime_number	int		

create table if not exists multiple(
	no int auto_increment primary key,
    prime_number int
);    

-- 문제133			
-- 위의 multiple테이블을 이용하여 소수(1과 자기자신만 나누어지는 것)만 저장하는 
-- 프로시져를 만들어보시오.			
-- 단, 반복문을 이용하며 루프의 끝은 1000으로 합니다.			
-- 그리고 저장되어진 multiple문을 조회하여 맞는지 직접 확인합니다.			
-- ex)call 프로시져명();			
-- select * from multiple;			
-- no	소수		
-- 1 	1 		
-- 2 	2 		
-- 3 	3 		
-- 4 	4 		
-- 5 	7
-- 6   11		
-- -- 위의 내용은 결과의 일부를 보여준 것이다. 1000까지 조회가 되어야 합니다.			
-- 프로시져명 : q133

drop procedure if exists q133;
delimiter //
create procedure q133()
begin
	declare i int;
    declare n int;
    declare count int;
    
    set i = 2;
    set n = 1;
    set count = 0;
    
    insert into multiple values(null,1);
    while(i<=1000) do
		set count = 0;
        set n = 1;
        
        while(n<=i) do
			if( n % i = 0 ) then
				set count = count + 1;
			end if;
            set n = n + 1;
		end while;
        
        if(count = 2) then
			insert into multiple values(null, i);
		end if;
        set i = i + 1;
	end while;
        
    
end //
delimiter ;

call q133();

            
 			
-- 문제134
-- 동적 sql문을 이용하여 매개변수로 emp테이블을 주면 직급이 사원인 행을 			
-- 출력하는 프로시져를 작성하시오.			
-- 프로시져명 : q134
-- ex)call 프로시져명('emp');			
-- 출력결과			
-- 1001 김사랑 사원 1013 2007-03-01 300  20
-- 1011 조향기 사원 1007 2007-03-01 280  30
-- 1012 강혜정 사원 1006 2007-08-09 300  20
-- 1014 조인성 사원 1006 2007-11-09 250  10
drop procedure if exists q134;
delimiter //
create procedure q134(in in_tblname varchar(10))
begin
	set@job = '사원';
	set @myquery = concat('select * from ', in_tblname, ' where job=', '@job');

	prepare myquery from @myquery;
    execute myquery;			
    deallocate prepare myquery; 
    
end //
delimiter ;

call q134('emp');
			
-- 문제135			
-- emp테이블의 컬럼 값 중에 ename을 매개변수로 주어 부서가 영업부이면,급여를 10프로 인상하고 			
-- 아니라면 5프로를 인상하는 프로시져를 작성하시오.			
-- ex)call 프로시져명('김사랑');			
-- 위와 같이 호출하면 김사랑만 급여가 인상 되게 하는 것이다.
-- 프로시져명 : q135
drop procedure if exists q135;
delimiter //
create procedure q135(in in_ename varchar(10))
begin
	declare in_dename varchar(14);
	
    select D.dename , in_dename
		from emp as E
        inner join dept D
        on E.deptno = d.deptno
        where e.ename = in_ename;
        
        if(in_dename ='영업부')then
			update emp set sal = sal*1.1 where ename = in_ename;
         else
			update emp set sal = sal*1.05 where ename = in_ename;
		end if;
        

end //
delimiter ;

call q135('김사랑');
call q135('한예슬');
select *
	from emp;





