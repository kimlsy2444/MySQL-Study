<?php 
     $con = mysqli_connect("localhost","scott","1234","sqldb") or die("MySQL접속 실패"); 

    $sql = "SELECT * FROM userTBL WHERE userID = '".$_GET['userID']."' and userName =  '".$_GET['userName']."'";
    
    $sqlcar ="SELECT quantity AS car FROM buyTBL where prodName = '자동차'";

    $sqlcom ="SELECT quantity AS com FROM buyTBL where prodName = '컴퓨터'";

    $ret = mysqli_query($con, $sql);
    $retcar =  mysqli_query($con, $sqlcar);

    $retcom =  mysqli_query($con, $sqlcom);
    

    if($ret){
       
        $count = mysqli_num_rows($ret);
        if($count == 0){
            echo " 아이디와 이름을 확인하세요!!"."<br/>";
            echo "<br/> <a href='main.html'> <-- 초기화면</a>";
             exit();
        }
    }
    else{
        echo "데이터 검색 실패!!!"."<br/>";
        echo "실패원인 : ".mysqli_error()."<br/>";
        exit();
    }

    $row = mysqli_fetch_array($ret);
    $userID = $row["userID"];
    $userName = $row["userName"];
    $money =$row["money"];

    $rowcar = mysqli_fetch_array($retcar);
    $car_quantity= $rowcar["car"];
    
    $rowcom = mysqli_fetch_array($retcom);
    $com_quantity= $rowcom["com"];
        
?>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    <h1> 쇼핑몰접속 확인 <?php echo $userName ?>님 환영합니다</h1>
    <form method ="post">
    <input type="hidden" name="userID" value = <?php echo $userID ?>>
    <input type="hidden" name="money" value = <?php echo $money ?>>
    
    <input type="hidden" name="car_quantity" value = <?php echo $car_quantity ?>>
    <input type="hidden" name="com_quantity" value = <?php echo $com_quantity ?>>
    
    <?php
        $sql_buy = "SELECT *FROM buytbl";
        $ret2 = mysqli_query($con, $sql_buy);

        if($ret2){
             $count = mysqli_num_rows($ret2);
        }
            else{
                echo "buyTBL 데이터 검색 실패!!!"."<br/>";
                echo "실패 원인 : ".mysqli_error($con)."<br/>";
                exit();
                }
    
        echo "<TABLE border = 1>";
        echo "<TR>";
        echo "<TH>물건이름</TH><TH>가격</TH><TH>수량</TH><TH>재고추가</TH>";
        echo "</TR>";

        while($row2 = mysqli_fetch_array($ret2))
        {
            echo "<TR>";
            echo "<TD>", $row2['prodName'], "</TD>";
            echo "<TD>", $row2['price'], "</TD>";
            echo "<TD>", $row2['quantity'], "</TD>";
            echo "<TD>", "<a href='update_shop.php?prodName=",$row2['prodName'],"'>수정</a></TD>";
            echo "</TR>"; 
     
        }

    
    mysqli_close($con);
        echo "</TABLE>";
        
    ?>
        <input type="submit"value=" 자동차 사기" formaction="shop_result.php"> 
        <input type="submit"value=" 컴퓨터 사기" formaction="shop_result2.php" >
    </form>   
    
    <br/><a href='main.html'> <-- 초기 화면</a>
</body>
</html>
