//
//  CHIAPON3App.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/15.
//

import SwiftUI
import CoreLocation //CoreLocationを利用
import UserNotifications //ローカル通知用

@main
struct CHIAPON3App: App {
    
    //AppDelegateを設定できるようにする
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    var locationManager : CLLocationManager?    //位置情報取得用
    
    //アプリ起動時
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        /* ------------------------------------------------------ */
        /*  for location management                               */
        /* ------------------------------------------------------ */
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager!.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager!.distanceFilter = 9999
            locationManager!.allowsBackgroundLocationUpdates = true //バックグラウンド処理を可能にする
            locationManager!.pausesLocationUpdatesAutomatically = false //ポーズしても位置取得を続ける
            locationManager!.startUpdatingLocation()
        }
        
        /* ------------------------------------------------------ */
        /*  for massage management                                */
        /* ------------------------------------------------------ */
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
            if error != nil {
                print("requestAuthorization was failed.")
            }
            if granted {
                print("requestAuthorization was successful.")
                UNUserNotificationCenter.current().delegate = self
            }else{
                print("requestAuthorization was denyed.")
            }
        })
        
        return true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let newLocation = locations.last else {
            return
        }
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        print("緯度: ", location.latitude, "経度: ", location.longitude)
    }
}

/* ------------------------------------------------------ */
/*  for massage management                                */
/*  フォアグラウンドで実行しているときに届いた通知に対する処理       */
/* ------------------------------------------------------ */
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            // .alert was deprecated in iOS 14.0 or higher, .banner and .list are recommended instead of .alert.
            completionHandler([.banner, .list, .sound, .badge])
        }else{
            completionHandler([.alert, .sound, .badge])
        }
    }
}
