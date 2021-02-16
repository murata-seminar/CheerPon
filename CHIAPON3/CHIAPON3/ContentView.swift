//
//  ContentView.swift
//  CHIAPON3
//
//  Created by kmurata on 2021/02/15.
//

import SwiftUI

struct ContentView: View {
    
    var counter: Int = 0
    @State var labeltext: String = "Hello, world!"
    @State var label_unlocked: String = "Unlocked: 0"
    @State var label_locked: String = "Locked: 0"
    @State var counter_unlocked: Int = 0
    @State var counter_locked: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let pub_unlocked = NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)
    let pub_locked = NotificationCenter.default.publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification)
    
    var body: some View {
        Text(labeltext)
            .padding()
            .onReceive(timer, perform: { time in
                labeltext = "\(time)"
            })
        
        VStack {
            Text(label_unlocked)
                .onReceive(pub_unlocked, perform: { _ in
                    self.counter_unlocked = self.counter_unlocked + 1
                    label_unlocked = "Unlocked: \(counter_unlocked)"
                })
            Text(label_locked)
                .onReceive(pub_locked, perform: { _ in
                    self.counter_locked = self.counter_locked + 1
                    label_locked = "Unlocked: \(counter_locked)"
            })
        }

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
