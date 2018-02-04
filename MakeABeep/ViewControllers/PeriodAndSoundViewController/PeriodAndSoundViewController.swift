//
//  PeriodAndSoundViewController.swift
//  MakeABeep
//
//  Created by  Artem Mazheykin on 24.10.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import AudioToolbox
import AVFoundation

class PeriodAndSoundViewController: UIViewController {
    
    var player : AVAudioPlayer?
    @IBOutlet weak var timer: UIDatePicker!
    @IBOutlet weak var musicTags: TTGTextTagCollectionView!
    
    var musicTagsConstraints: [NSLayoutConstraint] = []

    var tagNamesOfMusic = ["bell_ring","bird_peewee","bird_pigeon","bell_school"]
    var selectedMusic: String?
    var selectedPeriod: String!
    var beep: BeepModel?
    @objc var navigator: Navigator!
    var selectedBeep: BeepModel?
    var selectedHour: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        for tag in tagNamesOfMusic{
                 musicTags.addTag(tag)
        }
        musicTags.alignment = .fillByExpandingWidth
        musicTags.delegate = self
        timer.date = "01:00".toDate(format: "HH:mm")!
        
        if let beep = selectedBeep{
            timer.date = beep.period.toDate(format: "HH:mm")!
            for (i,tag) in tagNamesOfMusic.enumerated(){
                if tag == beep.nameOfTheSound{
                    musicTags.setTagAt(UInt(i), selected: true)
                }
            }
            selectedMusic = beep.nameOfTheSound
        }
        selectedHour = timer.date.toString(format: "HH")
        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        musicTags.translatesAutoresizingMaskIntoConstraints = false

        musicTagsConstraints.append(musicTags.heightAnchor.constraint(greaterThanOrEqualToConstant: 450))

        NSLayoutConstraint.activate(musicTagsConstraints)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
    
    
    func deselectAllOtherTags(tagText: String){
        for (i,tag) in musicTags.allTags().enumerated(){
            if tag != tagText{
                musicTags.setTagAt(UInt(i), selected: false)
            }
        }
    }

    @IBAction func didTappedOk(_ sender: UIButton) {
        
        selectedPeriod = timer.date.toString(format: "HH:mm")
        if let sound = selectedMusic{
            beep = BeepModel(nameOfTheSound: sound, period: selectedPeriod)
            navigator.periodAndSoundViewController(didOkTappedFrom: self)
        }
        else{
            print("Выберите звук!!!")
        }
    }
    
    //MARK:- PLAY SOUND
    func playSound(soundNamme: String, selected: Bool) {

        if selected{
            let path = Bundle.main.path(forResource: soundNamme, ofType:"mp3")!
            let url = URL(fileURLWithPath: path)
            print("!!!!!!url = \(url)")
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }
                
                player.prepareToPlay()
                player.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
        else{
            player?.stop()
        }
    }
    
    @IBAction func valueChangedDatePicker(_ sender: UIDatePicker) {
        print("sender.date.toString(format: HH): \(sender.date.toString(format: "HH")!)")
        print("selectedHour: \(selectedHour)")

        if sender.date.toString(format: "HH") == "00"{
            timer.date = "\(sender.date.toString(format: "HH")!):01".toDate(format: "HH:mm")!
            selectedHour = timer.date.toString(format: "HH")
            return
        }

        if sender.date.toString(format: "HH") != selectedHour{
            timer.date = "\(sender.date.toString(format: "HH")!):00".toDate(format: "HH:mm")!
        }

        selectedHour = timer.date.toString(format: "HH")
        
    }
    
    
    
    
}


extension PeriodAndSoundViewController: TTGTextTagCollectionViewDelegate{
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool) {
        deselectAllOtherTags(tagText: tagText)
        playSound(soundNamme: tagText, selected: selected)
        if selected{
            selectedMusic = tagText
        }
        else{
            selectedMusic = nil
        }
        print ("selectedMusic = \(String(describing: selectedMusic))")
    }
}
