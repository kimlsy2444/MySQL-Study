<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb") or die("MySQL접속 실패");
    
    $car = 100;
    $userID = $_POST["userID"];
    $money = $_POST["money"];
    $quantity = $_POST["car_quantity"];

    $sql = "update usertbl set money  = money -  '".$car." 'where userID = '".$userID."'";

    $sql_car = "update buytbl set quantity  = (quantity-1) where prodName =  '자동차'";

    $ret = mysqli_query($con, $sql);
    $ret_car = mysqli_query($con, $sql_car);

    
    echo "<h1>물건 산 결과 </h1>";


    if($quantity == 0){
        echo "자동차 매진 되었습니다.!!!";
        
        if($money < 100){
            echo "<br/> <a href='main.html'> <-- 초기 화면</a>";
            exit();
        }
        else{
        $sql = "update usertbl set money  = money +  '".$car."' where userID = '".$userID."'";    
    
        $ret = mysqli_query($con, $sql);
        echo "<br/> <a href='main.html'> <-- 초기 화면</a>";
        exit();
        }
    }


    if($ret){
        echo "성공적으로 자동차삼";
        
        $sql2 = "update usertbl set amount = amount +'".$car."' where userID = '".$userID."'"; 
        $ret2 = mysqli_query($con, $sql2);    
    }

    else{
        
    echo "돈이 부족합니다!!!";
    
    $sql_car = "update buytbl set quantity  = (quantity+1)where prodName =  '자동차'";
    $ret_car = mysqli_query($con, $sql_car);

   }
   mysqli_close($con);
   echo "<br/> <a href='main.html'> <-- 초기 화면</a>";
?>
