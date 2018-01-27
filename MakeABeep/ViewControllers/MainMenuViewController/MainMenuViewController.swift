//
//  ViewController.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29.08.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI


class MainMenuViewController: UIViewController {

    @objc var navigator: Navigator!
    @objc var ruleService: RuleService!
    @IBOutlet weak var rulesTableView: UITableView!
    var rules: [RuleModel] = []
    var selectedRule: RuleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        do{
//        try Auth.auth().signOut()
//        }
//        catch{
//            print("!!!!!!!error")
//        }
        
        if Auth.auth().currentUser == nil {
            let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
            self.present(authViewController, animated: true)
        }
        else{
            print("!!!!!!!Auth.auth().app?.name = \(Auth.auth().app?.name)")
            print("!!!!Auth.auth().currentUser?.displayName = \(Auth.auth().currentUser?.displayName)")
        }
        
//        Auth.auth().addStateDidChangeListener() { auth, user in
//            // 2
//            if user == nil {
//                // 3
//                let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
//                self.present(authViewController, animated: true)
//            }
//        }
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
