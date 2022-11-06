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
    var focusTimeInterval: TimeInterval = 5
    var restTimeInterval: TimeInterval = 2
    var time: TimeInterval = 5
    var time2: TimeInterval = 2
    var timer = Timer()
    var timer2 = Timer()
    
    // 0. 何セット集中と休憩を繰り返したいかを管理する変数を用意する(数字, Int)
    let maxCount = 1
    
    // 1. 何回集中と休憩を繰り返したかの数を管理する変数を定義する(数字, Int)
    var currentCount = 1
    
    // 2. 今集中か休憩かどちらの状態かを保存する変数を定義する(文字列, String)
    var state = "focus"
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var nextTimeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var restartButton: UIButton!
    
    var pauseTime:TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        timerLabel.text = formatTime(time: time)
        nextTimeLabel.text = "Next \(self.formatTime2(time2: time2))"
        stopButton.isHidden = true
        startButton.layer.cornerRadius = 25
    }
    
    @IBAction func startTimer() {
        
        self.focusTime()
    }
    
    @IBAction func stopTimer() {
        
        if state == "focus" {
            timer.invalidate()
            stopButton.isHidden = true
            restartButton.isHidden = false
        }else if state == "rest" {
            timer2.invalidate()
            stopButton.isHidden = true
            restartButton.isHidden = false
        }
    }
    
    @IBAction func restartTimer() {
        if state == "focus" {
            //            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.onUpdate(timer:)), userInfo: nil, repeats: true)
            focusTime()
        }else if state == "rest" {
            //            timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.onUpdate2(timer2:)), userInfo: nil, repeats: true)
            restTime()
        }
        stopButton.isHidden = false
        restartButton.isHidden = true
        
    }
    
    func formatTime(time: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        
        let timeString = dateFormatter.string(from: time)!
        
        return timeString
    }
    
    func focusTime() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer) in
            self.time -= 1
            
            self.timerLabel.text = formatTime(time: time)
            state = "focus"
            
            startButton.isHidden = true
            stopButton.isHidden = false
            
            if self.time == 0 {
                let alert: UIAlertController = UIAlertController(title: "終了", message: "お疲れ様でした。", preferredStyle: .alert)
                
                alarmSoundPlayer.play()
                
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: { [self] action in
                            // タイマーをリセットする
                            // タイマーをスタートさせる
                            
                            alarmSoundPlayer.stop()
                            alarmSoundPlayer.currentTime = 0
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
    
    func restTime() {
        timer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer2) in
            
            self.time2 -= 1
            timerLabel.text = self.formatTime2(time2: time2)
            
            state = "rest"
            
            if self.time2 == 0 {
                let alert2: UIAlertController = UIAlertController(title: "終了", message: "次のタスクを開始します。", preferredStyle: .alert)
                
                alarmSoundPlayer.play()
                
                alert2.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: { [self] action in
                            
                            alarmSoundPlayer.stop()
                            alarmSoundPlayer.currentTime = 0
                            
                            time = focusTimeInterval
                            time2 = restTimeInterval
                            timerLabel.text = formatTime(time: time)
                            nextTimeLabel.text = "Next \(self.formatTime2(time2: time2))"
                            
                            if currentCount < maxCount {
                                currentCount += 1
                                self.focusTime()
                            }else if currentCount == maxCount{
                                startButton.isHidden = false
                                stopButton.isHidden = true
                            }
                        }
                    )
                )
                self.present(alert2, animated: true, completion: nil)
                
                timer.invalidate()
            }
        }
        )
        timer2.fire()
    }
    
    func formatTime2(time2: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        
        let timeString = dateFormatter.string(from: time2)!
        
        return timeString
    }
    
    @objc func onUpdate(timer : Timer){
        
        // カウントの値1増加
        time -= 1
        
        // 桁数を指定して文字列を作る
        let str = formatTime(time: time)
        
        // ラベルに表示
        timerLabel.text = str
        
    }
    
    @objc func onUpdate2(timer2 : Timer){
        
        // カウントの値1増加
        time2 -= 1
        
        // 桁数を指定して文字列を作る
        let str = formatTime2(time2: time2)
        
        // ラベルに表示
        timerLabel.text = str
        
    }
}

// # やりたいことは
// 集中と休憩のタイマーを交互に表示させたい(3回)




// タイマーが終了したとき=0になった時に

//    もし今集中の状態だったら(state == "focus")



//    もし今休憩の状態だったら(state == "rest")
//        - 2で作った状態を集中にする(state = "focus")
//        - 1で作った1セットを管理する部分に+1する
//
//      - タイマーをリセットする
//    1.で作った1セットを管理する部分が0で作った上限を管理する回数を超えていたら1をリセットする

//        - それ以外ならタイマーをスタートさせる

