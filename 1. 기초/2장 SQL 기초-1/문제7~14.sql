-- 문제 7
-- 만들어놓은 mydb에 아래와 같이 테이블을 만들어라.
-- 테이블명 : videotbl
-- 열이름	    데이터형식	NULL허용	PK	기타
-- video_id int	       x	O	자동증가(1에서부터 시작)
-- title	varchar(20)	x	x	
-- genre	varchar(8)	x	x	
-- star	varchar(10)	O	X	
use mydb;
drop table if exists videotbl;
create table videotbl(
	video_id int not null auto_increment,
    title varchar(20) not null,
    genre varchar(8) not null,
    star varchar(10),
    primary key(video_id)
);
-- 문제8
-- 만들어진 videotbl테이블에 아래의 데이터를 삽입하라
-- null, '태극기휘날리며', '전쟁', '장동건'
-- null, '대부', '액션', null
-- null, '반지의제왕', '액션', '일라이저우드'
-- null, '친구', '액션', '유오성'
-- null, '해리포터', '환타지', '다니엘'
-- null, '형', '코미디', '조정석'
insert into videotbl values 
	(null, '태극기휘날리며', '전쟁', '장동건'),
	(null, '대부', '액션', null),
	(null, '반지의제왕', '액션', '일라이저우드'),
	(null, '친구', '액션', '유오성'),
	(null, '해리포터', '환타지', '다니엘'),
	(null, '형', '코미디', '조정석');
select *
  from videotbl;

-- 문제9
--  videotbl 테이블에서 star값이 없는 것만 출력하시오.
	select *
    from videotbl
    where star not in ('null');

-- 문제10
--  videotbl테이블에서 장르가 액션인것만 출력하시오.
	select *
    from videotbl
    where genre ='액션';

-- 문제11
--   videotbl테이블에서 주인공이 유오성이 것만 삭제하시오
 delete from videotbl
 where star = '유오성';
 
 -- 문제12
--   videotbl테이블에서 제목이 형인 것을 동생으로 바꾸시오.
 update videotbl
	set title ='동생'
	where title ='형';
    
-- 문제13
--   videotbl테이블 있는 모든 데이터를 지우시오.
delete from videotbl;

-- 문제14
--   videotbl테이블을 제거하시오.
 drop table videotbl;
  
