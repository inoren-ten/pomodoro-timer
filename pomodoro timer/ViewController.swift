//
//  ViewController.swift
//  pomodoro timer
//
//  Created by 井上蓮太郎 on 2022/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    let userTimer:Int = 1
    var count = 0

    @IBOutlet var minitLabel:UILabel!
    @IBOutlet var secoundLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        minitLabel = UILabel()
        view.addSubview(minitLabel)

        secoundLabel = UILabel()
        view.addSubview(secoundLabel)
    }
    
    @IBAction func startTimer() {
        count = userTimer * 60
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(self.timerAction(sender:)),
                                         userInfo: nil,
                                         repeats: true)
        timer.fire()
    }
    
    @objc func timerAction(sender:Timer){
        if count >= 60 {
            let minuteCount = count / 60
            
            minitLabel.text = String(minuteCount)
            secoundLabel.text = "分"
        }else if count < 60{
            minitLabel.text = String(count)
            secoundLabel.text = "秒"
            if count == 0{
                sender.invalidate()
            }
        }
        count -= 1
    }

}

