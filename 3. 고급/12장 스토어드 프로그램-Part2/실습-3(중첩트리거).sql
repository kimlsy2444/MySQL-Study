-- 중첩 트리거에 대해서 실습을 해보자
drop database if exists triggerdb;
create database triggerdb;
use triggerdb;

-- 테이블 3개 만들어보자
-- 구매 테이블 생성
drop table if exists ordertbl;
create table ordertbl(
	orderno int auto_increment primary key,  -- 구매일련번호
    userid varchar(5),     -- 구매한 회원아이디
    prodname varchar(5),   -- 구매한 물건
    orderamount int   -- 구매한 개수
);
-- 물품(재고)테이블을 새성
drop table if exists prodtbl;
create table prodtbl(
	prodname varchar(5),   -- 물품이름
    count int,             -- 물품 개수
    warehousing datetime
);
-- 배송 테이블 생성
drop table if exists delivertbl;
create table delivertbl(
	deliverno int auto_increment primary key, -- 배송일련번호
	prodname varchar(5),   -- 배송할 물품 이름
    count int              -- 배송할 물품 개수    
);
delete from prodtbl;
-- 물건을 팔기 위해서는 당연히 재고가 있어야 하므로 아래와 같이 삽입한다.
insert into prodtbl values('사과', 100, sysdate());
insert into prodtbl values('배', 100, sysdate());
insert into prodtbl values('귤', 100, sysdate());

select *
  from prodtbl;
  
-- 이제 중첩 트리거를 만들어 구매테이블과 물품테이블에 부착하자.
-- 구매테이블에 구매가 발생(insert)이 되면 물품 테이블에서 재고를 감소시키는 트리거 생성
drop trigger if exists ordertrg;
delimiter //
create trigger ordertrg
	after insert
    on ordertbl
    for each row
begin
	-- 현재 있는 재고 - 주문 개수를 하면 현 재고가 다시 업데이트가 될 것이다.
    -- 이 update문이 실행되면, prdtrg트리거도 자동 실행된다.
    -- 이것이 바로 중첩 트리거인 것이다.
	update prodtbl
       set count = count - new.orderamount, warehousing = sysdate()
	 where prodname = new.prodname;
end //
delimiter ;

drop trigger if exists prdtrg;
delimiter //
create trigger prdtrg
	after update
    on prodtbl
    for each row
begin
	declare orderamount int;
    -- 주문개수를 연산하는데 기존의 재고가 100(old.count)이고,
    -- 만약 주문이 10개 들어와서 위의 ordertrg가 실행되면 update후의 값은
    -- 90(new.count)이 된다.
    -- update시에는 2개의 임시테이블이 만들어진다라고 하였다.
    -- 100 - 90 을 하면 주문개수, 즉 배송할 개수가 되는 것이다.
    set orderamount = old.count - new.count;
    -- 배송테이블에 물품명과 배송개수를 삽입하고 있다.
    insert into delivertbl values (null, new.prodname, orderamount);    
end //
delimiter ;

-- 아래와 같이 고객이 주문을 한다(ordertbl에 데이터 삽입되는 것이다)
-- 중첩트리거가 자동 실행된다.
insert into ordertbl values (null, '신은혁', '사과', 10);
insert into ordertbl values (null, '신은비', '배', 101);

-- 각각의 테이블 확인해보면 역시 트리거에 설정한데로 데이터가 
-- 잘 들어가 있음을 볼 수가 있다.
select * from ordertbl;
select * from prodtbl;
select * from delivertbl;

delete from ordertbl;
delete from delivertbl;

-- 아래와 같이 컬럼을 삭제를 했다.
-- 단, 컬럼명 변경으로 인한 트리거의 실행적인 측면에서는 문제가 없었다.(8.0)
alter table delivertbl
	drop productname;

alter table delivertbl
	add productname varchar(5) after deliverno;


select * from delivertbl;

-- 컬럼을 삭제를 하니 아래와 같이 중첩트리거는 하나도 실행되지 않은 결과를 볼
-- 수가 있다.이건 연결된 하나의 작업으로 보아야 하기 때문이다.
insert into ordertbl values (null, '김말자', '귤', 7);

select * from ordertbl;
select * from prodtbl;
select * from delivertbl;

