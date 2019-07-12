//
//  MeasureOpeningViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/18/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class MeasureOpeningViewController: UIViewController, CarpenterDelegate {
    
    var measureType : String?
    var promptText : String?
    
    @IBOutlet weak var prompt : UILabel?
    @IBOutlet weak var txWidth : UITextField?
    @IBOutlet weak var txHeight : UITextField?
    
    @IBAction func measureButton(sender:UIButton) {
        switch sender.tag {
        case 0:
            measureType = "width"
            break
        case 1:
            measureType = "height"
        default:
            print("&&Unknown measurement type")
        }
    }
    
    @IBAction func widthMeasureTextEntry(sender:UITextField) {
        print("&&\(sender.text!)")
    }
    
    @IBAction func heightMeasureTextEntry(sender:UITextField) {
        print("&&\(sender.text!)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Opening"
        self.prompt!.text = promptText!
        
        if let w = Session.surveyData?.surveySelections["OpeningWidth"] {
            self.txWidth?.text = (w as! String)
        }
        if let h = Session.surveyData?.surveySelections["OpeningHeight"] {
            self.txHeight?.text = (h as! String)
        }
        
    }
    
    func DecimalMeasureReady(withMeasure: Double, BackID: String) {
        //print("&&measure:\(withMeasure)")
        switch BackID {
        case "WIDTH":
            self.txWidth?.text = String(withMeasure)
        case "HEIGHT":
            self.txHeight?.text = String(withMeasure)
        default:
            print("&&BackID not valid for this controller")
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "terrainWeight":
            let destVC = segue.destination as? TerrainWeightViewController
            let nextOrdPos = "40"
            Session.addToEquipmentSelectionDict(id:"OpeningWidth", value: self.txWidth!.text!)
            Session.addToEquipmentSelectionDict(id:"OpeningHeight", value: self.txHeight!.text!)
            Session.setKVPair(key: "OpeningWidth", value: self.txWidth!.text!)
            Session.setKVPair(key: "OpeningHeight", value: self.txHeight!.text!)
            destVC!.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
        case"OpeningWidthToCarpSegue":
            let destVC = segue.destination as! CarpenterMeasureViewController
            destVC.delegate = self
            destVC.backID = "WIDTH"
        case "OpeningHeightToCarpSegue":
            let destVC = segue.destination as! CarpenterMeasureViewController
            destVC.delegate = self
            destVC.backID = "HEIGHT"
        default:
            print("&&no such segue")
        }
    }
}
