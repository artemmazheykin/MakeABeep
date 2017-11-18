//
//  RouterViewController.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import Foundation

@objc
enum RouterViewControllerType:Int {
    case navigationController, mainMenuViewController, newRuleViewController, timePickerViewController, periodAndSoundViewController, testViewController
    
    var identifier: String {
        
        switch self {
            
        case .navigationController:
            return "NavigationController"
            
        case .mainMenuViewController:
            return "MainMenuViewController"

        case .newRuleViewController:
            return "NewRuleViewController"

        case .timePickerViewController:
            return "TimePickerViewController"
            
        case .periodAndSoundViewController:
            return "PeriodAndSoundViewController"
            
        case .testViewController:
            return "TestViewController"
            
       }
    }
}

