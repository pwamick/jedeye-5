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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lbPrompt!.text = promptText!
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Session.addToEquipmentSelectionDict(id: "LiftWeight", value: self.txWeight!.text!)
        Session.setKVPair(key: "LiftWeight", value: self.txWeight!.text!)
        let destVC = segue.destination as? MeasurementViewController
        let nextOrdPos = "60"
        destVC!.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
    }
    

}
