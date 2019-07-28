//
//  FiveHundredLbViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/20/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class FiveHundredLbViewController: UIViewController {
    
    var pvc : PowerViewController?
    var mvc : MeasurementViewController?
    
    var promptText : String?
    @IBOutlet weak var prompt : UILabel?
    @IBOutlet weak var isHeavy : UISwitch?
    @IBAction func btnNextScreen(sender : UIButton) {
        //set the selection element:
        if (self.isHeavy!.isOn) {
            Session.addToEquipmentSelectionDict(id: "gt500", value: "true")
            Session.setKVPair(key: "gt500", value: "true")
        } else {
            Session.addToEquipmentSelectionDict(id: "gt500", value: "false")
            Session.setKVPair(key: "gt500", value: "false")
        }
        if (Session.getSelection()["Type"] as! String) == "TeleHandler" {
            self.performSegue(withIdentifier: "MeasurementSeque", sender: sender)
        } else {
            let powerType = Session.getSelection()["Power"]
            if ((powerType as? String) == "Electric") {
                self.performSegue(withIdentifier: "PowerSegue", sender: sender)
            } else {
                self.performSegue(withIdentifier: "MeasurementSegue", sender: sender)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "> 500 Lb?"
        self.prompt!.text = promptText
        
        if let gt5c = Session.surveyData?.surveySelections["gt500"] {
            if (gt5c as! String) == "true" {
                self.isHeavy?.isOn = true
            }
        }
        self.navigationItem.rightBarButtonItem?.title = Session.surveyID
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "MeasurementSegue":
            let destVC = segue.destination as? MeasurementViewController
            let nextOrdPos = "60"
            destVC!.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
        case "PowerSegue":
            let destVC = segue.destination as? PowerViewController
            let nextOrdPos = "55"
            destVC!.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
        default:
            print("&&Non-Existant Segue ID")
        }
    }
}
