//
//  EventOfTheDayModel.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 03.09.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import Foundation

class DayWithEventsModel: NSObject{
    
    let nameOfTheDay: DayOfWeek
    let beeps: BeepModel
    
    init (nameOfTheDay: DayOfWeek, beeps: BeepModel){
        self.nameOfTheDay = nameOfTheDay
        self.beeps = beeps
    }
    
    
}
