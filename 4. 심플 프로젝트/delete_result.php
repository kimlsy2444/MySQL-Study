<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb")
           or die("MySQL접속 실패");

    //delete.php파일에서 사용자가 입력한 내용을 변수에 저장
    $userID = $_POST["userID"];
    $sql = "DELETE FROM userTBL WHERE userID = '".$userID."'";

    $ret = mysqli_query($con, $sql);
    echo "<h1>회원 삭제 결과</h1>";

    if($ret){
        echo $userID."회원이 성공적으로 삭제되었습니다.";
    }
    else{
        echo "데이터 삭제 실패!!!";
        echo "실패원인 : ".mysqli_error();
    }

    mysqli_close($con);

    echo "<br/><br/> <a href='main.html'> <--초기 화면</a> ";
?>