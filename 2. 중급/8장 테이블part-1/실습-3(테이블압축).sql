
drop database if exists compressdb;
create database compressdb;

use compressdb;

-- 테이블 생성
drop table if exists normaltbl;
create table normaltbl(
	emp_no int,
    first_nme varchar(14)
) ;

-- 테이블을 생성하는데 row_format = compressed를 설정을 하며 
-- 이 티이블은 앞으로 물리적(하드웨어)으로 데이터를 압축하여 저장하겠다라는 의미.
drop table if exists compresstbl;
create table compresstbl(
	emp_no int,
    first_nme varchar(14)
) row_format = compressed; -- 압축해서 사용하겠다 라는 의미가 된다.


insert into normaltbl(
					select emp_no,first_name
						from employees.employees);
-- 데이터가 저장이 되면서 압축과정을 거치기 때문에 normaltbl에
-- 비해 느린편이다.
insert into compresstbl(
					select emp_no,first_name
						from employees.employees);
                        
                        
show table status from compressdb;


-- compresstbl의 용량은 약 7.4mb
-- normaltbl의 용량은 약 11.51mb
-- 확인해보면 확실히 compresstbl이 normaltbl 보다 압축이되어서
-- data_length가 45%정도가 물리저 공간을 절약하고 있는것을
-- 볼 수가 있다. 하지만 압축테이블은 기존 테이블에 비해서 성능이 좀
-- 떨어지는 경향과 더불어 데이터가 깨질 확률도있다.
-- 서버의 공간을 절약하고 싶을때 쓸수가 있다.(추천 XX 안정성이 떨어지기 때문 데이터 꺠지면 머리아픔)
