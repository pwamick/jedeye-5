//
//  MeasurementViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/20/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class MeasurementViewController: UIViewController, CarpenterDelegate, UITableViewDelegate, UITableViewDataSource, AsynchDataDelegate {
    
    
    var promptText : String?
    var measures : [String:[String]] = [:] // [meas#:[distance, angle]]
    
    @IBOutlet weak var prompt : UILabel?
    @IBOutlet weak var txDistance : UITextField?
    @IBOutlet weak var txAngle : UITextField?
    @IBOutlet weak var table : UITableView?
    
    @IBAction func addAnotherMeasureClicked(sender: UIButton) {
        if txDistance?.text != "" && txAngle?.text != "" {
            //save this distance & angle:
            Session.addToEquipmentSelectionDict(id: "MeasDistance\(self.measures.count)", value: self.txDistance!.text!)
            Session.addToEquipmentSelectionDict(id: "MeasAngle\(self.measures.count)", value: self.txAngle!.text!)
            Session.setKVPairs(
                ["MeasDistance\(self.measures.count)":self.txDistance!.text!,
                 "MeasAngle\(self.measures.count)":self.txAngle!.text!]
            )
            //dispay measure in table view:
            let strCtr = String(self.measures.count)
            print("&&Putting new measure in slot \(strCtr)")
            self.measures[strCtr] = [self.txDistance!.text!, self.txAngle!.text!]
            print("Measures is: \(self.measures)")
            self.table?.reloadData()
            //blank the text fields
            self.txAngle?.text = ""
            self.txDistance?.text = ""
            self.txAngle?.resignFirstResponder()
            self.txDistance?.resignFirstResponder()
            //bump the attribute name counter
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Measurement"
        self.prompt?.text = promptText
        Session.delegate = self
        //for a scissor lift, the angle is always 90, set and disable:
        self.measures = [:]
        if Session.getSelection()["Type"] as! String == "Scissor Lift" {
            self.txAngle!.text = "90.0"
            self.txAngle!.isEnabled = false
        }
        /* uncomment to display MeasDistance1 and MeasAngle1 in
           the text fields. Commented out 08/05/2019 by RCC */
        /*
        if let distance = Session.surveyData?.surveySelections["MeasDistance1"] {
            self.txDistance?.text = (distance as! String)
        }
        
        if let angle = Session.surveyData?.surveySelections["MeasAngle1"] {
            self.txAngle?.text = (angle as! String)
        }
        */
        
        self.navigationItem.rightBarButtonItem?.title = Session.surveyID
        
        //get all the measurement distances and angles from the survey selections:
        let selections = Session.surveyData?.surveySelections
        let selKeys = Array(selections!.keys)
        var measKeys : [String] = []
        for k in selKeys {
            if k.contains("Meas") {
                measKeys.append(k)
            }
        }
        for k in measKeys {
            let num = String(k.last!)
            let distance = selections!["MeasDistance" + num]
            let angle = selections!["MeasAngle" + num]
            self.measures[String(num)] = ([distance, angle] as! [String])
        }
        self.table?.reloadData()
    }
    
    func DecimalMeasureReady(withMeasure: Double, BackID: String) {
        self.txDistance?.text = String(withMeasure)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.measures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeasureCell", for: indexPath)
        let sortedMeasures = Array(self.measures.keys).sorted()
        let distance = self.measures[sortedMeasures[indexPath.row]]![0]
        let angle = self.measures[sortedMeasures[indexPath.row]]![1]
        print("&&measures: \(self.measures[sortedMeasures[indexPath.row]]!)")
        cell.textLabel?.text = "D : \(distance)"
        cell.detailTextLabel?.text = "A : \(angle)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //measures are 1-based, tableview cells are 0-based. Bump:
        let measureIndex = indexPath.row
        //allow user to edit the distance and angle:
        let alert = UIAlertController(title: "Editing", message: "Edit the distance and angle below", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(txDistance: UITextField) -> Void in
            txDistance.text = self.measures[String(measureIndex)]![0]
        })
        alert.addTextField(configurationHandler: {(txAngle: UITextField) -> Void in
            txAngle.text = self.measures[String(measureIndex)]![1]
            if Session.getSelection()["Type"] as! String == "Scissor Lift" {
                txAngle.isEnabled = false
            }
        })
        
        //save editing action:
        
        let actSaveEdit = UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) -> Void in
            //print(type(of: alert.textFields![0].text!))
            let distance = alert.textFields![0].text!
            let angle = alert.textFields![1].text!
            self.measures[String(measureIndex)]! = [distance, angle]
            DispatchQueue.main.async {
                self.table?.reloadData()
            }
        })
 
        //Deleting action... this will delete all Measurements
        //in the database for this workorderno!!!
        let actDelete = UIAlertAction(title: "Delete ALL Measurements", style: .default, handler: { (action:UIAlertAction) -> Void in
            
            let delAlert = UIAlertController(title: "WARNING", message: "This will delete ALL Distance / Angle measurements from this survey. Are You Sure?", preferredStyle: .alert)
            let actYes = UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction) -> Void in
                Session.clearAllMeasurements(forSurvey: Session.surveyID!, withNote: "Deleted by user \(Session.usertkey!)")
            })
            let actNo = UIAlertAction(title: "No", style: .default, handler: nil)
            
            delAlert.addAction(actYes)
            delAlert.addAction(actNo)
            self.present(delAlert, animated: true, completion: nil)
        })
        
        //Cancelling action
        let actCancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction) -> Void in
            //do nothing!
        })
        
        //Spacer "action"
        let actSpacer = UIAlertAction(title: "", style: .default, handler: nil)
        
        alert.addAction(actSaveEdit)
        alert.addAction(actCancel)
        alert.addAction(actSpacer)
        alert.addAction(actDelete)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func measurementsDeleted(data: [String]) {
        print("&&Deleted: \(data)")
        self.measures = [:]
        
        for (k, _) in Session.surveyData!.surveySelections {
            if k.contains("Meas") {
                Session.surveyData?.surveySelections[k] = nil
            }
        }
        DispatchQueue.main.async {
            self.table?.reloadData()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var retVal = false
        switch identifier {
        case "AccessSegue":
            if self.measures.count != 0 {
                retVal = true
            } else {
                let alertController = UIAlertController(title: "Required Fields", message:"You must enter at least one distance and angle measurement", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    // nothing to see here.
                }))
                
                present(alertController, animated: true, completion: nil)
            }
        case "MeasurementToCarpSegue":
            retVal = true
        default:
            print("Unknown segue identifier")
        }
        
        return retVal
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var nextOrdPos : String?
        switch segue.identifier {
        case "AccessSegue":
            let features = Session.getSelection()
            if ((features["Type"] as? String)!.contains("Boom")) {
                //Boom accessories:
                if ((features["Power"] as? String)!.contains("Electric")) {
                    //electric boom
                    nextOrdPos = "75"
                } else {
                    //4x4 boom
                    nextOrdPos = "70"
                }
            } else if ((features["Type"] as? String)!.contains("Scissor")) {
                //Scissor lift accessories
                if ((features["Power"] as? String)!.contains("Electric")) {
                    //electric boom
                    nextOrdPos = "85"
                } else {
                    //4x4 boom
                    nextOrdPos = "80"
                }
            } else if ((features["Type"] as? String)!.contains("Tele")) {
                //Telehandler
                nextOrdPos = "90"
            }
            
            var kvPairsForDB : [String:String] = [:]
            //save all this nonsense:
            for (k, v) in self.measures {
                Session.addToEquipmentSelectionDict(id: "MeasDistance\(k)", value: v[0])
                Session.addToEquipmentSelectionDict(id: "MeasAngle\(k)", value: v[1])
                kvPairsForDB["MeasDistance\(k)"] = v[0]
                kvPairsForDB["MeasAngle\(k)"] = v[1]
            }
            Session.setKVPairs(kvPairsForDB)
            
            let destVC = segue.destination as? AccessoriesTVController
            let dict = Session.getQuestionsHaving(ordPos: nextOrdPos!, sourceType: "questions")
            var arrAccessories : [String] = []
            for (_, value) in dict {
                arrAccessories.append(value["displayname"]!)
            }
            destVC?.arrAccessories = arrAccessories
        case "MeasurementToCarpSegue":
            print("&&Going to Carp")
            let destVC = segue.destination as! CarpenterMeasureViewController
            destVC.delegate = self
            destVC.backID = ""
        default:
            print("&&Non-Existant Segue ID")
        }
    }
}
