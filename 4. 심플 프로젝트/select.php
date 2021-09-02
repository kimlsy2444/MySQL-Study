<?php
    $con = mysqli_connect("localhost","scott","1234","sqldb");

    $sql = "SELECT * FROM userTBL";

    $ret = mysqli_query($con, $sql);

    if($ret){
        $count = mysqli_num_rows($ret);
    }
    else{
        echo "userTBL 데이터 검색 실패!!!"."<br/>";
        echo "실패 원인 : ".mysqli_error($con)."<br/>";
        exit();
    }

    echo "<h1>회원 조회 결과</h1>";
    //테이블을 만들어서 위의 회원검색을 하였던 내용을 보기좋게 출력함
    echo "<TABLE border = 1>";
    echo "<TR>";
    echo "<TH>아이디</TH><TH>이름</TH><TH>출생년도</TH>
    <TH>지역</TH><TH>국번</TH><TH>전화번호</TH><TH>돈</TH><TH>산 금액</TH>
    <TH>가입일</TH><TH>수정</TH><TH>삭제</TH>";
    echo "</TR>";

    //DB에서 읽은 데이터 내용을 출력을 하는 코드
    while($row = mysqli_fetch_array($ret)){
        echo "<TR>";
        echo "<TD>", $row['userID'], "</TD>";
        echo "<TD>", $row['userName'], "</TD>";
        echo "<TD>", $row['birthYear'], "</TD>";
        echo "<TD>", $row['addr'], "</TD>";
        echo "<TD>", $row['mobile1'], "</TD>";
        echo "<TD>", $row['mobile2'], "</TD>";
        echo "<TD>", $row['money'], "</TD>";
        echo "<TD>", $row['amount'], "</TD>";
        echo "<TD>", $row['mDate'], "</TD>";
        //수정파일로 이동
        echo "<TD>", "<a href='update.php?userID=",$row['userID'],"'>수정</a></TD>";
        //삭제파일로 이동
        echo "<TD>", "<a href='delete.php?userID=",$row['userID'],"'>삭제</a></TD>";        
        echo "</TR>";               
    }
    mysqli_close($con);
    echo "</TABLE>";
    echo "<br/> <a href='main.html'> <-- 초기 화면</a>";
?>