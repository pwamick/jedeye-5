//
//  SaveSurveyViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/30/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class SaveSurveyViewController: UIViewController, AsynchDataDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, AddressDelegate {
    
    var btnSaveText = "Add"
    
    let PROJECT     = 1
    let CONTRACTOR  = 2
    var addressControllerHasData = false
    
    var tvData : [String:String] = [:]
    
    @IBOutlet weak var lbSiteProj : UILabel?
    @IBOutlet weak var tableview : UITableView?
    @IBOutlet weak var txClient : UITextField?
    @IBOutlet weak var txName : UITextField?
    @IBOutlet weak var tvDescripton : UITextView?
    @IBOutlet weak var btnSave : UIButton?
    @IBOutlet weak var swSiteProj : UISwitch?
    
    var customerID : String?
    
    @IBAction func swSiteProjChanged(sender: UISwitch){
        self.tableview?.isHidden = true
        if sender.isOn {
            self.lbSiteProj?.text = "Project Name"
        } else {
            self.lbSiteProj?.text = "Site Name"
        }
    }
    
    @IBAction func txFieldEditingDidEnd(sender: UITextField) {
        //traps return in keyboard
        sender.resignFirstResponder()
    }
    
    @IBAction func txFieldEditingBegins(sender: UITextField) {
        self.tableview?.isHidden = true
        sender.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func btnSiteListDiscloseListClick(sender:UIButton) {
        self.tableview!.tag = PROJECT
        self.txName?.resignFirstResponder()
        self.txName?.text = ""
        //either project or site, depends on switch.
        var ctype = "site"
        if swSiteProj!.isOn {
            ctype = "project"
        }
        Session.surveyTypeDropDownContent(custType: ctype)
    }
    
    @IBAction func btnClientListDiscloseClick(sender:UIButton) {
        self.tableview!.tag = CONTRACTOR
        self.txClient?.resignFirstResponder()
        self.txClient?.text = ""
        Session.surveyTypeDropDownContent(custType: "Company")
    }
    
    @IBAction func saveButtonClicked(sender:UIButton) {
        if txName!.text != "" && txClient!.text != "" {
            /* should only percent encode the URL:
            var clientText = Session.percentEncode(self.txClient!.text!)
            var nameText = Session.percentEncode(self.txName!.text!)
            let descText = Session.percentEncode(self.tvDescripton!.text!)
            */
            //print("&&&desc = \(descText)")
            var clientText = self.txClient!.text!
            var nameText = self.txName!.text!
            clientText = clientText.prefix(1).uppercased() + clientText.lowercased().dropFirst()
            nameText = nameText.prefix(1).uppercased() + nameText.lowercased().dropFirst()
        
            Session.surveyData!.c_lname = clientText
            Session.surveyData!.s_lname = nameText
            //truncate the description to 255 characters:
            Session.surveyData!.desc = String(self.tvDescripton!.text!.prefix(255))
            //if the user selects a contractor from the dropdown,
            //there is a customer id. If not, make the customer
            //id NULL:
            if self.customerID == nil {
                self.customerID = "NULL"
            }
            Session.surveyData!.contractorid = self.customerID!
            print(Session.surveyID!)
            Session.saveSurvey(surveyType:"adhoc") //not yet
            
        } else {
            txClient!.resignFirstResponder()
            txName!.resignFirstResponder()
            let alertController = UIAlertController(title: "Too Little Info", message: "You must enter both a Site / Project Name and Contractor to proceed", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                //do nothing
            }))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    /*
    @IBAction func btnNewSurveyClicked(sender:UIButton) {
        let alertController = UIAlertController(title: "Start New Survey", message: "You are about to create a new (empty) survey. Are You Sure?", preferredStyle: .alert)
        
        self.btnSave?.setTitle("Start Survey", for: UIControl.State.normal)
        
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
            Session.obtainSurveyID()
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
            // nothing to see here.
        }))
        
        present(alertController, animated: true, completion: nil)
    }

    
    func surveyIDReturnedWith(data: [String : String]) {
        print("&&Save:surveyID:" + data["surveyid"]!)
        Session.surveyID = data["surveyid"]
        Session.surveyData!.nullifyAll()
        Session.surveyData!.surveySelections = [:]
    }
 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        
        self.title = "Add Survey"
        self.btnSave?.setTitle(btnSaveText, for: UIControl.State.normal)
        self.tvDescripton?.layer.borderWidth = 0.5
        self.tvDescripton?.layer.borderColor = UIColor.darkGray.cgColor
        Session.delegate = self
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        self.tableview?.isHidden = true
        self.tvDescripton?.delegate = self
        self.tvDescripton?.returnKeyType = UIReturnKeyType.done
        self.txName?.returnKeyType = UIReturnKeyType.done
        self.txClient?.returnKeyType = UIReturnKeyType.done
        
        let s = Session.surveyData
        if !addressControllerHasData {
            txClient?.text      = ((s?.c_lname != "NULL") ? s?.c_lname : "")
            txName?.text        = ((s?.s_lname != "NULL") ? s?.s_lname : "")
            tvDescripton?.text  = ((s?.desc    != "NULL") ? s?.desc    : "")
            addressControllerHasData = false
        }
        
    }
    
    func surveyTypeReturnedWith(data: [String:String]) {
        self.tvData = data
        DispatchQueue.main.async {
            self.tableview?.reloadData()
            self.tableview?.isHidden = false
        }
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview?.dequeueReusableCell(withIdentifier: "adhocdropdown", for: indexPath) as? DropDownCell
        let stKeys = Array(self.tvData.keys).sorted()
        var celltext = stKeys[indexPath.row]
        let arrLname = celltext.components(separatedBy: "~")
        celltext = arrLname[0]
        cell?.lbName!.text = celltext
        cell?.id = self.tvData[stKeys[indexPath.row]]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableview?.cellForRow(at: indexPath) as? DropDownCell
        let selectedText = selectedCell?.lbName?.text
        
        switch tableview?.tag {
        case PROJECT:
            self.txName?.text = selectedText
        case CONTRACTOR:
            self.txClient?.text = selectedText
        default:
            print("Unknown drop down selection type")
        }
        
        self.customerID = selectedCell?.id
        self.tableview?.isHidden = true
    }
    
    func surveySaved(data: [String : String]) {
        print("&&Survey Saved, return code = " + data["returncode"]!)
        
        DispatchQueue.main.async {
            
            if self.btnSaveText == "Add" {
                let addAlert = UIAlertController(title: "Survey Added", message: "Survey \(Session.surveyID!) created and made the active survey.", preferredStyle: .alert)
                
                addAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    let index = self.navigationController?.viewControllers[1] as! MainTVController
                    self.navigationController?.popToViewController(index as UIViewController, animated: true)
                }))
                
                self.present(addAlert, animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SaveToAddressSegue":
            let destVC = segue.destination as! AddressViewController
            
            //lose focus on all texts, so they aren't cleared on return:
            self.txName?.resignFirstResponder()
            self.txClient?.resignFirstResponder()
            self.tvDescripton?.resignFirstResponder()
            
            destVC.delegate = self
            destVC.backData.site = self.txName!.text!
            destVC.backData.contractor = self.txClient!.text!
            destVC.backData.desc = self.tvDescripton!.text!
            self.addressControllerHasData = true
        default:
            print("&&Unknown segue identifier")
        }
    }
    
    func addressReturnedWith(backData: (site: String, contractor: String, desc: String)) {
        print("&&backData: \(backData)")
        self.txName?.text = backData.site
        self.txClient?.text = backData.contractor
        self.tvDescripton?.text = backData.desc
    }
}
