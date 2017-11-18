//
//  NavigatorImpl.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import Foundation

class NavigatorImpl: NSObject, Navigator {
    
    var router: Router!
    
    func appDelegate(didFinishLaunchingWithOptions delegate: AppDelegate) {
        _ = router.presentViewController(type: .navigationController)
    }
    
    //    func viewController(didFinishLoadingDataFrom viewcontroller: ViewController) {
    //        _ = router.presentViewController(type: .viewController2)
    //    }
    //
    func mainMenuViewController(didAddRuleButtonTappedFrom viewcontroller: MainMenuViewController) {
        let newRuleViewController = router.pushViewController(type: .newRuleViewController) as! NewRuleViewController
        newRuleViewController.isItNewRule = true
    }
    
    func mainMenuViewController(didChangeRuleButtonTappedFrom viewcontroller: MainMenuViewController){
        let newRuleViewController = router.pushViewController(type: .newRuleViewController) as! NewRuleViewController
        newRuleViewController.isItNewRule = false
        newRuleViewController.ruleModel = viewcontroller.selectedRule
    }

    func newRuleViewController(didTimeButtonTappedFrom viewcontroller: NewRuleViewController){
        if let tag = viewcontroller.getTag{
            switch tag{
            case 1: let newViewcontroller = router.pushViewController(type: .timePickerViewController) as! TimePickerViewController
            if viewcontroller.lastTappedTimeButton.title(for: .normal) == "⏰"{
                newViewcontroller.initialTime = "08:00"}
            else{
                newViewcontroller.initialTime = viewcontroller.lastTappedTimeButton.title(for: .normal)
                }
            case 2: let newViewcontroller = router.pushViewController(type: .timePickerViewController) as! TimePickerViewController
            if viewcontroller.lastTappedTimeButton.title(for: .normal) == "⏰"{
                newViewcontroller.initialTime = "18:00"}
            else{
                newViewcontroller.initialTime = viewcontroller.lastTappedTimeButton.title(for: .normal)
                }
            default: _ = router.pushViewController(type: .timePickerViewController)
            }
        }
        
    }
    
    func newRuleViewController(didCreateRuleButtonTappedFrom viewcontroller: NewRuleViewController){
        
        let navigationController = viewcontroller.navigationController
        _ = viewcontroller.navigationController?.popViewController(animated: true)
        if let nextViewController = navigationController?.visibleViewController as? MainMenuViewController {
                nextViewController.rules = nextViewController.ruleService.getRulesFromUserDefaults()
                nextViewController.rulesTableView.reloadData()
        }
    }


    func newRuleViewController(didPeriodAndSoundCreationCellTappedFrom viewcontroller: NewRuleViewController){
        _ = router.pushViewController(type: .periodAndSoundViewController)
    }
    
    func newRuleViewController(didPeriodAndSoundCellTappedFrom viewcontroller: NewRuleViewController){
        let periodAndSoundViewController = router.pushViewController(type: .periodAndSoundViewController) as! PeriodAndSoundViewController
        periodAndSoundViewController.selectedBeep = viewcontroller.selectedBeep
    }
    
    func timePickerViewController(didCellTappedFrom viewcontroller: TimePickerViewController){
        
        let navigationController = viewcontroller.navigationController
        _ = viewcontroller.navigationController?.popViewController(animated: true)
        if let nextViewController = navigationController?.visibleViewController as? NewRuleViewController {
            
            nextViewController.selectedTime = viewcontroller.selectedTime
            nextViewController.placeTimeToButton()
            
        }
    }
    
    func periodAndSoundViewController(didOkTappedFrom viewcontroller: PeriodAndSoundViewController){
        let navigationController = viewcontroller.navigationController
        _ = viewcontroller.navigationController?.popViewController(animated: true)
        if let newRuleViewController = navigationController?.visibleViewController as? NewRuleViewController {
            
            if let selectedBeep = viewcontroller.selectedBeep{
                
                var beeps = newRuleViewController.createdBeeps
                var index = -1
                
                
                for (i,beepFromCreatedBeeps) in beeps.enumerated(){
                    if beepFromCreatedBeeps == selectedBeep{
                        index = i
                    }
                }
                if index != -1{
                    beeps[index] = BeepModel(nameOfTheSound: viewcontroller.selectedMusic!, period: viewcontroller.timer.date.toString(format: "HH:mm")!)
                    newRuleViewController.createdBeeps = beeps
                    newRuleViewController.ruleCreationTableView.reloadData()
                    newRuleViewController.checkingOfRuleCreation()
                    return
                }
            }
            
            newRuleViewController.createdBeeps.append(viewcontroller.beep!)
            newRuleViewController.insertRowsInTableView(indexPaths: [IndexPath(row: 2+newRuleViewController.createdBeeps.count, section: 0)])
            newRuleViewController.checkingOfRuleCreation()
        }

    }

    func timePickerViewController(didTestTappedFrom viewcontroller: TimePickerViewController){
        _ = router.pushViewController(type: .testViewController)
    }

}
