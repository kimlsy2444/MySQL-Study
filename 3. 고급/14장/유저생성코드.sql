-- user생성코드
CREATE USER 'scott'@'%' IDENTIFIED WITH mysql_native_password BY '1234';
GRANT ALL PRIVILEGES ON * . * TO 'scott'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

use mysql;
select *
  from user;
  
-- user삭제코드
delete from user
where user = 'LeeJunseong';
flush PRIVILEGES;
