//
//  RecordViewController.swift
//  pomodoro timer
//
//  Created by 井上蓮太郎 on 2022/12/04.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController {
    
    @IBOutlet var allCount: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    let realm = try! Realm()
    let today = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let record: Record? = record()
        // 1. 集中時間の合計を保存する変数を用意する
        var totalTime: Int = 0
       
        // 2.Realmから記録を全件取得する
        let records = realm.objects(Record.self)
        // 3. for文を使って全件取得したデータから集中した時間を取得してtotalTimeに足す
        for record in records {
            totalTime += record.recordTime
            print(totalTime)
            dump(record)
        }
        // 4. totalTimeをlabelに反映する
        
        self.allCount.text = formatTime(time: TimeInterval(totalTime))
        dateLabel.text = getToday(format: "yyyy-MM-dd")
    }

    func formatTime(time: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        
        let timeString = dateFormatter.string(from: time)!
        
        return timeString
    }
    
    func getToday(format:String = "yyyy/MM/dd HH:mm:ss") -> String {
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: now as Date)
        }
    
    func record() -> Record? {
        return realm.objects(Record.self).first
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
