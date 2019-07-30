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
    
    @IBAction func stepperValueChanged(sender:UIStepper) {
        self.lbQuantity?.text = String(sender.value)
    }
    
    
    
    @IBAction func btnOrderClicked(sender:UIButton) {
        
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
