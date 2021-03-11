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

struct UsageStatusData: Identifiable, Codable{
    var id = UUID()
    var date: String = ""
    var usedtime: Double = 0.0
    var usedave: Double = 0.0
    var usedvar: Double = 0.0
    var unusedtime: Double = 0.0
    var unusedave: Double = 0.0
    var unusedvar: Double = 0.0
    var unlockedcount: Int = 0
    var lockedcount: Int = 0
    
    init(date: String = "", usedtime: Double = 0.0, usedave: Double = 0.0, usedvar: Double = 0.0, unusedtime: Double = 0.0, unusedave: Double = 0.0, unusedvar: Double = 0.0, unlockedcount: Int = 0, lockedcount: Int = 0){
        self.id = UUID()
        self.date = date
        self.usedtime = usedtime
        self.usedave = usedave
        self.usedvar = usedvar
        self.unusedtime = unusedtime
        self.unusedave = unusedave
        self.unusedvar = unusedvar
        self.unlockedcount = unlockedcount
        self.lockedcount = lockedcount
        
    }
}

// 統計量の計算に利用
//https://qiita.com/81ekkein/items/f5649a4842cbda165ad2
extension Array where Element == Double{
    //総和
    //全体の各要素を足し合わせるだけ。
    func sum(_ array:[Double])->Double{
        return array.reduce(0,+)
    }
    //平均値
    //全体の総和をその個数で割る。
    func average(_ array:[Double])->Double{
        return self.sum(array) / Double(array.count)
    }
    //分散
    //求め方が２つあるが、計算量が少ないと思われる方法を採用。
    //V=E[X^2]-E[X]^2が成立。
    func variance(_ array:[Double])->Double{
        let left=self.average(array.map{pow($0, 2.0)})
        let right=pow(self.average(array), 2.0)
        let count=array.count
        return (left-right)*Double(count/(count-1))
    }
    //標準偏差
    //これは分散の正の平方根。つまりS=√V
    func standardDeviation(_ array:[Double]) -> Double {
        return sqrt(self.variance(array))
    }
    //偏差
    //各要素と全体の平均値の差
    //後の標準化で活躍するため求めとく。
    func deviation(_ array:[Double]) -> [Double] {
        let average = self.average(array)
        return array.map{ $0 - average }
    }
    //分散もう１つのパターン
    /*
    func variance(_ array:[Double])->Double{
        return self.average(pow(self.deviation(array),2.0))
    }
    */
    //歪度
    func skewness(_ array:[Double])->Double{
        return self.average(self.deviation(array).map{pow($0, 3.0)}) / pow(self.standardDeviation(array), 3.0)
    }
    //尖度
    func kurtosis(_ array:[Double])->Double{
        return (self.average(self.deviation(array).map{pow($0, 4.0)}) / pow(self.standardDeviation(array), 4.0) - 3.0)// 正規分布を想定
    }
    //幾何平均
    func geometricMean(_ array:[Double])->Double{
        return pow(array.reduce(0, *), 1.0 / Double(array.count))
        //この方法だと、nが大きい場合に計算制度が著しく落ちる。というか計算できない。
    }
    //調和平均
    func harmonicMean(_ array:[Double])->Double{
        let left=Double(array.count)
        let right=self.sum(array.map{1 / $0})
        return left/right
    }
    //中央値
    //これはソートできていること前提なので、先にソートをしておく必要あり
    func median(_ array:[Double])->Double{
        //indexとの差を-1することで消す。
        let count=array.count-1
        print("count:"+String(count))
        print(array[Int(floor(Double(count/2)))])
        if count%2==0{
            return array[Int(count/2)]
        }else{
            return ((array[Int(floor(Double(count/2)))]+array[Int(floor(Double(count/2)))+1]) / 2)
        }
    }
    //最頻値
    func mode(_ array:[Double])->[Double]{
        var sameList:[Double]=[]
        var countList:[Int]=[]
        for item in array{
            if let index=sameList.firstIndex(of: item){
                countList[index] += 1
            }else{
                sameList.append(item)
                countList.append(1)
            }
        }
        let maxCount=countList.max(by: {$1 > $0})
        var modeList:[Double]=[]
        for index in 0..<countList.count{
            if countList[index]==maxCount!{
                modeList.append(sameList[index])
            }
        }
        return modeList
    }
    //変動係数
    //割るだけなので登場させました。
    func coefficientOfVariation(_ array:[Double])->Double{
        return self.standardDeviation(array)/self.average(array)
    }
}
