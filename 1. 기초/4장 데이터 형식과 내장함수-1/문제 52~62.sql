-- 문제52
-- 'Welcome to MySQL'을 대문자, 소문자로 각각 변경하시오
select upper('Welcome'),lower('Welcome');

-- 문제53
-- 문자 C를 아스키코드값으로 출력하시오.
select ascii('C');

-- 문제54
-- 문자열 '안녕하세요'의 바이트수를 출력하시오.
select length('안녕하세요');

-- 문제55
-- 문자열 '안녕하세요'의 문자의 수를 출력하시오.
select char_length('안녕하세요');

-- 문제56
-- 문자열 '안녕하세요', 공백 2개, '반갑습니다'의 문자열을 연결하여 출력하시오.
select concat('안녕하세요',space(2),'반갑습니다');

-- 문제57
-- 문자열 '안녕하세요'의 문자열에서 '하'의 위치를 출력하시오.
select instr('안녕하세요','하');

-- 문제58
-- 숫자 121245.78945를 소숫점 3자리로 출력하시오.
select format(121245.78945,3);


-- 문제59
-- 숫자 100을 8진수, 16진수, 2진수로 출력하시오.
select bin(100) , hex(100) , oct(100);

-- 문제60
-- 문자열 'MySQL programming'을 대문자로 출력하시오.
select upper('MySQL programming');

-- 문제61
-- 문자열 'MySQL programming'을 역순으로 출력하시오.
select reverse('MySQL programming');

-- 문제62 
-- 문자열 'MySQL programming'을 programming만 출력하시오.
select right('MySQL programming',11);