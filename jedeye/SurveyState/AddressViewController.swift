//
//  AddressViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 6/28/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {
    
    @IBOutlet weak var txAddr1 : UITextField?
    @IBOutlet weak var txAddr2 : UITextField?
    @IBOutlet weak var txCity : UITextField?
    @IBOutlet weak var txState : UITextField?
    @IBOutlet weak var txPostCode : UITextField?
    @IBOutlet weak var txPhone : UITextField?
    @IBOutlet weak var txPhone2 : UITextField?
    
    var backData: (site:String, contractor:String, desc:String)
        = ("", "", "")
    var delegate: AddressDelegate?
    
    @IBAction func btnSaveClicked(sender: UIButton) {
        Session.surveyData?.s_addr1 = (txAddr1?.text)!
        Session.surveyData?.s_addr2 = (txAddr2?.text)!
        Session.surveyData?.s_city = (txCity?.text)!
        Session.surveyData?.s_state = (txState?.text)!
        Session.surveyData?.s_postalcode = (txPostCode?.text)!
        Session.surveyData?.s_phone = (txPhone?.text)!
        Session.surveyData?.s_phone2 = (txPhone2?.text)!
        
        self.delegate?.addressReturnedWith(backData: backData)
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func txFieldDidEndOnExit(sender:UITextField) {
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let s = Session.surveyData
        txAddr1?.text    = ((s?.s_addr1      != "NULL") ? s?.s_addr1      : "")
        txAddr2?.text    = ((s?.s_addr2      != "NULL") ? s?.s_addr2      : "")
        txCity?.text     = ((s?.s_city       != "NULL") ? s?.s_city       : "")
        txState?.text    = ((s?.s_state      != "NULL") ? s?.s_state      : "")
        txPostCode?.text = ((s?.s_postalcode != "NULL") ? s?.s_postalcode : "")
        txPhone?.text    = ((s?.s_phone      != "NULL") ? s?.s_phone      : "")
        txPhone2?.text   = ((s?.s_phone2     != "NULL") ? s?.s_phone2     : "")
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
