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
        .alert(isPresented: $delegate.alert, content: {
            Alert(title: Text("Message"), message: Text("Reply Button Is pressed!"), dismissButton: .destructive(Text("Ok")))
        })
    }
    
    func createNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Mesage"
        content.subtitle = "Notification from In-App from Boris"
        
        content.categoryIdentifier = "ACTIONS"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "IN-APP", content: content, trigger: trigger)
        
        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

//Getting access to notifications
class NotificationDelegate: NSObject, ObservableObject,UNUserNotificationCenterDelegate{
    @Published var alert = false
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
    //Listening to actions...
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "REPLY"{
            print("reply the comment or do anything")
            self.alert.toggle()
        }
        completionHandler()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
