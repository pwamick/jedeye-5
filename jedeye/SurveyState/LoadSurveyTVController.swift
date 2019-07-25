//
//  LoadSurveyTVController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/30/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class LoadSurveyTVController: UITableViewController, AsynchDataDelegate {
    
    var userSurveyList : EntryType? = [:]
    var sectionedList : [String:[String]] = [:]
    var tableList : [String:[(site:String, contractor:String, wonum:String)]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //print("&&&User Surveys: \(self.userSurveyList?.count)")
        
        self.tabBarController?.title = "Surveys"
        Session.delegate = self
        Session.getSurveyList(forUser: Session.usertkey!, filter: "o", history:"0", mindate:"2019-01-01 00:00:00")
        
        let bbtnEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editing(sender:)))
        let bbtnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSurvey(sender:)))
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [bbtnAdd, bbtnEdit]
        
    }
    
    @objc func editing(sender: UIBarButtonItem) {
        self.setEditing(true, animated: true)
    }
    
    @objc func addSurvey(sender: UIBarButtonItem) {
        print("&&Add pressed")
        Session.obtainSurveyID()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
    }

    // MARK: - Table view data source
    
    func surveyListReturnedWith(data: EntryType) {
        self.userSurveyList = data
        self.makeLists()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func makeLists() {
        self.sectionedList = [:]
        self.tableList = [:]
        //sectionedList is to make the index elements easier
        print(self.userSurveyList!)
        for (k, a) in self.userSurveyList! {
            self.sectionedList[k] = ([
                a["s_lname"],
                a["c_lname"],
                a["workorderno"]
                ] as! [String])
        }
        //print("&&Sectioned List is: \(self.sectionedList)")
        
        //build the table view hierarchy:
        
        var bag: Set<String> = []
        
        for (k, _) in self.sectionedList {
            let sitename = self.sectionedList[k]![0] //s_lname
            let firstcharofsite = String(sitename.dropLast(sitename.count - 1))
            bag.insert(firstcharofsite)
        }
        //print("&&Bag contents: \(bag)")
        for s in bag {
            for (_, v) in self.sectionedList {
                //if s == the first letter of self.sectionedList[k][0]
                let sitename = v[0] //s_lname
                let conname = v[1] //c_lname
                let wonum = v[2] //workorderno
                let firstcharofsite = String(sitename.dropLast(sitename.count - 1))
                if s == firstcharofsite {
                    //print("&&Match: \(s) == \(firstcharofsite)")
                    if self.tableList[s]?.isEmpty ?? true {
                        self.tableList[s] = [(site: sitename, contractor: conname, wonum:wonum)]
                    } else {
                        self.tableList[s]?.append((site: sitename, contractor: conname, wonum:wonum))
                    }
                }
            }
        }
        //print("&&Table List count: \(self.tableList.count)")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableList.keys.count
        //return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sortedKeys = Array(self.tableList.keys).sorted()
        let sectionrows = self.tableList[sortedKeys[section]]
        
        return sectionrows!.count
        
        //return self.userSurveyList!.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedKeys = Array(self.tableList.keys).sorted()
        return sortedKeys[section]
    }
 
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var bag: Set<String> = []
        var retVal : [String]?
        for k in self.sectionedList.keys {
            //print(k)
            let sitename = self.sectionedList[k]![0] //s_lname
            let firstcharofsite = String(sitename.dropLast(sitename.count - 1))
            bag.insert(firstcharofsite)
        }
        retVal = Array(bag)
        return retVal?.sorted()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoadCell", for: indexPath) as! LoadViewCell
        
        let sortedSectionTitles = Array(self.tableList.keys).sorted()
        //sectioncellinfo is an array of tuple of site, contractor, wonum
        let sectioncellinfo = self.tableList[sortedSectionTitles[indexPath.section]]
        let thiscellinfo = sectioncellinfo![indexPath.row]
        let sitetext = thiscellinfo.site
        let contractortext = thiscellinfo.contractor
        let workordernumber = thiscellinfo.wonum
        /*
        // non-hierarchical view
        let sortedKeys = Array(self.userSurveyList!.keys).sorted()
        let sitetext = self.userSurveyList![sortedKeys[indexPath.row]]!["s_lname"]
        let contractortext = self.userSurveyList![sortedKeys[indexPath.row]]!["c_lname"]
        */
        cell.lbSiteName!.text = sitetext
        cell.lbContractor!.text = contractortext
        cell.lbWONum!.text = workordernumber
        cell.workOrderNo = workordernumber

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let listKeys = Array(self.userSurveyList!.keys).sorted()
        //let currentKey = listKeys[indexPath.row]
        
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! LoadViewCell
        let currentKey = selectedCell.workOrderNo
        print("&&\(currentKey!)")
        print("&&Loading Survey No. \(userSurveyList![currentKey!]!["workorderno"]!)")
        let siteName = selectedCell.lbSiteName?.text
        
        //give the user the opportunity to save the current session:
        let alertController = UIAlertController(title: "Load Survey?", message: "Are you sure you want to load Survey Number \(currentKey!): \"\(siteName!)?\"", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.copySurveyData(currentKey:currentKey!)
            //this will fire the kvpairsfetched delegate method of Session:
            Session.fetchKVPairs()
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction) in
            //nothing done here
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func kvpairsfetched(data: [String : String]) {
        //print("&&kvpair data: \(data)")
        Session.surveyData?.surveySelections = data
        
        DispatchQueue.main.async {
            
            let index = self.navigationController?.viewControllers[1] as! MainTVController
            self.navigationController?.popToViewController(index as UIViewController, animated: true)
            
            
        }
    }
    
    func copySurveyData(currentKey:String) {
        //there is only one instance of surveyData, just
        //nullify it:
        Session.surveyData?.nullifyAll()
        //copy values into surveyData
        //print(self.userSurveyList!)
        Session.surveyID = self.userSurveyList![currentKey]!["workorderno"]!
        Session.surveyData!.entereddatetime = "NULL"
        Session.surveyData!.startdatetime = self.userSurveyList![currentKey]!["startdate"]!
        Session.surveyData!.enddatetime = self.userSurveyList![currentKey]!["enddate"]!
        Session.surveyData!.status = self.userSurveyList![currentKey]!["status"]!
        Session.surveyData!.desc = self.userSurveyList![currentKey]!["description"]!
        //wow. this really sucks.
        Session.surveyData!.surveytype = self.userSurveyList![currentKey]!["surveytype"]!
        Session.surveyData!.enditem = self.userSurveyList![currentKey]!["enditem"]!
        Session.surveyData!.enditemqty = self.userSurveyList![currentKey]!["enditemqty"]!
            
        Session.surveyData!.note = self.userSurveyList![currentKey]!["survey_note"]!
        Session.surveyData!.trackingno = self.userSurveyList![currentKey]!["trackingno"]!
        Session.surveyData!.customerpo = self.userSurveyList![currentKey]!["customerpo"]!
        Session.surveyData!.authorizationno = self.userSurveyList![currentKey]!["authorizationno"]!
            
        Session.surveyData!.contractorid = self.userSurveyList![currentKey]!["contractorid"]!
        Session.surveyData!.c_fname = self.userSurveyList![currentKey]!["c_fname"]!
        Session.surveyData!.c_lname = self.userSurveyList![currentKey]!["c_lname"]!
        Session.surveyData!.c_addr1 = self.userSurveyList![currentKey]!["c_addr1"]!
        Session.surveyData!.c_addr2 = self.userSurveyList![currentKey]!["c_addr2"]!
        Session.surveyData!.c_city = self.userSurveyList![currentKey]!["c_city"]!
        Session.surveyData!.c_state = self.userSurveyList![currentKey]!["c_state"]!
        Session.surveyData!.c_postalcode = self.userSurveyList![currentKey]!["c_postalcode"]!
            
        Session.surveyData!.c_phone = self.userSurveyList![currentKey]!["c_phone"]!
        Session.surveyData!.c_phone2 = self.userSurveyList![currentKey]!["c_phone2"]!
        Session.surveyData!.c_note = self.userSurveyList![currentKey]!["c_note"]!
            
        Session.surveyData!.siteid = self.userSurveyList![currentKey]!["siteid"]!
        Session.surveyData!.s_fname = self.userSurveyList![currentKey]!["s_fname"]!
        Session.surveyData!.s_lname = self.userSurveyList![currentKey]!["s_lname"]!
        Session.surveyData!.s_addr1 = self.userSurveyList![currentKey]!["s_addr1"]!
        Session.surveyData!.s_addr2 = self.userSurveyList![currentKey]!["s_addr2"]!
        Session.surveyData!.s_city = self.userSurveyList![currentKey]!["s_city"]!
        Session.surveyData!.s_state = self.userSurveyList![currentKey]!["s_state"]!
        Session.surveyData!.s_postalcode = self.userSurveyList![currentKey]!["s_postalcode"]!
            
        Session.surveyData!.s_phone = self.userSurveyList![currentKey]!["s_phone"]!
        Session.surveyData!.s_phone2 = self.userSurveyList![currentKey]!["s_phone2"]!
        Session.surveyData!.s_note = self.userSurveyList![currentKey]!["s_note"]!
        
        //gps data:
        Session.surveyData!.gps = self.userSurveyList![currentKey]!["gps"]!
    
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! LoadViewCell
        let surveyid = cell.workOrderNo!
        print("&&Deleting: \(surveyid)")
        if editingStyle == .delete {
            self.userSurveyList?.removeValue(forKey: surveyid)
            self.makeLists()
            /***
             Session.deleteSurvey(surveyid: surveyid, note: "User deletion", empid: Session.usertkey)
             ***/
            
            //remove the row from the physical table view. If we'd be removing
            //the last row of a section, remove the section instead:
            let indexSet = IndexSet(integer: indexPath.section)
            if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                tableView.deleteSections(indexSet, with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "LoadToSaveSegue":
            /**/
            let destVC = segue.destination as! SaveSurveyViewController
            destVC.btnSaveText = "Add"
        default:
            print("&&Non Existant Segue in Load VC")
        }
    }
    
    func surveyIDReturnedWith(data: [String : String]) {
        print("&&SurveyID: \(data["surveyid"]!)")
        Session.surveyID = data["surveyid"]
        Session.surveyData?.nullifyAll()
        Session.surveyData?.surveySelections = [:]
        DispatchQueue.main.async{
            self.performSegue(withIdentifier: "LoadToSaveSegue", sender: self)
        }
    }

}
