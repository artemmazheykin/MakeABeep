//
//  RuleRuleModel.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29/08/2017.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit

class RuleModel: NSObject {

    let days: [DayOfWeek]
    private var isActive: Bool = true
    let defaultName: String?
    let customName: String?
    let dateOfCreation: Date
    let beeps: [BeepModel]
    let fromTime: String
    let toTime: String

    
    func changeStatus(){
        isActive = !isActive
    }
    
    init (days: [DayOfWeek], customName: String, beeps: [BeepModel], fromTime: String, toTime: String, dateOfCreation: Date? = nil){
        var firstTime = true
        var name = ""
        
        if customName==""{
            self.customName = nil
            for day in days{
                if firstTime==true{
                    name += "\(day.shortNames)"
                    firstTime = false
                }
                else{
                    name += ", \(day.shortNames)"
                }
            }
            defaultName = name
        }
        else{
            defaultName = nil
            self.customName = customName
        }
        self.days = days
        self.beeps = beeps
        self.fromTime = fromTime
        self.toTime = toTime
        if let dateOfCr = dateOfCreation{
            self.dateOfCreation = dateOfCr
        }
        else{
            self.dateOfCreation = Date()
        }
    }
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        
        var daysString: [String] = []
        
        for day in days{
            daysString.append(day.nameOfADay)
        }
        
        dictionary["daysString"] = daysString
        dictionary["isActive"] = isActive
        dictionary["defaultName"] = defaultName
        dictionary["customName"] = customName
        dictionary["dateOfCreation"] = dateOfCreation
     
        var beeps = [[String:Any]]()
        for item in self.beeps{
            beeps.append(item.toDictionary())
        }
        dictionary["beeps"] = beeps
        
        dictionary["fromTime"] = fromTime
        dictionary["toTime"] = toTime

        return dictionary
    }
    
    init?(dictionary: [String:Any]){
        
        if let daysString = dictionary["daysString"] as? [String]{
            var days: [DayOfWeek] = []
            for dayString in daysString{
                days.append(DayOfWeek(name: dayString)!)
            }
            self.days = days
        }
        else{
            return nil
        }

        if let isActive = dictionary["isActive"] as? Bool{
            self.isActive = isActive
        }
        else{
            return nil
        }

        if let defaultName = dictionary["defaultName"] as? String{
            self.defaultName = defaultName
        }
        else{
            self.defaultName = nil
        }
        
        if let customName = dictionary["customName"] as? String{
            self.customName = customName
        }
        else{
            self.customName = nil
        }
        
        if let dateOfCreation = dictionary["dateOfCreation"] as? Date{
            self.dateOfCreation = dateOfCreation
        }
        else{
            return nil
        }
        
        var beeps: [BeepModel] = []
        
        if let beepsFromDictionary = dictionary["beeps"] as? [[String:Any]]{
            for beep in beepsFromDictionary{
                if let beepFromDictionary = BeepModel(dictionary: beep){
                    beeps.append(beepFromDictionary)
                }
            }
            self.beeps = beeps
        }
        else{
            return nil
        }
        
        if let fromTime = dictionary["fromTime"] as? String{
            self.fromTime = fromTime
        }
        else{
            return nil
        }

        if let toTime = dictionary["toTime"] as? String{
            self.toTime = toTime
        }
        else{
            return nil
        }

    }
    
    
}















