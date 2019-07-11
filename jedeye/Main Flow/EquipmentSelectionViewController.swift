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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
