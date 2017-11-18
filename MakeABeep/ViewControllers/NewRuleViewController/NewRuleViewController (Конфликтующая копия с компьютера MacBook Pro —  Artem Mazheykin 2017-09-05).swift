//
//  NewRuleViewController.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 29.08.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit
import TTGTagCollectionView


class NewRuleViewController: UIViewController {

    @IBOutlet weak var tagsView: UIView!
    var tagNamesOfDays = ["Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье","Будни","Выходные","Все дни"]
    var tags: TTGTextTagCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tags = TTGTextTagCollectionView(frame: CGRect(x: 0, y: 0, width: tagsView.frame.width, height: tagsView.frame.height))
        for tag in tagNamesOfDays{
            if tag == "Будни" || tag == "Все дни" || tag == "Выходные"{
                let config = TTGTextTagConfig()
                config.tagBackgroundColor = UIColor(red: 150/255, green: 103/255, blue: 158/255, alpha: 1.0)
                config.tagSelectedBackgroundColor = UIColor(red: 229/255, green: 184/255, blue: 42/255, alpha: 1.0)

                config.tagTextFont = UIFont(name: "Kohinoor Devanagari", size: 20)
                tags.addTag(tag, with: config)
            }
            else{
                tags.addTag(tag)
            }
        }
        tags.alignment = .fillByExpandingWidth
        tags.delegate = self
        tagsView.addSubview(tags)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tags.frame.size = tagsView.frame.size
    }
    
    func deselectAllTags(){
        for (i,_) in tags.allTags().enumerated(){
            tags.setTagAt(UInt(i), selected: false)
        }
    }
    func selectTagAllDays(selected: Bool){
        deselectAllTags()
        for (i,tag) in tags.allTags().enumerated(){
            switch tag {
            case "Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье","Все дни":
                selected==true ? tags.setTagAt(UInt(i), selected: true) : tags.setTagAt(UInt(i), selected: false)
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
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

extension NewRuleViewController: TTGTextTagCollectionViewDelegate{
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool) {
        switch tagText {
        case "Все дни":
            selectTagAllDays(selected: selected)
        default:
            break
        }
        print(tags.allSelectedTags())
    }
}
