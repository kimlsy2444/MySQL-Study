-- 문제142						
-- 아래와 같은 테이블을 mydb2에 작성하시오.						
-- 테이블명 : emp02(이 테이블이 있다면 삭제하시오)						
-- 열이름		데이터형식		NULL허용	제약조건			
-- empno	int					PK			
-- ename	varchar(10)		X				
-- job		varchar(5)		X		

use mydb2;

drop table if exists emp02;
create table emp02(
 empno	int primary key,							
 ename	varchar(10)  not null,						
 job     varchar(5)  not null		
);

-- 문제143
-- 아래와 같은 테이블을 mydb2에 작성하시오						
-- 테이블명 : backup_emp02(이 테이블이 있다면 삭제하시오)						
-- 열이름		데이터형식		NULL허용	제약조건			
-- empno	int					PK			
-- ename	varchar(10)	X				
-- job		varchar(5) 	X				
-- modtype	varchar(5)	X	신규','수정','삭제'			
-- moddate	datetime	X				
-- moduser	varchar(10)	X	default제약조건으로 root로 설정

drop table if exists backup_emp02;
create table backup_emp02(
 empno	int	primary key,
 ename	varchar(10)	 not null,			
 job		varchar(5) 	not null,					
 modtype	varchar(5)	not null,		-- 신규','수정','삭제'			
 moddate	datetime	not null,				
 moduser	varchar(10)  default 'root'
);


-- 문제144
-- emp02테이블에 아래와 같이 데이터를 입력했을때						
-- 출력결과를 나타내는 트리거를 작성하시오.
-- 트리거명 : emp_inserttrg						
-- insert into emp02 values(1, '김연아', '과장');						
-- 아울러, insert후 backup_emp02테이블에 데이터를 삽입을 하는 구문도 같이 작성하시오. 
-- 단 modtype은 '신규'라고 합니다.					
-- 출력결과						
-- 김연아과장님이 입사하셨습니다.		

drop trigger if exists emp_inserttrg;
delimiter //
create trigger emp_inserttrg
    after insert
    on emp02
    for each row
    
    begin
	set @message =  concat(new.ename,new.job,"님이 입사하셨습니다.");
	insert into backup_emp02 values (new.empno, new.ename,new.job,"신규",sysdate(),default);
    end //
delimiter ;

insert into emp02 values(1, '김연아', '과장');

select * from emp02;
select * from backup_emp02;
select @message;

-- 문제145						
-- emp02테이블에 아래와 같이 데이터를 입력했을때 아래와 같이						
-- 출력결과를 나타내는 트리거를 작성하시오.
-- 트리거명 : emp_updatetrg						
-- update emp02 set job = '차장' where empno = 1;						
-- 아울러, insert후 backup_emp02테이블에 데이터를 삽입을 하는 구문도 같이 작성하시오. 
-- 단 modtype은 '수정'라고 합니다.						
-- 출력결과						
-- 김연아과장님이 차장으로 승진하셨습니다.		
drop trigger if exists emp_updatetrg;
delimiter //
create trigger emp_updatetrg
	after update
    on emp02
    for each row
	
    begin
	set @message =  concat(old.ename,old.job,"님이 ",new.job,"으로 승진하셨습니다.");
	update backup_emp02
	set modtype = "수정"
    where empno = old.empno;
    end //
delimiter ;



select * from emp02;

update emp02 
   set job = '차장'
where empno = 1;

select * from backup_emp02;
select @message;

-- 문제146
-- emp02테이블에 아래와 같이 데이터를 입력했을때						
-- 출력결과를 나타내는 트리거를 작성하시오.
-- 트리거명 : emp_deletetrg												
-- 아울러, insert후 backup_emp02테이블에 데이터를 삽입을 하는 구문도 같이 작성하시오. 
-- 단 modtype은 '삭제'라고 합니다.			
-- delete from emp02 where empno = 1;						
-- 출력결과						
-- 김연아 차장님이 퇴사하셨습니다.		
drop trigger if exists emp_deletetrg;
delimiter //
create trigger emp_deletetrg
	after delete
    on emp02
    for each row
	
    begin
	set @message =  concat(old.ename,old.job,"님이 퇴사하셨습니다.");
	update backup_emp02
	set modtype = "삭제"
    where empno = old.empno;
    end //
delimiter ;

select * from emp02;

delete 
	from emp02
	where empno = 1;

select *
  from backup_emp02;
select *
  from emp02;




-- 문제147						
-- 아래와 같은 테이블을 mydb2에 작성하시오						
-- 테이블명 : producttbl(이 테이블이 있다면 삭제하시오)						
-- 열이름		데이터형식		NULL허용	제약조건			
-- prodcode	varchar(10)			PK			
-- prodname	varchar(10)	X				
-- maker	varchar(10)	X				
-- price	int			X		판매단가임		
-- stock	int					default제약조건으로 0지정		

drop table if exists producttbl;
create table producttbl(
 prodcode	varchar(10) primary key,			
 prodname	varchar(10)	not null,				
 maker		varchar(10)	not null,				
 price		int	 		not null,		
 stock		int 		default 0
);



-- 문제148
-- 아래와 같은 테이블을 mydb2에 작성하시오						
-- 테이블명 : ordertbl(이 테이블이 있다면 삭제하시오)						
-- 열이름		데이터형식		NULL허용	제약조건			
-- orderno		int				자동증가	PK			
-- userid	varchar(10)		X				
-- prodname	varchar(10)		X				
-- order_count	int			X		

drop table if exists ordertbl;
create table ordertbl(
 orderno		int auto_increment primary key,
 userid			varchar(10)not null,				
 prodname		varchar(10)not null,			
 order_count	int not null
);


-- 문제149
-- 아래와 같은 테이블을 mydb2에 작성하시오						
-- 테이블명 : warehousingtbl(이 테이블이 있다면 삭제하시오)						
-- 열이름		데이터형식		NULL허용		제약조건			
-- num		int						자동증가	PK			
-- warecode	varchar(10)		X				
-- prodname	varchar(10)		X				
-- waredate	datetime		X	 	default제약조건으로 now()설정		
-- warecount	int			X				
-- wareprice	int			X		생산단가이므로 판매단가와 가격차이가 있다.	

drop table if exists warehousingtbl;
create table warehousingtbl(
	num int auto_increment primary key,
    warecode varchar(10) not null,
    prodname varchar(10) not null,
    waredate datetime not null default now(),
    warecount int not null,
    wareprice int not null
); 	 



-- 문제150
-- 아래와 같은 테이블을 mydb2에 작성하시오						
-- 테이블명 : shipmenttbl(이 테이블이 있다면 삭제하시오)						
-- 열이름		데이터형식		NULL허용	제약조건			
-- num		int					자동증가	PK			
-- warecode	varchar(10)		X				
-- shipdate	datetime		X	default제약조건으로 now()설정		
-- shipcount	int			X				
-- shipprice	int			X	판매단가가 들어가야됨	

drop table if exists shipmenttbl;
create table shipmenttbl(
 num		int				auto_increment primary key,
 warecode	varchar(10)		not null,				
 shipdate	datetime		not null default now(),	-- default제약조건으로 now()설정		
 shipcount	int				not null,				
 shipprice	int				not null	-- 판매단가가 들어가야됨		
);




-- 문제151
-- producttbl테이블에 아래와 같이 데이터를 추가하시오
-- (values의 설정은 prodcode, prodname, maker, price임, 
-- stock은 추가하지 않고 0값을 나오게 한다.)						
-- A00001, 세탁기, LG, 500						
-- A00002, 컴퓨터, LG, 700						
-- A00003, 에어콘, LG, 1200						
-- A00004, 냉장고, 삼성, 1250						
-- 제대로 들어갔는지 조회해보시오. 단, stock는 0로 다 나와야 한다.		


insert into producttbl values ('A00001', '세탁기', 'LG', 500, default); 						
insert into producttbl values ('A00002', '컴퓨터', 'LG', 700, default); 						
insert into producttbl values ('A00003', '에어콘', 'LG', 1200, default); 						
insert into producttbl values ('A00004', '냉장고', '삼성', 1250, default); 		

select *
	from producttbl;

-- 문제152						
-- warehuosingtbl테이블에 트리거를 부착해보자.						
-- 트리거의 기능은 warehousingtbl테이블에 데이터를 아래와 같이 삽입했을때,
-- producttbl의 stock이 update되는 것이다. 	
-- 트리거명 : warehousing_inserttrg					
-- insert into warehousingtbl(num, warecode, prodname, warecount, wareprice) 
-- values(null, 'A00001', '세탁기', 100, 320), 						
--       (null, 'A00002', '컴퓨터', 50, 500),
-- 		 (null, 'A00003', '에어콘', 70, 950),
-- 		 (null, 'A00004', '냉장고', 80, 1000);
-- 아울러, warehousingtbl테이블을 조회하면 위에 데이터를 입력하면 입고 날짜및 시간이 
-- 바로 출력이 된다.확인해보자						
-- 그리고, producttbl테이블이 트리거에 의해 stock가 update가 되었는지도 확인해보자.
drop trigger if exists warehousing_inserttrg;
delimiter //
create trigger warehousing_inserttrg
	after insert
    on warehousingtbl
    for each row
begin
	update producttbl
	   set stock = stock + new.warecount
	 where prodcode = new.warecode;
end //
delimiter ;

insert into warehousingtbl(num, warecode, prodname, warecount, wareprice) 
 values(null, 'A00001', '세탁기', 100, 320), 						
       (null, 'A00002', '컴퓨터', 50, 50),
 	   (null, 'A00003', '에어콘', 70, 950),
	   (null, 'A00004', '냉장고', 80, 1000);
select *
  from warehousingtbl;
select *
  from producttbl;



-- 문제153
-- 이제 producttbl테이블에 재고(stock)이 다 채워졌다. 물론 warehousingtbl테이블에 
-- 자동 입고되면 트리거에 의해서 말이다.						
-- 그럼 이제 ordertbl테이블에 아래와 같이 데이터를 입력(주문)했을때, 각각 
-- producttbl테이블의 stock이 update가 되는 트리거를 작성하고, 아울러
-- producttbl테이블의 update가 수행되면 자동으로 shipmenttbl(출하)테이블에
-- 데이터가 삽입되는 트리거를 만들어보시오.
-- 트리거명1 : ordertbl_inserttrg
-- 트리거명2 : producttbl_updatetrg						
-- insert into ordertbl values (null, '김기수','세탁기',20);	

drop trigger if exists ordertbl_inserttrg;
delimiter //
create trigger ordertbl_inserttrg
	after insert
    on ordertbl
    for each row
begin
	declare product_stock int;
    select stock into product_stock
      from producttbl
	 where prodname = new.prodname;



	if(product_stock >= new.order_count) then
	update producttbl
		set stock = stock - new.order_count
		where prodname = new.prodname;
	end if;
    
end //
delimiter ;


drop trigger if exists producttbl_updatetrg;
delimiter //
create trigger producttbl_updatetrg
	after update
    on producttbl
    for each row
begin
	insert into shipmenttbl values(null,old.prodcode,default,(old.stock- new.stock),(old.stock- new.stock)* new.price);
end //
delimiter ;
insert into ordertbl values (null, '김기수','세탁기',20);	

select * from ordertbl;
select * from producttbl;
select * from shipmenttbl;	


-- 문제154						
-- 아래와 같이 ordertbl(주문)에 데이터가 또 들어왔는데, 그 order data를 삭제했을때 
-- producttbl의 stock(재고)이 update되는 트리거를 producttbl테이블에 부착시키시오						
-- 트리거명 : ordertbl_deletetrg

drop trigger if exists ordertbl_deletetrg;
delimiter //
create trigger ordertbl_deletetrg
	after delete
    on ordertbl
    for each row
begin
	update producttbl
		set stock = stock + old.order_count
		where prodname = new.prodname;
end //
delimiter ;


select * from ordertbl;
select * from producttbl;
select * from shipmenttbl;	

delete from ordertbl
where orderno = 2;



