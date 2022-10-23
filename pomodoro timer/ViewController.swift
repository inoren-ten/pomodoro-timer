//
//  ViewController.swift
//  pomodoro timer
//
//  Created by 井上蓮太郎 on 2022/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    let userTimer:Int = 1
    var time: TimeInterval = 6000
    var timer = Timer()

    @IBOutlet var timerLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        timerLabel.text = formatTime(time: time)
    }
    
    @IBAction func startTimer() {
        if timer.isValid {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer) in
            self.time -= 1
            
            self.timerLabel.text = formatTime(time: time)
        
            if self.time == 0 {
                let alert: UIAlertController = UIAlertController(title: "終了", message: "お疲れ様でした。", preferredStyle: .alert)
                
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: { action in
                            
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
}

