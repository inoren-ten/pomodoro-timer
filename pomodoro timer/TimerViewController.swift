//
//  dataViewController.swift
//  pomodoro timer
//
//  Created by 井上蓮太郎 on 2022/11/06.
//

import UIKit
import RealmSwift

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let realm = try! Realm()
    
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var startButton: UIButton!
    
    //    var timer:Timer = Timer()
    var count: Int = 0
    var maxCount: Int = 1
    
    @IBOutlet var maxCountLabel: UILabel!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    
    let dataList = [[Int](0...24), [Int](0...60), [Int](0...60)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        startButton.layer.cornerRadius = 50
        plusButton.layer.cornerRadius = 37.5
        minusButton.layer.cornerRadius = 37.5
        
        //add to label "time"
        let hourLabel = UILabel()
        hourLabel.text = "時間"
        hourLabel.sizeToFit()
        hourLabel.frame = CGRect(x: pickerView.bounds.width/4 - hourLabel.bounds.width/2, y: pickerView.bounds.height/2 - (hourLabel.bounds.height/2), width: hourLabel.bounds.width, height: hourLabel.bounds.height)
        pickerView.addSubview(hourLabel)
        
        //add to label "分"
        let minitLabel = UILabel()
        minitLabel.text = "分"
        minitLabel.sizeToFit()
        minitLabel.frame = CGRect(x: pickerView.bounds.width/2 - minitLabel.bounds.width/2, y: pickerView.bounds.height/2 - (minitLabel.bounds.height/2), width: minitLabel.bounds.width, height:  minitLabel.bounds.height)
        pickerView.addSubview(minitLabel)
        
        //add to label "秒"
        let secondLabel = UILabel()
        secondLabel.text = "秒"
        secondLabel.sizeToFit()
        secondLabel.frame = CGRect(x: pickerView.bounds.width*3/4 - secondLabel.bounds.width/2, y: pickerView.bounds.height/2 - (secondLabel.bounds.height/2), width: secondLabel.bounds.width, height: secondLabel.bounds.height)
        pickerView.addSubview(secondLabel)
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func plusCount() {
        maxCount = maxCount + 1
        maxCountLabel.text = String(maxCount)
    }
    
    @IBAction func minusCount() {
        if maxCount == 0 {
            return
        } else {
            maxCount = maxCount - 1
            maxCountLabel.text = String(maxCount)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    
    //コンポーネントに含まれるデータの個数を返すメソッド
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList[component].count
    }
    
    //サイズを返すメソッド
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width * 1/4
    }
    
    //データを返すメソッド
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.left
        pickerLabel.text = String(dataList[component][row])
        return pickerLabel
    }
    
    @IBAction func startCountButton(_ sender: Any) {
        count = dataList[0][pickerView.selectedRow(inComponent: 0)] * 60 * 60
        + dataList[1][pickerView.selectedRow(inComponent: 1)] * 60
        + dataList[2][pickerView.selectedRow(inComponent: 2)]
        print (count)
        
        if count == 0 {
            let alert: UIAlertController = UIAlertController(title: "Oops!", message: "時間を設定してください", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: { action in
                    }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let recordCount = Record()
            
            recordCount.recordTime = maxCount * count
            
            try! realm.write {
                realm.add(recordCount)
            }
            print(recordCount)
            
            performSegue(withIdentifier: "toTimer", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimer" {
            let svc = segue.destination as? ViewController
            svc?.focustime = TimeInterval(count)
            let nextView = segue.destination as! ViewController
            nextView.maxCount = Int(maxCountLabel.text!)!
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
