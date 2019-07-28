<?php
    //deletesurvey.php
    
    $referenceid = $_GET['surveyid'];
    $referencetype = $_GET['reftype'];
    $note = $_GET['note'];
    $empkey = $_GET['empid'];
    $deviceid = $_GET['deviceid'];
    
    $host = "localhost";
    $dbname = "ibeammac_iScan";
    $charset = "utf8mb4";
    
    $options = [
    PDO::ATTR_ERRMODE                   => PDO::ERRMODE_EXCEPTION,
    PDO::MYSQL_ATTR_USE_BUFFERED_QUERY  => true
    ];
    
    
    $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
    
    try {
        $dsc = new PDO($dsn, "ibeammac_webuser", "ShinerBock4me2", $options);
        
        $callSql = "CALL ibeammac_iScan.spt_survery_delete('$referenceid', '$referencetype', '$note', $empkey, '$deviceid', @returncode, @returnmessage)";
        $pCallSql = $dsc->prepare($callSql);
        
        //print($callSql);
        
        $pCallSql->execute();
        
        $sql = "SELECT @returncode AS retcode, @returnmessage AS retmsg";
        $pSql = $dsc->prepare($sql);
        
        $pSql->execute();
        while ($rset = $pSql -> fetch(PDO::FETCH_ASSOC)) {
            print("{\"retcode\":\"" . $rset['retcode'] . "\", ");
            print("\"retmsg\":\"" . $rset['retmsg'] . "\"}");
        }
        
        $dsc = null;
        
    } catch(PDOExcemption $e) {
        echo $e->getMessage();
    }
    
    ?>
