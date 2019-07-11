//
//  SurveyData.swift
//  jedeye
//
//  Created by Rick Campbell on 6/15/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import Foundation
import CoreLocation

class SurveyData : NSObject, CLLocationManagerDelegate{
    var surveyid : String = ""
    var entereddatetime : String = ""
    var startdatetime : String = ""
    var enddatetime : String = ""
    var status : String = ""
    var desc : String = ""
    
    var surveytype : String = ""
    var enditem : String = ""
    var enditemqty : String = ""
    
    var note : String = ""
    var trackingno : String = ""
    var customerpo : String = ""
    var authorizationno : String = ""
    
    var contractorid : String = ""
    var c_fname : String = ""
    var c_lname : String = ""
    var c_addr1 : String = ""
    var c_addr2 : String = ""
    var c_city : String = ""
    var c_state : String = ""
    var c_postalcode : String = ""
    
    var c_phone : String = ""
    var c_phone2 : String = ""
    var c_note : String = ""
    
    var siteid : String = ""
    var s_fname : String = ""
    var s_lname : String = ""
    var s_addr1 : String = ""
    var s_addr2 : String = ""
    var s_city : String = ""
    var s_state : String = ""
    var s_postalcode : String = ""
    
    var s_phone : String = ""
    var s_phone2 : String = ""
    var s_note : String = ""
    
    let locMan = CLLocationManager()
    var gps : String = ""
    
    var surveySelections : [String:Any] = [:]
    
    //gps[lat]=44.389816&gps[lon]=68.204529&gps[alt]=438
    
    func genQueryString () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd+HH:mm:ss"
        self.entereddatetime = formatter.string(from: Date())
        
        var retVal = "surveyid=\(self.surveyid)&entereddatetime=\(self.entereddatetime)&"
        retVal += "startdatetime=\(self.startdatetime)&enddatetime=\(self.enddatetime)&"
        retVal += "status=\(self.status)&description=\(self.desc)&type=\(self.surveytype)&"
        retVal += "enditem=\(self.enditem)&enditemqty=\(self.enditemqty)&note=\(self.note)&"
        retVal += "trackingno=\(self.trackingno)&customerpo=\(self.customerpo)&"
        retVal += "authorizationno=\(self.authorizationno)&contractorid=\(self.contractorid)&"
        retVal += "c_fname=\(self.c_fname)&c_lname=\(self.c_lname)&c_addr1=\(c_addr1)&"
        retVal += "c_addr2=\(self.c_addr2)&c_city=\(self.c_city)&c_state=\(self.c_state)&"
        retVal += "c_postalcode=\(self.c_postalcode)&c_phone=\(self.c_phone)&"
        retVal += "c_phone2=\(self.c_phone2)&c_note=\(self.c_note)&siteid=\(self.siteid)&"
        retVal += "s_fname=\(self.s_fname)&s_lname=\(self.s_lname)&s_addr1=\(s_addr1)&"
        retVal += "s_addr2=\(self.s_addr2)&s_city=\(self.s_city)&s_state=\(self.s_state)&"
        retVal += "s_postalcode=\(self.s_postalcode)&s_phone=\(self.s_phone)&"
        retVal += "s_phone2=\(self.s_phone2)&s_note=\(self.s_note)&"
        retVal += "gps=\(self.gps)&"
        retVal += "empno=\(Session.usertkey!)"
        
        
        retVal = retVal.replacingOccurrences(of: " ", with: "+")
        
        //print(retVal)
        
        return retVal
    }
    
    func nullifyAll() {
        // database accepts NULL input on a field to mean "do not update,"
        // "" input means "enter the blank string." Use this method to
        // set all values to NULL before setting individual value to
        // ensure overwriting doesn't happen.
        self.surveyid = "NULL"
        self.entereddatetime = "NULL"
        self.startdatetime = "NULL"
        self.enddatetime = "NULL"
        self.status = "NULL"
        self.desc = "NULL"
        
        self.surveytype = "NULL"
        self.enditem = "NULL"
        self.enditemqty = "NULL"
        
        self.note = "NULL"
        self.trackingno = "NULL"
        self.customerpo = "NULL"
        self.authorizationno = "NULL"
        
        self.contractorid = "NULL"
        self.c_fname = "NULL"
        self.c_lname = "NULL"
        self.c_addr1 = "NULL"
        self.c_addr2 = "NULL"
        self.c_city = "NULL"
        self.c_state = "NULL"
        self.c_postalcode = "NULL"
        
        self.c_phone = "NULL"
        self.c_phone2 = "NULL"
        self.c_note = "NULL"
        
        self.siteid = "NULL"
        self.s_fname = "NULL"
        self.s_lname = "NULL"
        self.s_addr1 = "NULL"
        self.s_addr2 = "NULL"
        self.s_city = "NULL"
        self.s_state = "NULL"
        self.s_postalcode = "NULL"
        
        self.s_phone = "NULL"
        self.s_phone2 = "NULL"
        self.s_note = "NULL"
        
        self.gps = "NULL"
        
    }
    
    func getgps() {
        locMan.delegate = self
        locMan.desiredAccuracy = kCLLocationAccuracyBest
        locMan.requestAlwaysAuthorization()
        locMan.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latlon : CLLocationCoordinate2D = manager.location!.coordinate
        let alt :CLLocationDistance = manager.location!.altitude
        self.gps = "\(String(latlon.latitude)), \(String(latlon.longitude)), \(String(alt))"
        print("&&GPS:\(self.gps)")
        manager.stopUpdatingLocation()
    }
}
