//
//  RuleRuleServiceImpl.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29/08/2017.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import Foundation
import PromiseKit

class RuleServiceImpl: NSObject, RuleService {

    var ruleRepository: RuleRepository!
    
    func setRulesToUserDefaults(rules: [RuleModel]){
        return ruleRepository.setRulesToUserDefaults(rules: rules)
    }
    
    func getRulesFromUserDefaults() -> [RuleModel]{
        return ruleRepository.getRulesFromUserDefaults()
    }
    
    func setRuleToUserDefaults(rule: RuleModel){
        return ruleRepository.setRuleToUserDefaults(rule: rule)
    }


}
