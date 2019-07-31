<?php
    
    $workorderno = $_GET['siteid'];
    $surveytype = $_GET['surveytype'];
    $enditemqty = $_GET['enditemqty'];
    $note = $_GET['note'];
    
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
        
        $callSQL = "CALL ibeammac_iScan.spt_survery_getrecommendataions($workorderno, '$surveytype', $enditemqty, '$note', @resultcode, @returncode, @returnmsg)";
        //print($callSQL);
        $pCallSQL = $dsc->prepare($callSQL);
        if ($pCallSQL->execute()) {
            $outstr = "{";
            while ($r = $pCallSQL->fetch(PDO::FETCH_ASSOC)) {
                $outstr .= "\"" . $r['inventoryid'] . "\":{";
                $outstr .= "\"manufacturer\":\"" . $r['manufacturer'] . "\",";
                $outstr .= "\"modelno\":\"" . $r['modelno'] . "\",";
                $outstr .= "\"notes\":\"" . $r['notes'] . "\",";
                $outstr .= "\"linkpdf\":\"" . $r['linkpdf'] . "\",";
                $outstr .= "\"sortorder\":\"" . $r['sortorder'] . "\",";
                $outstr .= "\"exceptions\":\"" . $r['exceptions'] . "\",";
                $outstr .= "\"ranking\":\"" . $r['ranking'] . "\"},";
            }
            $outstr .= "}";
            //get rid of the last trailing comma:
            $outstr = str_replace(",}", "}", $outstr);
            print($outstr);
        } else {
            print("something's wrong");
        }
        
        $dsc = null;
        
    } catch(PDOException $e) {
        echo $e->getMessage();
    }
    
    ?>
