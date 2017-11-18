//
//  TestViewController.swift
//  MakeABeep
//
//  Created by Artem Mazheykin on 30.10.17.
//  Copyright © 2017 Artem Mazheykin. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import TTGTagCollectionView

class TestViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    @IBOutlet weak var tagView: TTGTextTagCollectionView!
    var tempURL = ""
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var error: NSErrorPointer = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        check_record_permission()
        tagView.delegate = self

        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        do{
            let folderContent = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory.path)
            for tag in folderContent{
                tagView.addTag(tag)
            }
        }
        catch{
            print("!!!!!!!error")
        }

        // Do any additional setup after loading the view.
    }

    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
                }
            }
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        do{
            let directoryContents = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory.path)
            print("directoryContents = \(directoryContents)")
        }
        catch{
            print("!!!!!!!error")
        }
        
        do{
            let path = documentsDirectory.appendingPathComponent("30.10.2017T15:47:56")
            let path1 = documentsDirectory.appendingPathComponent("30.10.2017T15:48:34")

            try FileManager.default.removeItem(atPath: path.path)
            try FileManager.default.removeItem(atPath: path1.path)

        }
        catch{
            print("error in deleting")
        }
        print("paths = \(paths)")
        print("documentsDirectory = \(documentsDirectory)")
        
        return documentsDirectory
    }
    
    func getFileUrl() -> URL
    {
        let filename = Date().toString(format: "dd.MM.YYYY HH:mm:ss")!
        tempURL = filename
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func getFileUrl(fileName: String) -> URL
    {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        return filePath
    }

    
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK", action_title2: "Not")
            }
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK", action_title2: "Not")
        }
    }
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String, action_title2 : String)
    {
        let ac2 = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        ac.addAction(UIAlertAction(title: action_title2, style: .default)
        {
            (result : UIAlertAction) -> Void in
            return
        })
        ac.addTextField { (textField) in
            _ = textField.text
        }
        present(ac, animated: true)
    }

    @IBAction func alert(_ sender: UIButton){
        display_alert(msg_title : "УРРА" , msg_desc : "Тратата" ,action_title : "Ok", action_title2 : "NOT")
    }
    
    @IBAction func start_recording(_ sender: UIButton)
    {
        if(isRecording)
        {
            finishAudioRecording(success: true)
            record_btn_ref.setTitle("Record", for: .normal)
            play_btn_ref.isEnabled = true
            isRecording = false
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1, animations: {
                    self.tagView.addTag(self.tempURL)
                })
            }
        }
        else
        {
            setup_recorder()
            
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            record_btn_ref.setTitle("Stop", for: .normal)
            play_btn_ref.isEnabled = false
            isRecording = true
        }
    }
    
    func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK", action_title2: "Not")
        }
    }
    
func play_recording(soundNamme: String, selected: Bool)
    {
        if(!selected)
        {
            audioPlayer.stop()
            record_btn_ref.isEnabled = true
            play_btn_ref.setTitle("Play", for: .normal)
            isPlaying = false
        }
        else
        {
//            print("getFileUrl() = \(getFileUrl())")
//            print("getFileUrl().path = \(getFileUrl().path)")

            if FileManager.default.fileExists(atPath: getFileUrl(fileName: soundNamme).path)
            {
                record_btn_ref.isEnabled = false
                play_btn_ref.setTitle("pause", for: .normal)
                do
                {
                    audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl(fileName: soundNamme))
                    audioPlayer.delegate = self
                    audioPlayer.prepareToPlay()
                }
                catch{
                    print("Error")
                }
                audioPlayer.play()
                isPlaying = true
            }
            else
            {
                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK", action_title2: "Not")
            }
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
        play_btn_ref.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        record_btn_ref.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func deselectAllOtherTags(tagText: String){
        for (i,tag) in tagView.allTags().enumerated(){
            if tag != tagText{
                tagView.setTagAt(UInt(i), selected: false)
            }
        }
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

extension TestViewController: TTGTextTagCollectionViewDelegate{
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool) {
        deselectAllOtherTags(tagText: tagText)
        play_recording(soundNamme: tagText, selected: selected)
    }
}
