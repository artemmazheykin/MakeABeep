//
//  ERAssemblyProperties.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import Foundation
import Typhoon

// MARK: storyboard

extension Assembly {
    
    private func _mainStoryBoard() -> AnyObject {
        return TyphoonDefinition.withClass(TyphoonStoryboard.self) { definition in
            definition!.useInitializer(#selector(TyphoonStoryboard.init(name:factory:bundle:))) { initializer in
                initializer!.injectParameter(with: "Main")
                initializer!.injectParameter(with: self)
                initializer!.injectParameter(with: Bundle.main)
            }
            } as AnyObject
    }
    
    var mainStoryBoard: AnyObject {
        return _mainStoryBoard()
    }
}


// MARK: Navigator Property

extension Assembly {
    
    private func _navigator() -> AnyObject {
        return TyphoonDefinition.withClass(NavigatorImpl.self) { definition in
            definition!.scope = .lazySingleton
            definition!.useInitializer(#selector(NavigatorImpl.init))
            definition!.injectProperty(#selector(getter: NavigatorImpl.router), with: self.router)
            } as AnyObject
    }
    
    var navigator: AnyObject {
        return _navigator()
    }
}


// MARK: Router Property

extension Assembly {
    
    private func _router() -> AnyObject {
        return TyphoonDefinition.withClass(RouterImpl.self) { definition in
            definition!.scope = .lazySingleton
            definition!.useInitializer(#selector(RouterImpl.init))
            definition!.injectProperty(#selector(getter: RouterImpl.storyboard), with: self.mainStoryBoard)
            } as AnyObject
    }
    
    var router: AnyObject {
        return _router()
    }
}

extension Assembly {
    
   
    private func _ruleRepository() -> AnyObject {
        return TyphoonDefinition.withClass(RuleRepositoryImpl.self) { definition in
            definition!.scope = .lazySingleton
            definition!.useInitializer(#selector(RuleRepositoryImpl.init))
            } as AnyObject
    }
    
    var ruleRepository: AnyObject {
        return _ruleRepository()
    }
    
    private func _ruleService() -> AnyObject {
        return TyphoonDefinition.withClass(RuleServiceImpl.self) { definition in
            definition!.scope = .lazySingleton
            definition!.useInitializer(#selector(RuleServiceImpl.init))
            definition!.injectProperty(#selector(getter: RuleServiceImpl.ruleRepository), with: self.ruleRepository)
            } as AnyObject
    }
    
    var ruleService: AnyObject {
        return _ruleService()
    }
}










