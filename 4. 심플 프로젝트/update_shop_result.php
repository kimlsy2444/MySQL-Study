<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb")
           or die("MySQL접속 실패");


    $prodName= $_POST["prodName"];

    $quantity = $_POST["quantity"];


   $sql ="UPDATE buyTbl SET quantity ='".$quantity."'
            WHERE prodName='".$prodName."'";
  

   $ret = mysqli_query($con, $sql);

   echo "<h1>물건 정보 수정 결과 </h1>";

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