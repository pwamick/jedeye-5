<?php
    //fetchkvpairs.php
    //produces [String:String]
    
    $host = "localhost";
    $dbname = "ibeammac_iScan";
    $charset = "utf8mb4";
    
    $options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
    ];
    
    $workorderno = $_GET['surveyid'];
    
    $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
    
    try {
        $dsc = new PDO($dsn, "ibeammac_webuser", "ShinerBock4me2", $options);
        
        $callSql = "CALL ibeammac_iScan.spt_survery_getvalues($workorderno, @returncode, @returnmessage)";
        $pCallSql = $dsc->prepare($callSql);
        if ($pCallSql->execute()) {
            $outstr = "{";
            while ($r = $pCallSql->fetch(PDO::FETCH_ASSOC)) {
                $outstr .= "\"" . $r['keyname'] . "\":\"" . $r['keyvalue'] . "\",";
            }
            $outstr .= "}";
            //get rid of the last trailing comma:
            $outstr = str_replace(",}", "}", $outstr);
            print($outstr);
        }
        
        $dsc = null;
    } catch(PDOExcemption $e) {
        echo $e->getMessage();
    }
    
?>
