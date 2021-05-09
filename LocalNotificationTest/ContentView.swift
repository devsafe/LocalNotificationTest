//
//  ContentView.swift
//  LocalNotificationTest
//
//  Created by Сахар Кубический on 10.05.2021.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        Home()
    }
}


struct Home: View {
    @StateObject var delegate = NotificationDelegate()
    var body: some View {
        
        Button(action: createNotification, label: {
            Text("Notify user")
        })
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in
                
                
            }
            
            UNUserNotificationCenter.current().delegate = delegate
        })
    }
    
    func createNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Mesage"
        content.subtitle = "Notification from In-App from Boris"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "IN-APP", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

//Getting access to notifications
class NotificationDelegate: NSObject, ObservableObject,UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
