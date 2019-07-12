//
//  CarpenterMeasureViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 7/9/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit


class CarpenterMeasureViewController: UIViewController {
    
    @IBOutlet weak var txFeet: UITextField?
    @IBOutlet weak var txInches: UITextField?
    @IBOutlet weak var txNumerator: UITextField?
    @IBOutlet weak var txDenominator: UITextField?
    
    var delegate: CarpenterDelegate?
    var backID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnSaveClicked(sender: UIButton) {
        if self.txFeet!.text! != "" && self.txInches!.text != "" {
            if self.txNumerator!.text! != "" &&
                self.txDenominator!.text != "" &&
                Int(self.txDenominator!.text!) != 0 {
                self.delegate?.DecimalMeasureReady(withMeasure: carp2dec(
                    feet: self.txFeet!.text!,
                    inches: self.txInches!.text!,
                    fracNum: self.txNumerator!.text!,
                    fracDen: self.txDenominator!.text!
                ), BackID: self.backID!)
            } else {
                self.delegate?.DecimalMeasureReady(withMeasure: carp2dec(
                    feet: self.txFeet!.text!,
                    inches: self.txInches!.text!
                ), BackID: self.backID!)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func carp2dec(feet: String, inches:String,
                  fracNum:String = "0", fracDen:String = "2") -> Double {
        let f = Double(feet)!
        let i = Double(inches)!
        let num = Double(fracNum)!
        let den = Double(fracDen)!
        let p:Double = num / den
        return f + i/12 + p/12
    }
    
}
