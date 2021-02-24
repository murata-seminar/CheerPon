//
//  mySettingClass.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/18.
//

import Foundation

class mySettingClass: ObservableObject{
    @Published var username: String = "no_name"
    @Published var userid: String = ""
    @Published var chiapon: String = "normal"
    @Published var type: String = "scheduled"
}

struct UsageStatusData {
    var date: Int = 0
    var usedtime: Double = 0.0
    var unusedtime: Double = 0.0
    var unlockedcount: Int = 0
    var lockedcount: Int = 0
    
    init(date: Int, usedtime: Double, unusedtime: Double, unlockedcount: Int, lockedcount: Int){
        self.date = date
        self.usedtime = usedtime
        self.unusedtime = unusedtime
        self.unlockedcount = unlockedcount
        self.lockedcount = lockedcount
        
    }
}
