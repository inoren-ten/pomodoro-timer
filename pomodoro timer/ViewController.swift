//
//  ViewController.swift
//  pomodoro timer
//
//  Created by 井上蓮太郎 on 2022/10/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let alarmSoundPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "sound")!.data)
    
    let userTimer:Int = 1
    var time: TimeInterval = 10
    var time2: TimeInterval = 5
    var timer = Timer()
    
    // 0. 何セット集中と休憩を繰り返したいかを管理する変数を用意する(数字, Int)


    // 1. 何回集中と休憩を繰り返したかの数を管理する変数を定義する(数字, Int)


    // 2. 今集中か休憩かどちらの状態かを保存する変数を定義する(文字列, String)

    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var nextTimeLabel: UILabel!
    @IBOutlet var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        timerLabel.text = formatTime(time: time)
        nextTimeLabel.text = "Next \(self.formatTime2(time2: time2))"
    }
    
    @IBAction func startTimer() {
        if timer.isValid {
            return
        }
    
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer) in
            self.time -= 1
            
            self.timerLabel.text = formatTime(time: time)
            
            startButton.isHidden = true
        
            if self.time == 0 {
                let alert: UIAlertController = UIAlertController(title: "終了", message: "お疲れ様でした。", preferredStyle: .alert)
                
               alarmSoundPlayer.play()
                
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: { [self] action in
                            
                            alarmSoundPlayer.stop()
                            nextTimeLabel.text = ""
                            self.restTime()
                        }
                    )
                )
                self.present(alert, animated: true, completion: nil)
                
                timer.invalidate()
            }
        })
        
        timer.fire()
    }
    
    func formatTime(time: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        
        let timeString = dateFormatter.string(from: time)!
        
        return timeString
        }
    
    func restTime() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer) in
        
        timerLabel.text = self.formatTime2(time2: time2)
        self.time2 -= 1
        if self.time2 == -1 {
            let alert2: UIAlertController = UIAlertController(title: "終了", message: "次のタスクを開始します。", preferredStyle: .alert)
            
            alarmSoundPlayer.play()
            
            alert2.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: { [self] action in
                        
                       alarmSoundPlayer.stop()
                        
                    }
                )
            )
            self.present(alert2, animated: true, completion: nil)
            
            timer.invalidate()
        }
        }
    )
        timer.fire()
    }
    
    func formatTime2(time2: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        
        let timeString = dateFormatter.string(from: time2)!
        
        return timeString
        }

}

// # やりたいことは
// 集中と休憩のタイマーを交互に表示させたい(3回)




// タイマーが終了したとき=0になった時に

//    もし今集中の状態だったら(state == "focus")
//        - 2で作った状態を休憩にする(state = "rest")
//      - タイマーをリセットする
//        - タイマーをスタートさせる


//    もし今休憩の状態だったら(state == "rest")
//        - 2で作った状態を集中にする(state = "focus")
//        - 1で作った1セットを管理する部分に+1する
//
//      - タイマーをリセットする
//    1.で作った1セットを管理する部分が0で作った上限を管理する回数を超えていたら1をリセットする

//        - それ以外ならタイマーをスタートさせる

