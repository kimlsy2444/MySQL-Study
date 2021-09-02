<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb") or die("MySQL접속 실패"); 

    $sql = "select '".$_GET['userID']."', userName, addr,addressTBL.addresstime AS addresstime
        from usertbl
        inner join addressTBL
        on addressTBL.address = usertbl.addr
        where userID = '".$_GET['userID']."' ";

  
    $ret = mysqli_query($con, $sql);

    $sql2 = "SELECT * FROM userTBL WHERE userID = 
    '".$_GET['userID']."'";
    
    $ret2 = mysqli_query($con, $sql2);
   

    if($ret2){
       
        $count = mysqli_num_rows($ret2);
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


    if($ret){
        $count = mysqli_num_rows($ret);
    }
    else{
        echo "userTBL 데이터 검색 실패!!!"."<br/>";
        echo "실패 원인 : ".mysqli_error($con)."<br/>";
        exit();
    }
    
    $row = mysqli_fetch_array($ret);
    $userName =  $row['userName'];
    
    echo "<h1> $userName 님 배달시간 </h1>";
    //테이블을 만들어서 위의 회원검색을 하였던 내용을 보기좋게 출력함
    echo "<TABLE border = 1>";
    echo "<TR>";
    echo "<TH>아이디</TH><TH>이름</TH><TH>지역</TH><TH>배송시간</TH>";
    echo "</TR>";

    echo "<TD>", $_GET['userID'], "</TD>";
    echo "<TD>", $userName, "</TD>";
    echo "<TD>", $row['addr'], "</TD>";        
    echo "<TD>", $row['addresstime'], "</TD>";
 
    mysqli_close($con);
    echo "</TABLE>";
    echo "<br/> <a href='main.html'> <-- 초기 화면</a>";

?>