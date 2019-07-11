//
//  SurveyTypeViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 6/1/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class SurveyTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AsynchDataDelegate {
    
    let C_TVONE = 0
    let C_TVTWO = 1
    
    var newProjectType : String?
    
    var tvData : [String] = []
    
    @IBOutlet weak var tableview : UITableView?
    
    @IBOutlet weak var lbFirstField : UILabel?
    @IBOutlet weak var lbSecondField : UILabel?
    @IBOutlet weak var txFirstField : UITextField?
    @IBOutlet weak var txSecondField : UITextField?
    @IBOutlet weak var btnNewSurvey : UIButton?
    
    
    
    @IBAction func txFieldOneClicked(sender:UITextField) {
        Session.surveyTypeDropDownContent(custType: "Project")
        self.tableview?.tag = C_TVONE
        if (!(txSecondField!.text!.isEmpty)) {
            self.btnNewSurvey!.isEnabled = true
        }
    }
    
    @IBAction func txFieldTwoClicked(sender:UITextField) {
        Session.surveyTypeDropDownContent(custType: "Company")
        self.tableview?.tag = C_TVTWO
        if (!(txFirstField!.text!.isEmpty)) {
            self.btnNewSurvey!.isEnabled = true
        }
    }
    
    func surveyTypeReturnedWith(data: [String]) {
        self.tvData = data
        DispatchQueue.main.async {
            self.tableview?.reloadData()
            self.tableview?.isHidden = false
        }
        
    }
    
    @IBAction func btnNewSurveyClicked(sender:UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbFirstField?.text = "Project Name"
        self.lbSecondField?.text = "Contractor"
        Session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        self.tableview?.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TableView delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview?.dequeueReusableCell(withIdentifier: "dropdowncell", for: indexPath)
        cell?.textLabel!.text = self.tvData[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableview?.cellForRow(at: indexPath)
        let selectedText = selectedCell?.textLabel?.text
        if (self.tableview?.tag == C_TVONE) {
            self.txFirstField?.text = selectedText
        }
        if (self.tableview?.tag == C_TVTWO) {
            self.txSecondField?.text = selectedText
        }
        if (self.txFirstField?.text != "" && self.txSecondField?.text != "") {
            self.btnNewSurvey?.isEnabled = true
        }
        self.tableview?.isHidden = true
    }
}
