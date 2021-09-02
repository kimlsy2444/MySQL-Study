<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb") or die("MySQL접속 실패");
    

    $sql ="SELECT * FROM buyTBL where prodName =  '".$_GET['prodName']."'";
    
    $ret = mysqli_query($con, $sql);

    if($ret){
        $count = mysqli_num_rows($ret);
    }
    else{
        echo "buyTBL 데이터 검색 실패!!!"."<br/>";
        echo "실패 원인 : ".mysqli_error($con)."<br/>";
        exit();
    }
    //수정은 1건이니까 루프를 만들 필요가 없다.
    $row = mysqli_fetch_array($ret);
    $quantity = $row["quantity"];
    $prodName = $row["prodName"];
?>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    <h1>물건 수량 수정 </h1>
    <form method="post" action="update_shop_result.php">
        <input type="hidden" name="prodName" value = <?php echo $prodName ?>>
        수량: <input type="text" name="quantity" value=<?php echo $quantity ?>> <br/>
        <input type="submit" value="수량 수정">
    </form>
    
</body>
</html>