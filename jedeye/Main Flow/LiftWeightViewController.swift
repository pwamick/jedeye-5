//
//  LiftWeightViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 7/5/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class LiftWeightViewController: UIViewController {
    
    var promptText : String?
    
    @IBOutlet weak var lbPrompt : UILabel?
    @IBOutlet weak var txWeight : UITextField?
    
    @IBAction func btnNextClicked (sender:UIButton) {
        if self.txWeight?.text != "" {
            self.performSegue(withIdentifier: "LiftWeightToMeasurement", sender: self)
        } else {
            let alertController = UIAlertController(title: "Entry Required", message: "You must enter a weight to proceed.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                // nothing to see here.
            }))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lbPrompt!.text = promptText!
        
        if let lweight = Session.surveyData?.surveySelections["LiftWeight"] {
            self.txWeight?.text = (lweight as! String)
        }
        self.navigationItem.rightBarButtonItem?.title = Session.surveyID
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "LiftWeightToMeasurement" :
            Session.addToEquipmentSelectionDict(id: "LiftWeight", value: self.txWeight!.text!)
            Session.setKVPair(key: "LiftWeight", value: self.txWeight!.text!)
            let destVC = segue.destination as? MeasurementViewController
            let nextOrdPos = "60"
            destVC!.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
        default:
            print("&&Non Existant Segue ID in Lift Wieght VC")
        }
    }
}
