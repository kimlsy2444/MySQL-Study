<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    <h1>신규 회원 정보 입력</h1>
    <form method="post" action="insert_result.php">
    아이디 : <input type="text" name="userID"><br/>
    이름 : <input type="text" name="userName"><br/>
    출생년도 : <input type="text" name="birthYear"><br/>
    지역 : <input type="text" name="addr"><br/>
    국번 : <input type="text" name="mobile1"><br/>
    휴대폰 뒷자리 : <input type="text" name="mobile2"><br/>
    돈 : <input type="text" name="money"><br/><br/>
    
    <input type="submit" value="회원 가입">       
    </form>   
</body>
</html>