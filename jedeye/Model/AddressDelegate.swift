//
//  AddressDelegate.swift
//  jedeye
//
//  Created by Rick Campbell on 7/11/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

protocol AddressDelegate {
    func addressReturnedWith(backData:(site:String, contractor:String, desc:String))
}
