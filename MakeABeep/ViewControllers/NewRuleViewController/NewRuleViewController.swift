//
//  NewRuleViewController.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29.08.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import UserNotifications


class NewRuleViewController: UIViewController, DaysPickerCellDelegate {
    
    @IBOutlet weak var ruleCreationTableView: UITableView!
    @IBOutlet weak var nameOfTheRuleTextField: UITextField!
    
    @objc var navigator: Navigator!
    @objc var ruleService: RuleService!
    var lastTappedTimeButton: UIButton!
    var selectedTime: String!
    var isItNewRule: Bool!
    var ruleModel: RuleModel?
    var createdBeeps: [BeepModel] = []
    @IBOutlet weak var creationRuleButton: UIButton!
    var timeOnTOButton: String!
    var timeOnFROMButton: String!
    var selectedDays: [String] = []
    var selectedBeep: BeepModel?
    var isGrantedNotificationAccess = false

    var getTag: Int?{
        return lastTappedTimeButton.tag
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        creationRuleButton.isEnabled = false
        creationRuleButton.setTitleColor(.gray, for: .disabled)
        print(createdBeeps.count)
        ruleCreationTableView.delegate = self
        ruleCreationTableView.dataSource = self
        ruleCreationTableView.tableFooterView = UIView()
        ruleCreationTableView.separatorStyle = .none
        ruleCreationTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,_) in
                self.isGrantedNotificationAccess = granted
        }
        )

        if let selectedRule = ruleModel{
            createdBeeps = selectedRule.beeps
            nameOfTheRuleTextField.text = selectedRule.customName
            let days = selectedRule.days
            var daysString: [String] = []
            for day in days{
                daysString.append(day.nameOfADay)
            }
            selectedDays = daysString
            creationRuleButton.setTitle("Изменить правило", for: .normal)
        }
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: nameOfTheRuleTextField, action: #selector(resignFirstResponder))
//        ruleCreationTableView.addGestureRecognizer(tap)
        
//        DispatchQueue.global(qos: .background).async {
//            sleep(2)
//            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
//                print("settings.authorizationStatus = \(settings.authorizationStatus)")
//            })
//        }
        
    }
    
//    @IBAction func sendNotification(_ sender: UIButton) {
//
//        if sender.tag == 1{
//            if isGrantedNotificationAccess{
//                //add notification code here
//
//                //Set the content of the notification
//
//                localNotificationIdentifier = "\(selectedTime.timeIntervalSince1970)"
//
//                let content = UNMutableNotificationContent()
//                content.title = "Время кушать!"
//                content.subtitle = "\(babyName!)"
//                content.body = "хочет подкрепиться"
//                content.sound = UNNotificationSound(named: "tickle.mp3")
//
//
//                //let date = "20.05.2017T15:12:30"
//
//                //Set the trigger of the notification -- here a timer.
//
//                let dateComponents = selectedTime.toDateComponents()
//
//                if checkButton.isChecked{
//
//                    let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//                    //Set the request for the notification from the above
//                    let request = UNNotificationRequest(
//                        identifier: localNotificationIdentifier! + "repeat\(repeatTime!)",
//                        content: content,
//                        trigger: trigger2
//                    )
//                    UNUserNotificationCenter.current().add(
//                        request, withCompletionHandler: nil)
//
//                    weightBefore = 0
//                    weightAfter = 0
//
//                    navigator.currentMealViewController(didCreateButtonTappedFrom: self)
//
//                }
//                else{
//                    let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//                    //Set the request for the notification from the above
//                    let request = UNNotificationRequest(
//                        identifier: localNotificationIdentifier!,
//                        content: content,
//                        trigger: trigger2
//                    )
//                    UNUserNotificationCenter.current().add(
//                        request, withCompletionHandler: nil)
//
//                    weightBefore = 0
//                    weightAfter = 0
//
//                    navigator.currentMealViewController(didCreateButtonTappedFrom: self)
//
//                }
//
//
//
//            }
//        }
//    }
    
    func insertRowsInTableView(indexPaths: [IndexPath]){
        ruleCreationTableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func reloadDataInTableView(){
        ruleCreationTableView.reloadData()
    }

    func didTappedTag(selectedTags: [String]) {
        print(selectedTags)
        nameOfTheRuleTextField.resignFirstResponder()
        self.selectedDays = selectedTags
        checkingOfRuleCreation()
    }

    func checkingOfRuleCreation(){
        if selectedDays.count != 0, timeOnFROMButton != nil, timeOnTOButton != nil, createdBeeps.count != 0{
            creationRuleButton.isEnabled = true
        }
        else{
            creationRuleButton.isEnabled = false
        }
    }
    
    func placeTimeToButton(){
        let cell = ruleCreationTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TimePickerCell
        if selectedTime != nil{
            switch lastTappedTimeButton{
            case cell.fromTimeButton:
                cell.fromTimeButton.setTitle(selectedTime, for: .normal)
                timeOnFROMButton = selectedTime
                checkingOfRuleCreation()
            case cell.toTimeButton:
                cell.toTimeButton.setTitle(selectedTime, for: .normal)
                timeOnTOButton = selectedTime
                checkingOfRuleCreation()
            default: break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createRule() -> RuleModel{
        
        var days: [DayOfWeek] = []
        for day in selectedDays{
            days.append(DayOfWeek(name: day)!)
        }
        if !isItNewRule{
            let rule = RuleModel(days: days, customName: nameOfTheRuleTextField.text!, beeps: createdBeeps, fromTime: timeOnFROMButton, toTime: timeOnTOButton, dateOfCreation: ruleModel!.dateOfCreation)
            return rule
        }
        else{
            let rule = RuleModel(days: days, customName: nameOfTheRuleTextField.text!, beeps: createdBeeps, fromTime: timeOnFROMButton, toTime: timeOnTOButton)
            return rule
        }
    }
    
    
    @IBAction func didTappedCreateRuleButton(_ sender: UIButton) {
        
        ruleModel = createRule()
        if let rule = ruleModel{
            
            
            if isGrantedNotificationAccess{
                //add notification code here

                //Set the content of the notification
                for (numberOfBeep,beep) in rule.beeps.enumerated(){

                    let content = UNMutableNotificationContent()
                    content.title = "MakeABeep!"
                    content.subtitle = "\(rule.customName == nil ? rule.defaultName! : rule.customName!)"
                    content.body = "каждые \(beep.period)"
                    content.sound = UNNotificationSound(named: "\(beep.nameOfTheSound).mp3")

                    let datePeriod = beep.period.toDate(format: "HH:mm")!

                    let dateInterval = DateInterval(start: "00:00".toDate(format: "HH:mm")!, end: datePeriod)
                    let duration = dateInterval.duration
                    let di = duration + duration


//                    let trigger2 = UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: false)
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: true)
                    let request = UNNotificationRequest(identifier: "\(content.subtitle) beep: \(numberOfBeep)", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(
                        request, withCompletionHandler: nil)

                }
            }
            
            ruleService.setRuleToUserDefaults(rule: ruleModel!)
            navigator.newRuleViewController(didCreateRuleButtonTappedFrom: self)
        }
    }
    
    
    @IBAction func nameIsChanging(_ sender: UITextField) {
        
        if sender.text?.count == 1{
            let firstLetter = sender.text?.uppercased()
            sender.text = firstLetter
        }
        checkingOfRuleCreation()
    }
    
    /*
     // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
}

extension NewRuleViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row==0{
            let cell = ruleCreationTableView.dequeueReusableCell(withIdentifier: "DaysPickerCell") as! DaysPickerCell
            let screenSize = UIScreen.main.bounds.width
            var height = cell.tagsView.contentSize.height + 16
            switch screenSize{
            case 414:
                height = 137 + 16
            case 320:
                height = 179 + 16
            default: break
            }
            
            
            return height
        }
        else if indexPath.row==2{
        return 58
        }
        else{
            return 40
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 2:
            navigator.newRuleViewController(didPeriodAndSoundCreationCellTappedFrom: self)
            tableView.deselectRow(at: indexPath, animated: true)
        case 3...Int.max:
            selectedBeep = createdBeeps[indexPath.row-3]
            navigator.newRuleViewController(didPeriodAndSoundCellTappedFrom: self)
            tableView.deselectRow(at: indexPath, animated: true)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row>=3{
            return true
        }
        else{
            return false
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            if indexPath.row >= 3{
                createdBeeps.remove(at: indexPath.row-3)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                checkingOfRuleCreation()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Cтереть"
    }
}

extension NewRuleViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + createdBeeps.count
    }
    
    @objc func timeButtonDidTapped(sender: UIButton){
        lastTappedTimeButton = sender
        navigator.newRuleViewController(didTimeButtonTappedFrom: self)
    }

 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = ruleCreationTableView.dequeueReusableCell(withIdentifier: "DaysPickerCell") as! DaysPickerCell
            cell.ruleCreationDelegate = self
            if let selectedRule = ruleModel{
                
                let days = selectedRule.days
                var daysString: [String] = []
                for day in days{
                    daysString.append(day.nameOfADay)
                }
                
                for (i,tag) in cell.tagsView.allTags().enumerated(){
                    if daysString.contains(tag){
                        cell.tagsView.setTagAt(UInt(i), selected: true)
                    }
                }
                cell.selectTagDay()
            }
            
            return cell
        case 1:
            let cell = ruleCreationTableView.dequeueReusableCell(withIdentifier: "TimePickerCell") as! TimePickerCell
            cell.fromTimeButton.addTarget(self, action: #selector(timeButtonDidTapped(sender:)), for: .touchUpInside)
            cell.toTimeButton.addTarget(self, action: #selector(timeButtonDidTapped(sender:)), for: .touchUpInside)
            if let selectedRule = ruleModel{
                cell.fromTimeButton.setTitle(selectedRule.fromTime, for: .normal)
                timeOnFROMButton = selectedRule.fromTime
                cell.toTimeButton.setTitle(selectedRule.toTime, for: .normal)
                timeOnTOButton = selectedRule.toTime
            }
            return cell
            
        case 2:
            let cell = ruleCreationTableView.dequeueReusableCell(withIdentifier: "PeriodAndSoundCreationCell") as! PeriodAndSoundCreationCell
            return cell
            
        default:
            let cell = ruleCreationTableView.dequeueReusableCell(withIdentifier: "PeriodAndSoundCell") as! PeriodAndSoundCell
            cell.period.text = createdBeeps[indexPath.row-3].period
            cell.sound.text = createdBeeps[indexPath.row-3].nameOfTheSound
            return cell
        }
    }
}


