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
        }
    }
    else{
        echo "데이터 검색 실패!!!"."<br/>";
        echo "실패원인 : ".mysqli_error()."<br/>";
        exit();
    }
    //삭제는 1건이니까 루프를 만들 필요가 없다.
    $row = mysqli_fetch_array($ret);
    $userID = $row["userID"];
    $userName = $row["userName"];    
?>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    <h1>회원 삭제</h1>
    <form method="post" action="delete_result.php">
        아이디 : <input type="text" name="userID" value=<?php echo $userID ?> READONLY> <br/>
        이름 : <input type="text" name="userName" value=<?php echo $userName ?> READONLY> <br/><br/>
        
        위 회원을 삭제하시겠습니까?
        <input type="submit" value="회원 삭제">
    </form>    
</body>
</html>



