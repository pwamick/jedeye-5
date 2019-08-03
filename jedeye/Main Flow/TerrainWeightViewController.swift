//
//  TerrainWeightViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/18/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class TerrainWeightViewController: UIViewController {
    
    var promptText : String?
    @IBOutlet weak var prompt: UILabel?
    
    @IBOutlet weak var txTerrainWeight: UITextField?
    
    @IBAction func btnNextClicked(sender:UIButton) {
        if Session.getSelection()["Type"] as! String != "Telehandler" {
            performSegue(withIdentifier: "FiveHundredSegue", sender: sender)
        } else {
            performSegue(withIdentifier: "LiftWeightSegue", sender: sender)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.title = "Weight Max"
        self.prompt!.text = promptText
        
        if let w = Session.surveyData?.surveySelections["TerWeight"] {
            self.txTerrainWeight?.text = (w as! String)
        }
        self.navigationItem.rightBarButtonItem?.title = Session.surveyID
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Session.addToEquipmentSelectionDict(id:"TerWeight", value: self.txTerrainWeight!.text!)
        Session.setKVPair(key: "TerWeight", value: self.txTerrainWeight!.text!)
        switch segue.identifier {
        case "FiveHundredSegue":
            let destVC = segue.destination as? FiveHundredLbViewController
            let nextOrdPos = "50"
            destVC!.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
        case "LiftWeightSegue" :
            let destVC = segue.destination as? LiftWeightViewController
            let nextOrdPos = "56"
            destVC!.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
        default:
            print("&&No Such Segue")
        }
    }
}
