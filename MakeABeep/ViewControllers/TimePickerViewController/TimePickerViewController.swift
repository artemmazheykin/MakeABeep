//
//  TimePickerViewController.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 21.10.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit

extension UILabel {
    
    func startBlink() {
        
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.autoreverse, .repeat],
                       animations: {
                        self.alpha = 0
        }, completion: nil)
    }
    
    func stopBlink() {
        alpha = 1
        layer.removeAllAnimations()
    }
}

class TimePickerViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var blinkingColon: UILabel!
    var selectedTime: String!
    var initialTime: String!
    var navigator: Navigator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blinkingColon.startBlink()
        timePicker.date = initialTime.toDate(format: "HH:mm")!
        selectedTime = timePicker.date.toString(format: "HH:mm")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTappedOkButton(_ sender: UIButton) {
        selectedTime = timePicker.date.toString(format: "HH:mm")
        
//        navigator.timePickerViewController(didCellTappedFrom: self)
        navigator.timePickerViewController(didCellTappedFrom: self)
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


extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
    
    func extractYearMonthDay() -> (year: Int, month: Int, day: Int)?{
        
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.day,.month,.year], from: self)
        if let day = dateComponent.day, let month = dateComponent.month, let year = dateComponent.year{
            return (year: year, month: month, day: day)
        }
        
        
        return nil
    }
}

