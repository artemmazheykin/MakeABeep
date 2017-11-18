//
//  RuleRuleRepository.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29/08/2017.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import Foundation
import PromiseKit

@objc
protocol RuleRepository {
    
    func setRulesToUserDefaults(rules: [RuleModel])
    func getRulesFromUserDefaults() -> [RuleModel]
    func setRuleToUserDefaults(rule: RuleModel)

}
