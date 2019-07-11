//
//  PowerViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/20/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class PowerViewController: UIViewController {
    
    //var survey : Survey?
    //var navController : NavController?
    var promptText : String?
    
    @IBOutlet weak var prompt : UILabel?
    @IBOutlet weak var hasPower : UISwitch?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Power"
        self.prompt!.text = promptText
        
        if let pow = Session.surveyData?.surveySelections["HasPower"] {
            if (pow as! String) == "true" {
                self.hasPower?.isOn = true
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PowerSetSegue":
            if (self.hasPower!.isOn) {
                Session.addToEquipmentSelectionDict(id: "HasPower", value: "true")
                Session.setKVPair(key: "HasPower", value: "true")
            } else {
                Session.addToEquipmentSelectionDict(id: "HasPower", value: "false")
                Session.setKVPair(key: "HasPower", value: "false")
            }
            let nextOrdPos = "60"
            let destVC = segue.destination as? MeasurementViewController
            destVC!.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
            
        default:
            print("&&Unknown Segue ID")
        }
    }
    

}
