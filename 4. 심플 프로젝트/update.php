<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb") or die("MySQL접속 실패");

    $sql = "SELECT * FROM userTBL WHERE userID = 
    '".$_GET['userID']."'";
    
    $ret = mysqli_query($con, $sql);
   

    if($ret){
        //1개의 ROW가 넘어와야 정상이다.
        $count = mysqli_num_rows($ret);
        if($count == 0){
            echo $_GET['userID']." 아이디의 회원이 없음!!"."<br/>";
            echo "<br/> <a href='main.html'> <-- 초기화면</a>";
            exit();
        }
    }
    else{
        echo "데이터 검색 실패!!!"."<br/>";
        echo "실패원인 : ".mysqli_error()."<br/>";
        exit();
    }
    //수정은 1건이니까 루프를 만들 필요가 없다.
    $row = mysqli_fetch_array($ret);
    $userID = $row["userID"];
    $userName = $row["userName"];
    $birthYear = $row["birthYear"];
    $addr = $row["addr"];
    $mobile1 = $row["mobile1"];
    $mobile2 = $row["mobile2"];
    $money = $row["money"];
    $mDate = $row["mDate"];
?>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    <h1>회원 정보 수정 </h1>
    <form method="post" action="update_result.php">
        <!--아이디는 수정이 되면 안된다.-->
        아이디 : <input type="text" name="userID" value=<?php echo $userID ?> READONLY> <br/>
        이름 : <input type="text" name="userName" value=<?php echo $userName ?>> <br/>
        출생년도 : <input type="text" name="birthYear" value=<?php echo $birthYear ?>> <br/>
        지역 : <input type="text" name="addr" value=<?php echo $addr ?>> <br/>
        휴대폰 국번 : <input type="text" name="mobile1" value=<?php echo $mobile1 ?>> <br/>
        휴대폰 뒷자리 : <input type="text" name="mobile2" value=<?php echo $mobile2 ?>> <br/>
        돈: <input type="text" name="money" value=<?php echo $money ?>> <br/>
        회원 가입일 : <input type="text" name="mDate" value=<?php echo $mDate ?> READONLY> <br/><br/>
        
        <input type="submit" value="정보 수정">
    </form>
</body>
</html>