<?php
    /* savesurvey.php - 06 07 2019
     * v. 0.01
     * starts a survey record, adjusts main properties,
     * but does not save screen by screen.
     * Operates against spt_survery_save(...) || see doc book,
     * SP may change in details, but not in main.
     * R. Campbell for Datacom
     */
    //print('test 001');
    /*
     Test query
     https://ibeamsg.com/spike/savesurvey.php?surveyid=5001&entereddatetime=2019-06-07+09:08:33&startdatetime=2019-06-07+09:08:33&enddatetime=2019-07-07+09:08:33&status=ok&description=make+sure+to+handle+apostrophes&surveytype=adhoc&enditem=widget&enditemqty=17&note=otherwise+it+will+blow+up&trackingno=NC1701&customerpo=LP+1002&authorizationno=BR+549&contractorid=Joe's+Happy+Time+Plumbing&c_fname=Skippy&c_lname=McDougall&c_addr1=123+4th+Street&c_addr2=Ste.+329&c_city=Clamville&c_state=ME&c_postalcode=03904&siteid=Muddy+hole+in+ground&s_fname=Skippy&s_lname=McDougall&s_addr1=123+4th+Street&s_addr2=Ste.+329&s_city=Clamville&s_state=ME&s_postalcode=03904&s_phone=123-456-7890&s_phone2=098-765-4321&s_note=Hope+Joe+brings+his+big+snake&gps[lat]=44.389816&gps[lon]=68.204529&gps[alt]=438
     
     
     INSERT INTO customers(customerid,firstname,lastname,address1,address2,city,state,postalcode,phone1,phone2,notes,route)Values ('Muddy hole in ground','Skippy','McDougall','123 4th Street','Ste. 329','Clamville','ME','03904','123-456-7890','098-765-4321','Hope Joe brings his big snake','44.389816, 68.204529, 438')
     */
    
    // Lots of GET parameters. Replace ALL plusses in input with spaces, all
    // apostrophes with \'. (does this break the gps array????)
    
    $input = null;
    foreach ($_GET as $k => $v) {
        $input[$k] = str_replace("+", " ", $v);
        $input[$k] = str_replace("'", "(apos)", $v);
        if($input[$k] != "NULL" && $k != "surveyid") {
            $input[$k] = "'" . $input[$k] . "'";
        }
    }
    
    $workorderno        = $input['surveyid'];
    $entereddatetime    = $input['entereddatetime'];
    $startdatetime      = $input['startdatetime'];
    $enddatetime        = $input['enddatetime'];
    $status             = $input['status'];
    $description        = $input['description'];
    
    $surveytype         = $input['surveytype'];
    $enditem            = $input['enditem'];
    $enditemqty         = $input['enditemqty'];
    
    $note               = $input['note'];
    $trackingno         = $input['trackingno'];
    $customerpo         = $input['customerpo'];
    $authorizationno    = $input['authorizationno'];
    
    $contractorid       = $input['contractorid'];
    $c_fname            = $input['c_fname'];
    $c_lname            = $input['c_lname'];
    $c_addr1            = $input['c_addr1'];
    $c_addr2            = $input['c_addr2'];
    $c_city             = $input['c_city'];
    $c_state            = $input['c_state'];
    $c_postalcode       = $input['c_postalcode'];
    
    $c_phone            = $input['c_phone'];
    $c_phone2           = $input['c_phone2'];
    $c_note             = $input['c_note'];
    
    $siteid             = $input['siteid'];
    $s_fname            = $input['s_fname'];
    $s_lname            = $input['s_lname'];
    $s_addr1            = $input['s_addr1'];
    $s_addr2            = $input['s_addr2'];
    $s_city             = $input['s_city'];
    $s_state            = $input['s_state'];
    $s_postalcode       = $input['s_postalcode'];
    
    $s_phone            = $input['s_phone'];
    $s_phone2           = $input['s_phone2'];
    $s_note             = $input['s_note'];
    
    $gps                = $input['gps'];         //assoc with keys lat, long, alt.
    $empno              = $input['empno'];       //user tkey
    
    $strGps = $gps['lat'] . ", " . $gps['lon'] . ", " . $gps['alt'];
    
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
        
        $callSql = "CALL ibeammac_iScan.spt_survery_save($workorderno, $entereddatetime, $startdatetime, $enddatetime, $status, $description, $surveytype, $enditem, $enditemqty, $note, $trackingno, $customerpo, $authorizationno, $contractorid, $c_fname, $c_lname, $c_addr1, $c_addr2, $c_city, $c_state, $c_postalcode, $c_phone, $c_phone2, $c_note, $siteid, $s_fname, $s_lname, $s_addr1, $s_addr2, $s_city, $s_state, $s_postalcode, $s_phone, $s_phone2, $s_note, $strGps, $empno, @resultcode, @returncode, @returnmessage)";
        
        /*comment the following line out for production*/
        //print($callSql . "<br /><br />");
        
        $pCallSql = $dsc -> prepare($callSql);
        $pCallSql -> execute();
        
        while ($rset = $pCallSql -> fetch(PDO::FETCH_ASSOC)) {
            print("{\"resultcode\":\"" . $rset['resultcode'] . "\", ");
            print("\"returncode\":\"" . $rset['returncode'] . "\", ");
            print("\"returnmessage\":\"" . $rset['returnmessage'] . "\"}");
        }
        
        $pCallSql -> closeCursor();
        
        $dsc = null;
        
        
    } catch(PDOException $e) {
        echo $e->getMessage();
    }
    ?>
