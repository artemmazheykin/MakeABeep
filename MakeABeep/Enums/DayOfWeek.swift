//
//  DaysOfWeek.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 29.08.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import Foundation

enum DayOfWeek{
    
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var nameOfADay: String{
        switch self{
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var isItWeekend: Bool{
        switch self{
        case .monday, .tuesday, .wednesday, .thursday, .friday: return false
        case .saturday, .sunday: return true
        }
    }
    
    var shortNames: String{
        switch self{
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    var dayNumber: Int{
        switch self{
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }
    
    init?(name: String){
        switch name {
        case "Понедельник": self = .monday
        case "Вторник": self = .tuesday
        case "Среда": self = .wednesday
        case "Четверг": self = .thursday
        case "Пятница": self = .friday
        case "Суббота": self = .saturday
        case "Воскресенье": self = .sunday
        default:
            return nil
        }
    }
}
