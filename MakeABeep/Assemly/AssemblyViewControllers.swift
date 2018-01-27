//
//  AssemblyViewControllers.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import Foundation
import Typhoon

// MARK: ViewController

extension Assembly {
    
    @objc public dynamic func _mainMenuViewController() -> AnyObject {
        return TyphoonDefinition.withClass(MainMenuViewController.self) { definition in
            definition!.injectProperty(#selector(getter: MainMenuViewController.navigator), with: self.navigator)
            definition!.injectProperty(#selector(getter: MainMenuViewController.ruleService), with: self.ruleService)
            } as AnyObject
    }
    
    @objc public dynamic func _newRuleViewController() -> AnyObject {
        return TyphoonDefinition.withClass(NewRuleViewController.self) { definition in
            definition!.injectProperty(#selector(getter: NewRuleViewController.navigator), with: self.navigator)
            definition!.injectProperty(#selector(getter: NewRuleViewController.ruleService), with: self.ruleService)
            } as AnyObject
    }

    @objc public dynamic func _timePickerViewController() -> AnyObject {
        return TyphoonDefinition.withClass(TimePickerViewController.self) { definition in
            definition!.injectProperty(#selector(getter: TimePickerViewController.navigator), with: self.navigator)
            //            definition!.injectProperty(#selector(getter: MainMenuViewController.imagesService), with: self.imagesService)
            } as AnyObject
    }

    @objc public dynamic func _periodAndSoundViewController() -> AnyObject {
        return TyphoonDefinition.withClass(PeriodAndSoundViewController.self) { definition in
            definition!.injectProperty(#selector(getter: PeriodAndSoundViewController.navigator), with: self.navigator)
            //            definition!.injectProperty(#selector(getter: MainMenuViewController.imagesService), with: self.imagesService)
            } as AnyObject
    }

//    func _viewController2() -> AnyObject {
//        return TyphoonDefinition.withClass(ViewController2.self) { definition in
//            definition!.injectProperty(#selector(getter: ViewController2.navigator), with: self.navigator)
//            definition!.injectProperty(#selector(getter: ViewController2.dataService), with: self.dataService)
//            } as AnyObject
//    }
//
//    func _thirdViewController() -> AnyObject {
//        return TyphoonDefinition.withClass(ThirdViewController.self) { definition in
//            definition!.injectProperty(#selector(getter: ThirdViewController.navigator), with: self.navigator)
//            definition!.injectProperty(#selector(getter: ThirdViewController.dataService), with: self.dataService)
//            } as AnyObject
//    }

    
}
