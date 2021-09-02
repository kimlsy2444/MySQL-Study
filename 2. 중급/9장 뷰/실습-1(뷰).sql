use sqldb;

-- 아래 코드는 view를 만드는 쿼리이다, 설명하자 면 v_usertbuytbl를 만드는데
-- select문의 내용을 view로 만든다.
-- 매번 아래와 같이 조회를 하게 되면 지속적으로 쿼리를 길게 쳐야될 것이다.
-- 한번 만들고 view를 적절히 잘 활용을 하면 될 것이다.

 create view v_userbuytbl
 as
	select U.userid as'USER ID', U.username as 'USER NAME',B.prodname as 'PROD NAME',
		   U.addr as '주소', concat(U.mobile1,U.mobile2) as 'MOBILE PHONE'
	from usertbl as U
    inner join buytbl as B
    on U.userid = B. userid;

-- view를 조회를 하니 마치 테이블이 조회되는 것처럼 느낄 수 있다,
-- 뷰테이블이라는 테이블은 다른 내용이며 , 뷰테이블은 실제 테이블을 참조하기 때문에
-- 테이블이 제거가 되면 view도 제거된 거와 같아진다.
select *
	from v_userbuytbl;
    
-- 필드별로 조회를 하고 싶으면 알리아스 준걸로 필드명을 주고 반드시 백틱을 사용하여 감싸야 한다. (`)
-- 공백을 포함하고 있는 알리아스의 경우는 반드시 백틱으로 감싸야 한다.
select `USER ID` ,`USER NAME`,`주소`
	from v_userbuytbl;
    
    
-- 뷰는 읽기전용이다. 하지만 아래와 같이 수정은 가능하다
alter view v_userbuytbl
as 
	select U.userid as'사용자 아이디', U.username as '이름',B.prodname as '제품 이름',
		   U.addr as '주소', concat(U.mobile1,U.mobile2) as '전화번호'
	from usertbl as U
    inner join buytbl as B
    on U.userid = B. userid;
    
select *
	from v_userbuytbl;
    
select `사용자 아이디`,'이름',`제품 이름`,`주소`,`전화번호`
	from v_userbuytbl;
    
-- 뷰 삭제
drop view v_userbuytbl;

-- 다른 뷰 생성
-- or relace가 왔다. 이것은 v_usertbl이 있다면,아래의 코드로 view를
-- 덮어쓰라는 것이다
-- 없다면 만들고..
create or replace view v_usertbl
as 
select userid, username,addr
	from usertbl;
    
select *
	from v_usertbl;
-- 뷰의 구조를 보면 흡사 테이블과 유사하게 되어있다. 하지만 제약조건들은 보이지 않는다는 것을 알수있다.
desc v_usertbl;
desc usertbl;

-- 뷰를 통한 수정
-- 뷰를 통한 수정이 가능하다. 그리고 실제테이블에도 확인해보니 변경이 되어 있다.
update v_usertbl
	set addr = '부산'
    where userid ='LKK';
    
select *
	from usertbl;
-- 하지만 아래코드는 삽입이 되질 않는다.
-- usertbl에는 birthyear필드가 not null 이기 때문이다.
-- 아래 데이터를 꼭 삽입 해주고 싶다면 ,view를 만들때 birthyear컬럼 추가,
-- 혹은  usertbl의 birthyearr 컬럼에 default값을 주던지 null 로 바꿔야 할 것이다.
insert into v_usertbl(userid,username,addr) values('KYA','김연아','경기');

-- 뷰를 birthyear를 포함해서 수정하였다.
create or replace view v_usertbl
as 
select userid, username,addr,birthyear
	from usertbl;

-- 별로 추천되는 방식이 아니다 매우 번거롭고 뷰의 용도는 읽기 전용이기 때문이다.
insert into v_usertbl(userid,username,addr,birthyear) values('KYA','김연아','경기',19900505);

select *
	from v_usertbl;