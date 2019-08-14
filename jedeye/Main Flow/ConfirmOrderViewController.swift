//
//  ConfirmOrederViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 8/7/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController {
    
    var manufacturer : String?
    var model : String?
    var quantity : String?
    var inventoryid : String?
    
    @IBOutlet weak var lbPrompt : UILabel?
    @IBOutlet weak var dpvNeeded: UIDatePicker?
    @IBOutlet weak var dpvReturning: UIDatePicker?
    
    @IBAction func btnConfirmClick(sender: UIButton) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd+HH:mm:ss"
        let needed = dateformatter.string(from: self.dpvNeeded!.date)
        let returning = dateformatter.string(from: self.dpvReturning!.date)
        let alert = UIAlertController(title: "Confirm", message: "Confirm the order of \(self.quantity!) units of \(self.manufacturer!) \(self.model!) to be delivered on \(needed) and returned on \(returning)?", preferredStyle: .alert)
        Session.surveyData?.startdatetime = needed
        Session.surveyData?.enddatetime = returning
        Session.surveyData?.enditem = self.inventoryid!
        Session.surveyData?.enditemqty = self.quantity!
        let actYes = UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction) -> Void in
            Session.surveyData?.status = "submitted"
            Session.saveSurvey(surveyType: "adhoc")
        })
        let actNo = UIAlertAction(title: "No", style: .default, handler: { (action:UIAlertAction) -> Void in
            
        })
        alert.addAction(actYes)
        alert.addAction(actNo)
        present(alert, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.title = "Confirm"
        self.lbPrompt?.text = "Please confirm selection of \(self.quantity ?? "<Error>") units of \(self.model ?? "<Error>")"
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
