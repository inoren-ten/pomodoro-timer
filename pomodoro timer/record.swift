//
//  record.swift
//  pomodoro timer
//
//  Created by 井上蓮太郎 on 2022/12/04.
//

import Foundation
import RealmSwift

class Record: Object {
    @objc dynamic var recordTime: Int = 0
    @objc dynamic var date = Date()
}

class Goal: Object {
    @objc dynamic var goal: Int = 0
}
