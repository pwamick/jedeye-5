//
//  LoginViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/23/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AsynchDataDelegate {
    
    let defaults = UserDefaults.standard
    
    var validationSuccessful : Bool = false
    
    @IBOutlet weak var lbCaption : UILabel?
    @IBOutlet weak var lbPrompt : UILabel?
    @IBOutlet weak var txUserID : UITextField?
    @IBOutlet weak var txPWD : UITextField?
    @IBOutlet weak var lbError : UILabel?
    @IBOutlet weak var bbtnLock : UIBarButtonItem?
    @IBOutlet weak var btnLogin : UIButton?
    
    @IBAction func userTappedTextField(sender: UITextField) {
        sender.text = ""
        self.lbError!.isHidden = true
    }
    
    @IBAction func attemptLogin(sender : UIButton) {
        
        if (loginSuccessful(uid: txUserID!.text!, pwd: txPWD!.text!)) {
            Session.user = txUserID?.text
            Session.setDeviceID()
            Session.userInDB(user: txUserID!.text!,
                             reftype: "username",
                             password: txPWD!.text!)
            self.txUserID?.resignFirstResponder()
            self.txPWD?.resignFirstResponder()
        }
    }
    
    @IBAction func toggleCredentialLock(sender : UIBarButtonItem) {
        if sender.title! == "Lock" {
            sender.title = "Locked"
            defaults.set(true, forKey: "locked")
            defaults.set(self.txUserID!.text, forKey: "uid")
            defaults.set(self.txPWD!.text, forKey: "pwd")
        } else {
            sender.title = "Lock"
            defaults.set(false, forKey: "locked")
            defaults.removeObject(forKey: "uid")
            defaults.removeObject(forKey: "pwd")
            self.txUserID!.text = ""
            self.txPWD!.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //this also creates Session.surveyData
        Session.obtainAppSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Welcome"
        self.lbPrompt?.text = "Sign In"
        self.txUserID!.text = ""
        self.txPWD!.text = ""
        if (defaults.bool(forKey: "locked")) {
            self.bbtnLock!.title = "Locked"
            self.txUserID!.text = defaults.string(forKey: "uid")
            self.txPWD!.text = defaults.string(forKey: "pwd")
        }
        Session.delegate = self
        
        self.lbError?.isHidden = true
    }
    
    func appSettingsObtained(settings: [String : String]) {
        Session.appSettings = settings
        
        //get the gps information into Session.surveyData.gps
        Session.surveyData?.getgps()
        
        DispatchQueue.main.async{
            self.lbCaption?.text = Session.appSettings!["Logo Caption"]
            self.btnLogin?.isEnabled = true
        }
        //print("&&Login: AppSettings = \(Session.appSettings!)")
    }
    
    func loginReturnedWith(data: [String : String]) {
        if (data["retkey"] != "0") {
            self.validationSuccessful = true
            Session.usertkey = data["retkey"]!
            _ = data["retcode"]
            let retmsg = data["retmsg"]
            Session.numSurveysForUser = self.parseMessageAsInt(retmsg!)
    
            Session.obtainSurveyID()
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoginAttemptSegue", sender: self)
            }
        } else {
            DispatchQueue.main.async {
                self.lbError!.text = "User \(self.txUserID!.text!) not found"
                self.lbError!.isHidden = false
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func loginSuccessful(uid:String, pwd:String) -> Bool {
        var retVal = false
        //validate both fields contain text:
        if (notEmpty(self.txUserID!) && notEmpty(self.txPWD!)) {
            retVal = true
        }
        
        // TODO: validate against employees table
        
        return retVal
    }
    
    func notEmpty(_ v:UITextField) -> Bool {
        var retVal = true
        if (v.text!.isEmpty) {
            shakeView(v)
            retVal = false
        }
        return retVal
    }

    func shakeView(_ v:UIView) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.12
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fromValue = NSValue(cgPoint: CGPoint(x: v.center.x - 7, y: v.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: v.center.x + 7, y: v.center.y))
        v.layer.add(animation, forKey: nil)
         
    }
    
    func parseMessageAsInt(_ message: String) -> Int? {
        let arrMsg = message.components(separatedBy: ":")
        return Int(arrMsg[1])
    }
    
}
