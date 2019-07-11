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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Load"
        Session.delegate = self
        Session.getSurveyList(forUser: Session.usertkey!, filter: "o", history:"0", mindate:"2019-01-01 00:00:00")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    func surveyListReturnedWith(data: EntryType) {
        self.userSurveyList = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userSurveyList!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoadCell", for: indexPath)
        
        let listKeys = Array(self.userSurveyList!.keys).sorted()
        let currentKey = listKeys[indexPath.row]
        cell.textLabel!.text = self.userSurveyList![currentKey]!["s_lname"]
        cell.detailTextLabel!.text = self.userSurveyList![currentKey]!["c_lname"]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listKeys = Array(self.userSurveyList!.keys).sorted()
        let currentKey = listKeys[indexPath.row]
        print("&&Loading Survey No. \(userSurveyList![currentKey]!["workorderno"]!)")
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        let siteName = selectedCell?.detailTextLabel?.text
        
        //give the user the opportunity to save the current session:
        let alertController = UIAlertController(title: "Save Session?", message: "Would you like to save the current session before loading \"\(siteName!)?\"", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            Session.saveSurvey(surveyType: "NULL")
            self.copySurveyData(currentKey:currentKey)
            //this will fire the kvpairsfetched delegate method of Session:
            Session.fetchKVPairs()
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
            self.copySurveyData(currentKey: currentKey)
            //this will fire the kvpairsfetched delegate method of Session:
            Session.fetchKVPairs()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
            //do nothing
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func kvpairsfetched(data: [String : String]) {
        print("&&kvpair data: \(data)")
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
        Session.surveyData!.surveyid = self.userSurveyList![currentKey]!["workorderno"]!
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
