//
//  AppDelegate.swift
//  tn
//
//  Created by Mohamed Aboelsaad on 5/3/20.
//  Copyright © 2020 Mohamed Aboelsaad. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import  FirebaseFirestore
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate,MessagingDelegate {

    var FCMToken = ""
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        GMSPlacesClient.provideAPIKey("AIzaSyBa47VILY3txPdQesJ1Jfx1sdppdu0Qub4")
        GMSServices.provideAPIKey("AIzaSyBa47VILY3txPdQesJ1Jfx1sdppdu0Qub4")

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        IQKeyboardManager.shared.enable = true
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           completionHandler()
        }
       }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            UserDefaults.standard.set(deviceToken, forKey: "token")
                let db = Firestore.firestore()
                let str = String(decoding: deviceToken, as: UTF8.self)
                db.collection("user").whereField("phone", isEqualTo:UserDefaults.standard.string(forKey: "phone")!)
                    .getDocuments() { (querySnapshot, err) in
                        print(UserDefaults.standard.string(forKey: "phone"))
                    print(deviceToken)
                    var id = querySnapshot!.documents.first?.documentID
                        if(id != nil){
                        let sfReference = db.collection("user").document(id!)
                            sfReference.updateData(["token":str], completion: nil)
                    
            }
            }
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
            UserDefaults.standard.set(fcmToken, forKey: "token")
                let db = Firestore.firestore()
                let str = fcmToken
                db.collection("user").whereField("phone", isEqualTo:UserDefaults.standard.string(forKey: "phone"))
                    .getDocuments() { (querySnapshot, err) in

                    if querySnapshot!.documents !=  nil{
                    var id = querySnapshot!.documents.first?.documentID
                        if(id != nil){
                        let sfReference = db.collection("user").document(id!)
                            sfReference.updateData(["token":str], completion: nil)
                    }
            }
            }    }

