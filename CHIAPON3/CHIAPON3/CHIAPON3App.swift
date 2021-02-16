//
//  CHIAPON3App.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/15.
//

import SwiftUI
import CoreLocation //CoreLocationを利用

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

// アプリの起動時に、位置情報を利用できるように設定してしまう
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    var locationManager : CLLocationManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestAlwaysAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager!.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager!.distanceFilter = 3000
            locationManager!.allowsBackgroundLocationUpdates = true //バックグラウンド処理を可能にする
            locationManager!.pausesLocationUpdatesAutomatically = false //ポーズしても位置取得を続ける
            locationManager!.startUpdatingLocation()
        }
        
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
