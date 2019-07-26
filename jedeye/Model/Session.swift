//
//  Session.swift
//  jedeye
//
//  Created by Rick Campbell on 5/23/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

typealias EntryType = [String:[String:String]]

class Session : NSObject {
    
    //bootstrapping the app settings:
    static var appSettings : [String:String]?
    static var APPID = 88
    
    //Required flow state variables
    static var user : String?
    static var usertkey : String?
    static var surveyID : String?
    static var numSurveysForUser : Int?
    static var pwd : String?
    
    static var surveyData : SurveyData?
    
    //Support United Rental Process (test code):
    static var projectName : String? = "XYZ Manufacturing Re-Roof"
    static var contractor : String? = "Roger's Reroofing & Hair Salon"
    static var jobSite : String? = ""
    //From call to procedure:
    static var deviceID : String?
    //Survey questions and answers
    static var questions : EntryType?
    //static var selection : [String:Any] = [:]
    
    static var delegate : AsynchDataDelegate?
    
    static func getSelection() -> [String:Any] {
        return self.surveyData!.surveySelections
    }
    
    static func newSurvey() -> SurveyData {
        // returns a new SurveyData with "NULL" fields:
        let sdat = SurveyData()
        sdat.nullifyAll()
        return sdat
    }
    
    static func obtainAppSettings() {
        
        self.surveyData = self.newSurvey()
        var settings : [String:String]?
        //this url is the same for all clients / vendors.
        let seedURL = "https://www.ibeamma.com/jedeye/getappsettings.php?appid=\(self.APPID)"
        let url = URL(string: seedURL)!
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Session: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Session: \(String(data:data!, encoding: .utf8)!)")
                //print("&&Survey: in do in completion handler")
                let jsonDecoder = JSONDecoder()
                //print("&&Survey: jsonDecoder assigned")
                settings = try jsonDecoder.decode([String:String].self, from: data!)
                delegate?.appSettingsObtained(settings: settings!)
                
                
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }
    
    static func setDeviceID(){
        let vendorDeviceID = UIDevice.current.identifierForVendor?.uuidString
        //let vendorDeviceID = "lkjfi3kklkjdf047lkjf" // for simulator faking
        self.deviceID = vendorDeviceID
    }
    
    static func userInDB(user: String, reftype: String, password: String) {
        //all passwords in db are currently '*', so jack that in:
        let strurl = self.appSettings!["URL"]! + "login.php?user=\(user)&reftype=\(reftype)&password=*"
        //print(strurl)
        let url = URL(string: strurl)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Session: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Session: in do in completion handler")
                let jsonDecoder = JSONDecoder()
                //print("&&Session: jsonDecoder assigned, data:\(data!)")
                let result = try jsonDecoder.decode([String:String].self, from: data!)
                self.delegate?.loginReturnedWith(data: result)
                //print("&&Session: \(result)")
                
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }
    
    static func getSurvey() { 
        //print("&&Survey: getting questions")
        let strURL = self.appSettings!["URL"]! + "survey.php?userid=" + self.user! + "&deviceid=" + self.deviceID!
        //print("&&\(strURL)")
        let url = URL(string: strURL)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Survey: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Survey: in do in completion handler")
                let jsonDecoder = JSONDecoder()
                //print("&&Survey: jsonDecoder assigned")
                self.questions = try jsonDecoder.decode([String:[String:String]].self, from: data!)
                self.delegate?.sessionReturnedWith(data: self.questions!)
                //print("&&Session: \(self.questions!)")
                
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }
    
    static func saveSurvey(surveyType:String) {
        Session.surveyData!.surveytype = surveyType
        var saveURL = self.appSettings!["URL"]! + "savesurvey.php?"
        saveURL += self.surveyData!.genQueryString()
        print(saveURL)
        
        let url = URL(string: saveURL)!
        
        print("&&\(saveURL)")
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Survey: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Survey: in do in completion handler")
                let jsonDecoder = JSONDecoder()
                //print("&&Survey: jsonDecoder assigned")
                let result = try jsonDecoder.decode([String:String].self, from: data!)
                self.delegate?.surveySaved(data: result)
                //print("&&Session: \(self.questions!)")
                
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }
    
    static func getQuestionsHaving(ordPos: String = "?", sourceType: String) -> EntryType {
        var retVal : EntryType = [:]
        //print("&&ordPos = \(ordPos) and sourceType = \(sourceType)")
        for (key, value) in self.questions! {
            if ordPos == "?" {
                if value["sourcetype"] == sourceType && Int(key)! > -1 {
                    retVal[key] = value
                }
            } else if value["ordpos"] == ordPos && value["sourcetype"] == sourceType && Int(key)! > -1 {
                retVal[key] = value
            }
        }
        //print("&&Session: \(retVal)")
        return retVal
    }
    
    static func addToEquipmentSelectionDict(id: String, value: Any) {
        self.surveyData?.surveySelections[id] = value
        
        print("&&\(self.surveyData?.surveySelections ?? ["default":"default"])")
    }
    
    static func buildEquipmentQuery() -> String {
        // build up a query string based on the selection dictionary:
        var equipmentQuery = "SELECT * FROM Equipment WHERE "
        var count = Array(self.getSelection().keys).count
        for (key, value) in self.getSelection() {
            equipmentQuery += "\(key)=\(value) "
            if (count > 0) {
                equipmentQuery += "AND "
            }
            count -= 1
        }
        return equipmentQuery
    }
    
    static func queryDBForEquipment() {
        
    }
    
    static func getFieldDataFrom(_ collection:EntryType,
                                 ordinalPosition:String,
                                 colName:String) -> String {
        var dict : EntryType = [:]
        for (key, value) in collection {
            if value["ordpos"] == ordinalPosition {
                dict[key] = value
            }
        }
        
        let pairs = dict[Array(dict.keys)[0]]!
        return pairs[colName]!
        
    }
    
    static func getSortedStrings(dict: EntryType, field: String) -> [String] {
        var retVal : [String] = []
        for (_, v) in dict {
            retVal.append(v[field]!)
        }
        return retVal.sorted()
    }
    
    static func obtainSurveyID() {
        let strURL = self.appSettings!["URL"]! + "surveyid.php?userid=" + self.user! + "&deviceid=" + self.deviceID!
        //print("&&\(strURL)")
        let url = URL(string: strURL)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&obtainSurveyID: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Survey: in do in completion handler")
                let jsonDecoder = JSONDecoder()
                //print("&&Survey: jsonDecoder assigned")
                let surveyIDDict = try jsonDecoder.decode([String:String].self, from: data!)
                self.surveyID = surveyIDDict["surveyid"]!
                //print("&&SurveyID:\(self.surveyData!.surveyid)")
                self.delegate?.surveyIDReturnedWith(data: surveyIDDict)
                
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }
    
    static func surveyTypeDropDownContent(custType:String) {
        let strURL = self.appSettings!["URL"]! + "surveytype.php?ctype=" + custType
        let url = URL(string: strURL)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Survey: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Survey: in do in completion handler")
                let jsonDecoder = JSONDecoder()
                //print("&&Survey: jsonDecoder assigned")
                let list = try jsonDecoder.decode([String:String].self, from: data!)
                //print("&&Session list: \(list)")
                self.delegate?.surveyTypeReturnedWith(data: list)
                
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }
    
    static func setKVPair(key:String, value:String) {
        let prepValue = value.replacingOccurrences(of: " ", with: "+")
        let strURL =  self.appSettings!["URL"]! + "setsinglepair.php?surveyID=\(self.surveyID!)&key=\(key)&value=\(prepValue)"
        //print("&&\(strURL)")››
        
        //connect and send data
        
        let url = URL(string: strURL)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&setKVPairs: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            let success = String(data: data!, encoding: .utf8)
            self.delegate?.singlePairSetWithResponse(data: success!)
        }).resume()
    }
    
    static func setKVPairs(_ data:[String:String]) {
        var prepRecord : [String:String] = [:]
        var strURL = self.appSettings!["URL"]! +       "setmultipair.php?surveyID=\(self.surveyID!)&"
        var i = data.count
        for (k, v) in data {
            i -= 1
            let prepkey = k.replacingOccurrences(of: " ", with: "+")
            prepRecord[prepkey] = v
            strURL += "kvp[\(prepkey)]=\(v)"
            if i > 0 {strURL += "&"}
        }
        
        //print("&&\(strURL)")
        
        //connect and send data
        
        let url = URL(string: strURL)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Survey: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            let success = String(data: data!, encoding: .utf8)
            self.delegate?.multiPairSetWithResponse(data: success!)
        }).resume()
        
    }
    
    static func fetchKVPairs() {
        let surveyid = self.surveyID
        let strURL = self.appSettings!["URL"]! + "fetchkvpairs.php?surveyid=\(surveyid!)"
        print("&&kvpair url: \(strURL)")
        let url = URL(string: strURL)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Survey: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Survey: in do in completion handler: \(data!)")
                
                let jsonDecoder = JSONDecoder()
                //print("&&Survey: jsonDecoder assigned")
                let pairs = try jsonDecoder.decode([String:String].self, from: data!)
                //print("&&Session list for \(forUser): \(list)")
                
                self.delegate?.kvpairsfetched(data: pairs)
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }

    static func getSurveyList(forUser:String, filter:String, history:String, mindate:String) {
        let mdate = mindate.replacingOccurrences(of: " ", with: "+")
        let strURL = self.appSettings!["URL"]! + "fetchsurveys.php?emptkey=\(forUser)&status=\(filter)&" +
            "history=\(history)&mindate=\(mdate)"
        
        //print("&&Query:\(strURL)")
        
        let url = URL(string: strURL)!
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Survey: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Survey: in do in completion handler: \(data!)")
                
                let jsonDecoder = JSONDecoder()
                //print("&&Survey: jsonDecoder assigned")
                var list = try jsonDecoder.decode(EntryType.self, from: data!)
                //print("&&Session list for \(forUser): \(list)")
                for (k, v) in list {
                    for (l, w) in v {
                        list[k]?[l] = w.replacingOccurrences(of: "(apos)", with: "\u{0027}")
                    }
                }
                //print(list)
                self.delegate?.surveyListReturnedWith(data: list)
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }
    
    static func deleteSurvey(surveyid:String, note:String, empid:String) {
        let strURL = self.appSettings!["URL"]! +
            "deletesurvey.php?surveyid=" + surveyid +
            "&reftype=workorderno" +
            "&note=" + note +
            "&empid=" + empid +
            "&deviceid=" + self.deviceID!
        print(strURL)
        let url = URL(string: strURL)!
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error -> Void in
            //print("&&Survey: in completion handler")
            if error != nil {
                print("&&No Connection:\(String(describing: error?.localizedDescription))")
                return
            }
            do {
                //print("&&Survey: in do in completion handler: \(data!)")
                
                let jsonDecoder = JSONDecoder()
                //print("&&Survey: jsonDecoder assigned")
                let resData = try jsonDecoder.decode([String:String].self, from: data!)
                //print("&&Session list for \(forUser): \(list)")
                
                //print(list)
                self.delegate?.surveyDeleted(data: resData)
            } catch {
                print("&&JSON Serialization error")
            }
        }).resume()
    }
    
    static func percentEncode(_ this:String) -> String {
        var retVal = this.replacingOccurrences(of: "%", with: "%25")
        retVal = this.replacingOccurrences(of: "!", with: "%21")
        retVal = this.replacingOccurrences(of: "#", with: "%23")
        retVal = this.replacingOccurrences(of: "$", with: "%24")
        retVal = this.replacingOccurrences(of: "&", with: "%26")
        retVal = this.replacingOccurrences(of: "'", with: "%27")
        retVal = this.replacingOccurrences(of: "(", with: "%28")
        retVal = this.replacingOccurrences(of: ")", with: "%29")
        retVal = this.replacingOccurrences(of: "*", with: "%2A")
        retVal = this.replacingOccurrences(of: "+", with: "%2B")
        retVal = this.replacingOccurrences(of: ",", with: "%2C")
        retVal = this.replacingOccurrences(of: "/", with: "%2F")
        retVal = this.replacingOccurrences(of: ":", with: "%2F")
        retVal = this.replacingOccurrences(of: ";", with: "%2F")
        retVal = this.replacingOccurrences(of: "=", with: "%2F")
        retVal = this.replacingOccurrences(of: "?", with: "%2F")
        retVal = this.replacingOccurrences(of: "@", with: "%2F")
        retVal = this.replacingOccurrences(of: "[", with: "%2F")
        retVal = this.replacingOccurrences(of: "]", with: "%2F")
        return retVal
    }
 }
