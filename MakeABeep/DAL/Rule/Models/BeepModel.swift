//
//  BeepModel.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 03.09.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import Foundation

class BeepModel: NSObject{
    
    let nameOfTheSound: String
    let period: String
    
    init(nameOfTheSound: String, period: String){
        self.nameOfTheSound = nameOfTheSound
        self.period = period
    }
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        dictionary["nameOfTheSound"] = nameOfTheSound
        dictionary["period"] = period
        
        return dictionary
    }
    
    init? (dictionary: [String:Any]){
        
        
        if let nameOfTheSound = dictionary["nameOfTheSound"] as? String{
            self.nameOfTheSound = nameOfTheSound
        }
        else {
            return nil
        }
        
        if let period = dictionary["period"] as? String{
            self.period = period
        }
        else {
            return nil
        }
        
    }


    
}
