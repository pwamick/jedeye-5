//
//  SurveyStateTBController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/30/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class SurveyStateTBController: UITabBarController {
    
    let C_LOAD = 1
    let C_ADHOC = 0
    //let C_PROJECT = 1

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        if Session.numSurveysForUser! > 0 {
            let arrItems = self.tabBar.items as [UITabBarItem]?
            let loadItem = arrItems![C_LOAD]
            loadItem.badgeValue = String(Session.numSurveysForUser!)
        }
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
