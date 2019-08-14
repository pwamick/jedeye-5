//
//  EquipmentCell.swift
//  jedeye
//
//  Created by Rick Campbell on 7/24/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {
    
    @IBOutlet weak var lbManufacturer : UILabel?
    @IBOutlet weak var lbModel : UILabel?
    @IBOutlet weak var lbQuantity : UILabel?
    @IBOutlet weak var lbNotes: UILabel?
    
    var pdfPath : String = ""
    var inventoryid : String = ""
    var delegate : ConfirmDelegate?
    
    @IBAction func stepperValueChanged(sender:UIStepper) {
        //stepper values are floats, convert to Int before String:
        self.lbQuantity?.text = String(Int(sender.value))
    }
    
    @IBAction func btnOrderClicked(sender:UIButton) {
        // Delegate back to the ViewController for this:
        delegate?.orderConfirmed(sender: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lbQuantity?.text = "0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
