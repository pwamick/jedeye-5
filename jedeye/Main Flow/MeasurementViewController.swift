//
//  MeasurementViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/20/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class MeasurementViewController: UIViewController, CarpenterDelegate {
    
    //var survey : Survey?
    //var navController : NavController?
    
    var promptText : String?
    @IBOutlet weak var prompt : UILabel?
    @IBOutlet weak var txDistance : UITextField?
    @IBOutlet weak var txAngle : UITextField?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Measurement"
        //self.navController = self.navigationController as? NavController
        //self.survey = self.navController?.survey
        self.prompt?.text = promptText
        //for a scissor lift, the angle is always 90, set and disable:
        if Session.getSelection()["Type"] as! String == "Scissor Lift" {
            self.txAngle!.text = "90.0"
            self.txAngle!.isEnabled = false
        }
    }
    
    func DecimalMeasureReady(withMeasure: Double, BackID: String) {
        self.txDistance?.text = String(withMeasure)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var retVal = false
        switch identifier {
        case "AccessSegue":
            if self.txDistance!.text != "" && self.txAngle!.text != "" {
                retVal = true
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
            Session.addToEquipmentSelectionDict(id: "MeasDistance", value: self.txDistance!.text!)
            Session.addToEquipmentSelectionDict(id: "MeasAngle", value: self.txAngle!.text!)
            Session.setKVPairs(
                ["MeasDistance":self.txDistance!.text!,
                 "MeasAngle":self.txAngle!.text!]
            )
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
