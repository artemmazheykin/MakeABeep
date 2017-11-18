//
//  Navigator.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import UIKit

@objc
protocol Navigator {
    
    func appDelegate(didFinishLaunchingWithOptions delegate: AppDelegate)
    
//    func viewController(didFinishLoadingDataFrom viewcontroller: ViewController)
    
    func mainMenuViewController(didAddRuleButtonTappedFrom viewcontroller: MainMenuViewController)
    
    func mainMenuViewController(didChangeRuleButtonTappedFrom viewcontroller: MainMenuViewController)

    func newRuleViewController(didTimeButtonTappedFrom viewcontroller: NewRuleViewController)
    
    func newRuleViewController(didCreateRuleButtonTappedFrom viewcontroller: NewRuleViewController)
    
    func newRuleViewController(didPeriodAndSoundCreationCellTappedFrom viewcontroller: NewRuleViewController)

    func newRuleViewController(didPeriodAndSoundCellTappedFrom viewcontroller: NewRuleViewController)

    func periodAndSoundViewController(didOkTappedFrom viewcontroller: PeriodAndSoundViewController)
    
    func timePickerViewController(didCellTappedFrom viewcontroller: TimePickerViewController)
    
    func timePickerViewController(didTestTappedFrom viewcontroller: TimePickerViewController)

}

