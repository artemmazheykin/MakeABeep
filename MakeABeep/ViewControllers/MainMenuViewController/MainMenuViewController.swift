//
//  ViewController.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29.08.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    var navigator: Navigator!
    var ruleService: RuleService!
    @IBOutlet weak var rulesTableView: UITableView!
    var rules: [RuleModel] = []
    var selectedRule: RuleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rules = ruleService.getRulesFromUserDefaults()
        
        rulesTableView.delegate = self
        rulesTableView.dataSource = self
        rulesTableView.tableFooterView = UIView()
        rulesTableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTappedAddRuleButton(_ sender: UIBarButtonItem) {
        navigator.mainMenuViewController(didAddRuleButtonTappedFrom: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension MainMenuViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = rulesTableView.cellForRow(at: indexPath) as? CreateRuleCell{
            navigator.mainMenuViewController(didAddRuleButtonTappedFrom: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if let _ = rulesTableView.cellForRow(at: indexPath) as? RuleCell{
            selectedRule = rules[indexPath.row]
            navigator.mainMenuViewController(didChangeRuleButtonTappedFrom: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if rules.count == 0{
            return false
        }
        else{
            return true
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            rules.remove(at: indexPath.row)
            if rules.count == 0{
                tableView.reloadRows(at: [indexPath], with: .automatic)
                ruleService.setRulesToUserDefaults(rules: rules)
                return
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            ruleService.setRulesToUserDefaults(rules: rules)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Cтереть"
    }

}

extension MainMenuViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rules.count == 0 ? 1 : rules.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if rules.count == 0{
            let cell = rulesTableView.dequeueReusableCell(withIdentifier: "CreateRuleCell") as! CreateRuleCell
            cell.createRuleLabel.text = "Создайте новое правило..."
            return cell
        }
        else{
            let cell = rulesTableView.dequeueReusableCell(withIdentifier: "RuleCell") as! RuleCell
            if let customName = rules[indexPath.row].customName{
                cell.ruleDesignation.text = customName
            }
            else if let defaultName = rules[indexPath.row].defaultName{
                cell.ruleDesignation.text = defaultName
            }
            return cell
        }
    }
}
