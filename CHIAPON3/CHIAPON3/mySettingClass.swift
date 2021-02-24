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
    var usagetime: Double = 0.0
    var usagecount: Int = 0
    
    init(date: Int, usagetime: Double, usagecount: Int){
        self.date = date
        self.usagetime = usagetime
        self.usagecount = usagecount
    }
}
