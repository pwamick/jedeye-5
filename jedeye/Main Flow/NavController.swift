//
//  NavController.swift
//  jedeye
//
//  Created by Rick Campbell on 2/27/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class NavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bbtnWorkOrderNo = UIBarButtonItem(title: "No Survey Number", style: .plain, target: self, action: nil)
        bbtnWorkOrderNo.isEnabled = false
        bbtnWorkOrderNo.tintColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        self.toolbarItems?.append(bbtnWorkOrderNo)
    }

}
