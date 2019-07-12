//
//  EquipmentSelectionViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/21/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class EquipmentSelectionViewController: UIViewController {
    
    var promptText : String?
    @IBOutlet weak var prompt : UILabel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Equipment"
    }
    
}
