<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb")
           or die("MySQL접속 실패");

    //insert.php파일에서 사용자가 입력한 내용을 변수에 저장
    $userID = $_POST["userID"];
    $userName = $_POST["userName"];
    $birthYear = $_POST["birthYear"];
    $addr = $_POST["addr"];
    $mobile1 = $_POST["mobile1"];
    $mobile2 = $_POST["mobile2"];
    $money = $_POST["money"];
    $amount = 0;
    $mDate = date("Y-m-j");

    //위의 변수의 값들을 DB에 저장하기 위한 sql문 작성하는 코드
    $sql = "INSERT INTO userTBL VALUES('".$userID."','".$userName."','".$birthYear."', '".$addr."','".$mobile1."',
            '".$mobile2."','".$money."','".$amount."','".$mDate."')";

    $ret = mysqli_query($con, $sql);
    echo "<h1>신규 회원 입력 결과 </h1>";

    if($ret){
        echo "데이터가 성공적으로 입력됨.";
    }
    else{
        echo "데이터 입력실패!!!.";
        echo "실패원인 : ".mysqli_error($con);
    }
    mysqli_close($con);

    echo "<br/> <a href='main.html'> <-- 초기 화면</a>";
?>