//
//  ArticulatingWallHeightViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/22/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class ArticulatingWallHeightViewController: UIViewController, CarpenterDelegate {
    
    var promptText : String?
    var carpenterMeasureExpected = false
    
    @IBOutlet weak var prompt : UILabel?
    @IBOutlet weak var txHeight : UITextField?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Wall Height"
        self.prompt!.text = promptText
        
        if !carpenterMeasureExpected {
            if let h = Session.surveyData?.surveySelections["WallHeight"] {
                self.txHeight?.text = (h as! String)
            }
        } else {
            carpenterMeasureExpected = false
        }
        
        self.navigationItem.rightBarButtonItem?.title = Session.surveyID
    }
    
    func DecimalMeasureReady(withMeasure: Double, BackID: String) {
        print("&&\(withMeasure)")
        self.txHeight?.text = String(withMeasure)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "WallOutSegue":
            let nextOrdPos = "30"
            let destVC = segue.destination as! MeasureOpeningViewController
            destVC.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
            Session.addToEquipmentSelectionDict(id: "WallHeight", value: self.txHeight!.text!)
            Session.setKVPair(key: "WallHeight", value: self.txHeight!.text!)
        case "WallToCarpSegue":
            carpenterMeasureExpected = true
            let destVC = segue.destination as! CarpenterMeasureViewController
            destVC.backID = ""
            destVC.delegate = self
        default:
            print("&&Non-Existant Segue ID")
        }
    }
}
