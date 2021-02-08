//
//  UsageModel.swift
//  LockUnLockTest
//
//  Created by kmurata on 2020/03/10.
//  Copyright © 2020 kmurata seminar. All rights reserved.
//

import Foundation
import RealmSwift

class UsageModel: Object{
    // 保存日時
    @objc dynamic var createDate: String = ""
    //当日のロック解除回数
    @objc dynamic var unlocked_num: Int = 0
    //累積ロック解除時間
    @objc dynamic var total_unlocked_num: Int = 0
    //利用時間(アンロック時間)
    @objc dynamic var unlocked_time : Double = 0
    //累積利用時間（アンロック時間）
    @objc dynamic var total_unlocked_time: Double = 0
}
