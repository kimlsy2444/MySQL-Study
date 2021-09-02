-- 전체 텍스트 검색을 한번 알아보자.

-- 먼저 token사이즈를 한번 알아보자
-- 아래와 같이 실행을 해보면 현재 토큰 사이즈가 3으로 되어 있다.
-- 영어단어라면 크게 문제가 되지 않겠지만, 사이즈가 3이라면
-- 1, 2단어는 전체 텍스트 검색을 허용하지 않는다.
-- 하지만, 우리 한글은 보통 2글자부터 검색을 많이 하니
-- my.ini에서 innodb_ft_min_token_size를 2로 설정을 하자.
-- 가장 마지막 부분에 추가를 하자.
-- my.ini파일의 경로 : C:\ProgramData\MySQL\MySQL Server 8.0
-- 값을 수정하고 난 뒤 반드시 mysql서비스를 중지하고 다시 시작하도록 하자.
-- 워크벤치도 한번 닫고 새로 시작하도록 하자.
show variables like 'innodb_ft_min_token_size';

create database if not exists fulltextdb;
use fulltextdb;

drop table if exists fulltexttbl;
create table fulltexttbl(
	id int auto_increment primary key,  -- 일련번호
    title varchar(30) not null,  -- 영화 제목
    summary varchar(1000)        -- 영화 내용 요약
);
select *
  from fulltexttbl;
  
-- 15건의 데이터를 추가함.
insert into fulltexttbl values 
		(NULL, '광해, 왕이 된 남자','왕위를 둘러싼 권력 다툼과 당쟁으로 혼란이 극에 달한 광해군 8년'),
		(NULL, '간첩','남한 내에 고장간첩 5만 명이 암약하고 있으며 특히 권력 핵심부에도 침투해있다.'),
		(NULL, '피에타',' 더 나쁜 남자가 온다! 잔혹한 방법으로 돈을 뜯어내는 악마같은 남자 스토리.'),
		(NULL, '레지던트 이블 5','인류 구원의 마지막 퍼즐, 이 여자가 모든 것을 끝낸다.'),
		(NULL, '파괴자들','사랑은 모든 것을 파괴한다! 한 여자를 구하기 위한, 두 남자의 잔인한 액션 본능!'),
		(NULL, '킹콩을 들다',' 역도에 목숨을 건 시골소녀들이 만드는 기적 같은 신화.'),
		(NULL, '테드','지상최대 황금찾기 프로젝트! 500년 전 사라진 황금도시를 찾아라!'),
		(NULL, '타이타닉','비극 속에 침몰한 세기의 사랑, 스크린에 되살아날 영원한 감동'),
		(NULL, '8월의 크리스마스','시한부 인생 사진사와 여자 주차 단속원과의 미묘한 사랑'),
		(NULL, '늑대와 춤을','늑대와 친해져 모닥불 아래서 함께 춤을 추는 전쟁 영웅 이야기'),
		(NULL, '국가대표','동계올림픽 유치를 위해 정식 종목인 스키점프 국가대표팀이 급조된다.'),
		(NULL, '쇼생크 탈출','그는 누명을 쓰고 쇼생크 감옥에 감금된다. 그리고 역사적인 탈출.'),
		(NULL, '인생은 아름다워','귀도는 삼촌의 호텔에서 웨이터로 일하면서 또 다시 도라를 만난다.'),
		(NULL, '사운드 오브 뮤직','수녀 지망생 마리아는 명문 트랩가의 가정교사로 들어간다'),
		(NULL, '매트릭스',' 2199년.인공 두뇌를 가진 컴퓨터가 지배하는 세계.');


-- '남자'를 앞뒤로 포함하는 단어를 검색해보자.
-- 검색이 빨리된다. 실행계획을 보면 풀테이블 스캔을 한것을 알수가 있다.
-- 데이터가 15개라서 그렇치 1500만 정도의 데이터가 존재한다면 과연 어떨까요?
-- 말할 것도 없이 부하가 상당히 걸릴 것이다.그래서 전체 텍스트 검색을 적용하면
-- 실행속도가 빨라질 것이다.
select *
  from fulltexttbl
where summary like '%남자%';

-- 전체 텍스트 검색을 하기 위해 fulltext index를 생성해보자
create fulltext index idx_summary
	on fulltexttbl(summary);

-- 인덱스를 확인해보면 id는 클러스터형 인덱스로 생성되어 있고,
-- 방금 만든 fulltext indext가 summary컬럼에 지정되어 있는 것을
-- 확인했고 그 type이 fulltext로 되어있다.
show index from fulltexttbl;

-- 아래와 같이 '남자'를 검색하는데 자연어 검색이 이루어진거다.
-- 물론 fulltext index를 이용하여 검색이 되었다.
select *
  from fulltexttbl
 where match(summary) against('남자');

-- 이제는 '남자'를 검색하는데 불린모드로 검색을 해보자.
-- 물론 fulltext index를 이용하여 검색이 되었다.
select *
  from fulltexttbl
 where match(summary) against('*남자*' in boolean mode);
 
-- 전체 텍스트 검색을 이용하여 조건절과 비교해서, 검색내용이 매치되는 점수를 아래와 같이
-- 확인해줄수도 있다.
-- 점수가 높을수록 검색의 정확도가 높다는 것을 의미한다.
-- 조건은 내용은 남자로 시작하는 단어이거나 또는 여자로 시작하는 단어를 의미하는 것이다.(or개념)
select *, match(summary) against('남자* 여자*' in boolean mode) as '정확도'
  from fulltexttbl
where match(summary) against('남자* 여자*' in boolean mode);

-- 이제는 필수적으로 들어가게끔 하는 and조건을 한번 이용해보자
-- +는 무조건 들어가는 내용을 의미한다.
select *, match(summary) against('+남자* +여자*' in boolean mode) as '정확도'
  from fulltexttbl
where match(summary) against('+남자* +여자*' in boolean mode);

-- 아래 코드는 남자는 들어가지만 여자로 시작하는 단어는 없는 데이터를 검색해준다.
-- -는 제외하라는 것이다.
select *, match(summary) against('남자* -여자*' in boolean mode) as '정확도'
  from fulltexttbl
where match(summary) against('남자* -여자*' in boolean mode);

-- 중지단어(stopword)에 대해서 한번 알아보자.
-- 먼저 fulltext index에서 얼마나 중지단어가 많어졌는지 한번 보자.
SET GLOBAL innodb_ft_aux_table = 'fulltextdb/fulltexttbl';

-- 아래와 같이 시스템db를 이용해서 검색을 해보면 현재 생성된 단어나 문구가 어떤 것이 있는
-- 한 눈에 파악이 된다.여기서는 130건이 나왔다.
-- 하지만, 확인해보면 '그는','그리고','내에' 등등 머 검색단어로 전혀 활용되지 않을 것 같은 단어들
-- 조차도 만들어져서 index용량만 증가시키고 있는 것이다.
-- 하여, 중지단어를 추가하는 테이블 직접 만들어보고 활용을 해보도록 하자.
select *
  from information_schema.innodb_ft_index_table;

-- 먼저 만들어놓은 fulltext index를 삭제하자.
drop index idx_summary on fulltexttbl;
show index from fulltexttbl;

-- 중지단어 테이블을 만들때는 열이름은 반드시 value로 설정하고 데이터타입은
-- varchar으로 지정을 해야 한다.
drop table if exists user_stopword;
create table user_stopword(
	value varchar(30)
);
insert into user_stopword values ('그는'),('그리고'),('극에');

select *
  from user_stopword;

show variables like 'innodb_ft_server_stopword_table';
-- MySQL에는 기본 중지단어테이블에는 36개의 영어단어가 존재함을 알수가 있다.
select *
  from information_schema.innodb_ft_default_stopword;

-- 아래 코드는 시스템 테이블인 innodb_ft_server_stopword_table에 user_stopword테이블을 지정함.
set global innodb_ft_server_stopword_table = 'fulltextdb/user_stopword';
-- 아래와 같이 확인해보면 user_stopword테이블이 설정됨을 확인할 수가 있다.
show variables like 'innodb_ft_server_stopword_table';

-- 다시 fulltext index를 생성함.
create fulltext index idx_summary on fulltexttbl(summary);
show index from fulltexttbl;

-- 다시 확인해보면 user_stopword테이블에 추가한 중지단어가 빠져있다.
-- 중지단어 테이블을 더욱더 많이 적용시켜주면, 훨씬 fulltext index가 가벼워지고
-- 용량도 적게 차지하게 된다.
select *
  from information_schema.innodb_ft_index_table;

-- 결론은 전체 텍스트 검색은 자주 사용하는 것이 아니라, 텍스트로 이루어진 장편소설,신문,뉴스 등
-- 을 검색할 때 아주 유용하게 쓰면 시스템 성능 향상에 도움이 된다.
-- 하여, 적절히 현업에 가서 경우를 잘 생각해서 사용하면 아주 효율적이다.

