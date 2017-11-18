//
//  RuleRuleRepositoryImpl.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29/08/2017.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import Foundation
import PromiseKit

class RuleRepositoryImpl: NSObject, RuleRepository {
    
    let keyRules = "Rules"
    
    func setRulesToUserDefaults(rules: [RuleModel]) {
      
        
            let sortedRules = rules.sorted{
                $0.dateOfCreation < $1.dateOfCreation
            }
            var dictionaryRules = [[String:Any]]()
            
            for rule in sortedRules{
                dictionaryRules.append(rule.toDictionary())
            }
            
            UserDefaults.standard.setValue(dictionaryRules, forKey: keyRules)
        }

    func getRulesFromUserDefaults() -> [RuleModel] {
      
            var rules: [RuleModel] = []
            if let rulesFromUserDefaults = UserDefaults.standard.object(forKey: keyRules) as? [[String:Any]]{
                for rule in rulesFromUserDefaults{
                    if let rule = RuleModel(dictionary: rule){
                        rules.append(rule)
                    }
                }
                let sortedRules = rules.sorted{
                    $0.dateOfCreation < $1.dateOfCreation
                }
                
                return sortedRules
            }
            return []
        
    }
    

    func setRuleToUserDefaults(rule: RuleModel) {
        var rules = getRulesFromUserDefaults()
        
        var index = -1
        
        for (i,ruleFromUserDefaults) in rules.enumerated(){
            if ruleFromUserDefaults.dateOfCreation == rule.dateOfCreation{
                index = i
            }
        }
        if index != -1{
            rules[index] = rule
            setRulesToUserDefaults(rules: rules)
            return
        }
        rules.append(rule)
        setRulesToUserDefaults(rules: rules)
    }
    
}
