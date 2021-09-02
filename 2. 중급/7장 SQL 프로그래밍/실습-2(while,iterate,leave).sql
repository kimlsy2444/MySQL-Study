-- while(반복문), iterate(continue문과 동일), leave(반복문을 빠져나가는 break동일)

-- 1~100 까지의 합을 구해보는 코드 작성

drop procedure if exists whileProc;
delimiter //
create procedure  whileProc()
begin
	declare i int;
    declare sum int;
    set i = 1;
    set sum = 0;
    while(i<=100) do
		set sum = sum + i;
		set i = i + 1;
	end while;
    
    select concat('1~100 까지의 합 : ', sum) as '1~100 까지의 합' ;
end //
delimiter ;
call whileProc();

-- 이제는 합계는 구하는데 7의 배수를 제외하고 1000 초과하면 반복문을
-- 빠져나가는 코드 작성
drop procedure if exists whileProc2;
delimiter //
create procedure whileProc2()
begin 
	declare i int;
    declare sum int;
    set i = 0;
    set sum = 0;
    
    mywhile: while(i<=100) do
		if((i % 7 ) = 0 ) then 
			set i = i+1;
            iterate mywhile;
		end if;
        set sum = sum + i;
        if(sum > 1000) then
			leave mywhile;
		end if;
        set i = i+1;
	end while;
    select sum as '7의 배수 제외 100이하 합계';
end //
delimiter ; 

call whileProc2;

-- 구구단 출력하기
drop procedure if exists gugudanProc;
delimiter //
create procedure gugudanProc()
begin
	declare i int;
    declare j int;
    
    set i = 2;
    set j = 1;
    
    while (j<10) do 
		select concat(i,' * ',j=' = ',(i*j)) as '2 *';
        set j = j+1;
        end while;

end //
delimiter ; 
call gugudanProc;