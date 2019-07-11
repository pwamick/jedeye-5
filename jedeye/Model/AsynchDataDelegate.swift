//
//  AsynchData.swift
//  jedeye
//
//  Created by Rick Campbell on 5/13/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import Foundation

protocol AsynchDataDelegate {
    
    func sessionReturnedWith(data: [String:[String:String]])
    func subtypeTVCReturnedWith(data: [String:[String:String]])
    func loginReturnedWith(data: [String:String])
    func surveyIDReturnedWith(data: [String:String])
    func surveyTypeReturnedWith(data: [String:String])
    
    func singlePairSetWithResponse(data: String)
    func multiPairSetWithResponse(data: String)
    func surveyListReturnedWith(data: EntryType)
    func appSettingsObtained(settings: [String:String])
    func surveySaved(data:[String:String])
    func kvpairsfetched(data: [String:String])
}

extension AsynchDataDelegate {
    func sessionReturnedWith(data: [String:[String:String]]) {}
    func subtypeTVCReturnedWith(data: [String:[String:String]]) {}
    func loginReturnedWith(data: [String:String]) {}
    
    func surveyIDReturnedWith(data: [String:String]) {}
    
    func surveyTypeReturnedWith(data: [String:String]) {}
    
    func singlePairSetWithResponse(data: String) {}
    func multiPairSetWithResponse(data: String) {}
    func surveyListReturnedWith(data: EntryType) {}
    func appSettingsObtained(settings: [String:String]) {}
    func surveySaved(data:[String:String]) {}
    func kvpairsfetched(data: [String:String]) {}
}

