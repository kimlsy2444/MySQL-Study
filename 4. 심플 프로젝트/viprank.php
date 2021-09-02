<?php
$con = mysqli_connect("localhost","scott","1234","sqldb") or die("MySQL접속 실패"); 

  $sql = "SELECT * FROM userTBL WHERE userName = 
    '".$_GET['userName']."'";
    
    $ret = mysqli_query($con, $sql);

    if($ret){
        //1개의 ROW가 넘어와야 정상이다.
        $count = mysqli_num_rows($ret);
        if($count == 0){
            echo " 없는 회원입니다!!"."<br/>";
            echo "<br/> <a href='main.html'> <-- 초기화면</a>";
             exit();
        }
    }
    else{
        echo "데이터 검색 실패!!!"."<br/>";
        echo "실패원인 : ".mysqli_error()."<br/>";
        exit();
    }


$ret2 = mysqli_query($con, "CALL vipproc('".$_GET['userName']."')");

$row = mysqli_fetch_array($ret2);
 echo $row[0];

 mysqli_close($con);
 echo "<br/> <a href='main.html'> <-- 초기 화면</a>";

?>
