<?php
    
    // fetchsurveys.php
    
    $host = "localhost";
    $dbname = "ibeammac_iScan";
    $charset = "utf8mb4";
    
    $options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
    ];
    
    $empno      = $_GET['emptkey'];
    $status     = $_GET['status'];      //pass in 'o' to get open orders
    $history    = $_GET['history'];   //for future
    $mindate    = $_GET['mindate'];   //for future
    
    //if the $sessionid isn't present, pass NULL in that parameter (use flag)
    $withSession = false;
    if (isset($_GET['sessionid'])) {
        $sessionid  = $_GET['sessionid'];
        $withSession = true;
    }
    
    
    /*
     foreach ($_GET as $k => $v) {
     print("$k = $v<br />");
     }
     */
    
    //change status to " " for open orders
    $status = str_replace("o", " ", $status);  //replace any "o"s with spaces
    //0 in sessionid means get them all
    if($sessionid == 0) { $sessionid = null; }
    
    $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
    
    try {
        //Build the CALL SQL:
        $dsc = new PDO($dsn, "ibeammac_webuser", "ShinerBock4me2", $options);
        
        $callSql = "CALL reqnljmy_iScan.spt_session_list_get($empno, '$status', '$history', '$mindate', NULL, @returncode, @returnmessage)";
        
        //print("$callSql<br >");
        $pCallSql = $dsc -> prepare($callSql);
        if ($pCallSql -> execute()) {
            $outstr = "{";
            while ($r = $pCallSql->fetch(PDO::FETCH_ASSOC)) {
                $outstr .= "\"" . $r['sessionid'] . "\":{";
                $outstr .= "\"workorderno\":\"" . $r['workorderno'] . "\", ";
                $outstr .= "\"startdate\":\"" . $r['startdate'] . "\", ";
                $outstr .= "\"enddate\":\"" . $r['enddate'] . "\", ";
                $outstr .= "\"status\":\"" . $r['status'] . "\", ";
                $outstr .= "\"description\":\"" . $r['description'] . "\", ";
                $outstr .= "\"surveytype\":\"" . $r['surveytype'] . "\", ";
                $outstr .= "\"enditem\":\"" . $r['enditem'] . "\", ";
                $outstr .= "\"enditemqty\":\"" . $r['enditemqty'] . "\", ";
                $outstr .= "\"survey_note\":\"" . $r['survey_note'] . "\", ";
                $outstr .= "\"trackingno\":\"" . $r['trackingno'] . "\", ";
                $outstr .= "\"customerpo\":\"" . $r['customerpo'] . "\", ";
                $outstr .= "\"authorizationno\":\"" . $r['authorizationno'] . "\", ";
                $outstr .= "\"contractorid\":\"" . $r['contractorid'] . "\", ";
                $outstr .= "\"c_fname\":\"" . $r['con_fname'] . "\", ";
                $outstr .= "\"c_lname\":\"" . $r['con_lname'] . "\", ";
                $outstr .= "\"c_addr1\":\"" . $r['con_addr1'] . "\", ";
                $outstr .= "\"c_addr2\":\"" . $r['con_addr2'] . "\", ";
                $outstr .= "\"c_city\":\"" . $r['con_city'] . "\", ";
                $outstr .= "\"c_state\":\"" . $r['con_state'] . "\", ";
                $outstr .= "\"c_postalcode\":\"" . $r['con_postalcode'] . "\", ";
                $outstr .= "\"c_phone\":\"" . $r['con_phone'] . "\", ";
                $outstr .= "\"c_phone2\":\"" . $r['con_phone2'] . "\", ";
                $outstr .= "\"c_note\":\"" . $r['con_note'] . "\", ";
                $outstr .= "\"siteid\":\"" . $r['siteid'] . "\", ";
                $outstr .= "\"s_fname\":\"" . $r['site_fname'] . "\", ";
                $outstr .= "\"s_lname\":\"" . $r['site_lname'] . "\", ";
                $outstr .= "\"s_addr1\":\"" . $r['site_addr1'] . "\", ";
                $outstr .= "\"s_addr2\":\"" . $r['site_addr2'] . "\", ";
                $outstr .= "\"s_city\":\"" . $r['site_city'] . "\", ";
                $outstr .= "\"s_state\":\"" . $r['site_state'] . "\", ";
                $outstr .= "\"s_postalcode\":\"" . $r['site_postalcode'] . "\", ";
                $outstr .= "\"s_phone\":\"" . $r['site_phone'] . "\", ";
                $outstr .= "\"s_phone2\":\"" . $r['site_phone2'] . "\", ";
                $outstr .= "\"s_note\":\"" . $r['site_note'] . "\", ";
                $outstr .= "\"gps\":\"" . $r['site_gps'] . "\", ";
                $outstr .= "\"usertkey\":\"" . $r['servicewriter'] . "\"}, ";
            }
            $outstr .= "}";
            
            $outstr = str_replace(",}", "}", $outstr);
            print($outstr);
        }
        
        $dsc = null;
        
    } catch(PDOException $e) {
        echo $e->getMessage();
    }
?>
