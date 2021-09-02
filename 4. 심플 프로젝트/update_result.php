<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb")
           or die("MySQL접속 실패");

    //update.php파일에서 사용자가 입력한 내용을 변수에 저장
    $userID = $_POST["userID"];
    $userName = $_POST["userName"];
    $birthYear = $_POST["birthYear"];
    $addr = $_POST["addr"];
    $mobile1 = $_POST["mobile1"];
    $mobile2 = $_POST["mobile2"];
    $money = $_POST["money"];
    $mDate = $_POST["mDate"];


   $sql ="UPDATE userTbl SET userName='".$userName."',birthYear=".$birthYear;
   $sql = $sql.", addr='".$addr."', mobile1='".$mobile1."',mobile2='".$mobile2;
   $sql = $sql."', money=".$money.", mDate='".$mDate."' WHERE userID='".$userID."'";

   $ret = mysqli_query($con, $sql);

   echo "<h1>회원 정보 수정 결과 </h1>";

   if($ret){
       echo "데이터가 성공적으로 수정됨.";
   }
   else{
       echo "데이터 수정실패!!!.";
       echo "실패원인 : ".mysqli_error($con);
   }
   mysqli_close($con);

   echo "<br/> <a href='main.html'> <-- 초기 화면</a>";
?>