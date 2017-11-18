//
//  DaysPickerCell.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 10.09.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import PromiseKit

protocol DaysPickerCellDelegate{
    func didTappedTag(selectedTags: [String])
}

class DaysPickerCell: UITableViewCell {

//    var tags: TTGTextTagCollectionView!
    @IBOutlet weak var tagsView: TTGTextTagCollectionView!

    var ruleCreationDelegate: DaysPickerCellDelegate?
    var tagNamesOfDays = ["Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье","Будни","Выходные","Все дни"]


    override func awakeFromNib() {
        super.awakeFromNib()
        for tag in tagNamesOfDays{
            if tag == "Будни" || tag == "Все дни" || tag == "Выходные"{
                let config = TTGTextTagConfig()
                config.tagBackgroundColor = UIColor(red: 150/255, green: 103/255, blue: 158/255, alpha: 1.0)
                config.tagSelectedBackgroundColor = UIColor(red: 229/255, green: 184/255, blue: 42/255, alpha: 1.0)
                
                config.tagTextFont = UIFont(name: "Kohinoor Devanagari", size: 20)
                config.tagSelectedBorderWidth = 3
                config.tagSelectedBorderColor = UIColor(red: 62/255, green: 33/255, blue: 137/255, alpha: 1.0)
                tagsView.addTag(tag, with: config)
            }
            else{
                tagsView.addTag(tag)
            }
        }
        tagsView.alignment = .fillByExpandingWidth
        tagsView.delegate = self
//        tagsView.addSubview(tags)
//        DispatchQueue.main.async {
//            self.tags.frame.size.width = self.tagsView.frame.size.width
//            self.tags.addTag("\(self.tags.contentSize.height)")
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func deselectAllTags(){
        for (i,_) in tagsView.allTags().enumerated(){
            tagsView.setTagAt(UInt(i), selected: false)
        }
    }
    
    func selectTagAllDays(selected: Bool){
        deselectAllTags()
        for (i,tag) in tagsView.allTags().enumerated(){
            switch tag {
            case "Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье","Все дни":
                tagsView.setTagAt(UInt(i), selected: selected)
            default:
                break
            }
        }
    }
    
    func unselectSpecialTags(tags: [String]){
        deselectAllTags()
        for (i,tag) in self.tagsView.allTags().enumerated(){
            if tags.contains(tag){
                self.tagsView.setTagAt(UInt(i), selected: true)
            }
        }
    }
    
    func selectTagWorkdays(selected: Bool){
        deselectAllTags()
        for (i,tag) in tagsView.allTags().enumerated(){
            switch tag {
            case "Понедельник","Вторник","Среда","Четверг","Пятница","Будни":
                tagsView.setTagAt(UInt(i), selected: selected)
            default:
                break
            }
        }
    }
    
    func selectTagWeekends(selected: Bool){
        deselectAllTags()
        for (i,tag) in tagsView.allTags().enumerated(){
            switch tag {
            case "Суббота","Воскресенье","Выходные":
                tagsView.setTagAt(UInt(i), selected: selected)
            default:
                break
            }
        }
    }
    
    func selectTagDay(){
        if let selectedTags = tagsView.allSelectedTags(){
            
            var resultTags = selectedTags
            
            for (i,tag) in tagsView.allSelectedTags().enumerated(){
                switch tag {
                case "Все дни","Будни","Выходные":
                    resultTags.remove(at: i)
                default:
                    break
                }
            }
            var resultTag = ""
            for tag in resultTags{
                resultTag += tag
            }
            switch resultTag {
            case "ПонедельникВторникСредаЧетвергПятницаСубботаВоскресенье":
                return selectTagAllDays(selected: true)
            case "ПонедельникВторникСредаЧетвергПятница":
                return selectTagWorkdays(selected: true)
            case "СубботаВоскресенье":
                return selectTagWeekends(selected: true)
            default:
                return unselectSpecialTags(tags: resultTags)
            }
        }

    }
}

extension DaysPickerCell: TTGTextTagCollectionViewDelegate{
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool) {
        
        switch tagText {
        case "Все дни":
            selectTagAllDays(selected: selected)
        case "Будни":
            selectTagWorkdays(selected: selected)
        case "Выходные":
            selectTagWeekends(selected: selected)
        case "Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье":
            selectTagDay()
        default:
            break
        }
        
        var selectedDays: [String] = []
        
        for day in tagsView.allSelectedTags(){
            switch day{
            case "Все дни", "Будни", "Выходные":
            continue
            default: selectedDays.append(day)
            }
        }
        ruleCreationDelegate?.didTappedTag(selectedTags: selectedDays)
    }
}

