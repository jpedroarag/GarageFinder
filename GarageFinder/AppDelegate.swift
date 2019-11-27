//
//  AppDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 19/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import CoreData
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootVC = MapViewController()
    weak var updateParkingStatusDelegate: UpdateParkingStatusDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        updateParkingStatusDelegate = rootVC.floatingViewController
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            print("Received Notification: \(notification?.payload.notificationID ?? "nil")")
            print("launchURL = \(notification?.payload.launchURL ?? "None")")
            print("content_available = \(notification?.payload.contentAvailable ?? false)")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            
            print("Message = \(payload?.body ?? "nil")")
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "None")")
            
            if let additionalData = result?.notification.payload?.additionalData {
                print("additionalData = \(additionalData)")
                
                if let actionSelected = payload?.actionButtons {
                    print("actionSelected = \(actionSelected)")
                }
                
                if let statusStr = additionalData["status"] as? String,
                    let status = Bool(statusStr), let parkingIdStr = additionalData["parkingId"] as? String,
                    let parkingId = Int(parkingIdStr) {
                    
                    //self.updateParkingStatusDelegate?.didUpdateParkingStatus(status: status, parkingId: parkingId)
                    self.window?.rootViewController = self.rootVC
                    self.window?.makeKeyAndVisible()
                    
                }
                
                // DEEP LINK from action buttons
                if let actionID = result?.action.actionID {
                    print("ActionID: \(actionID)")
                }
            }
        }
        
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
        appId: "75ad7e1f-f43a-4382-ada0-50553d07b475",
        handleNotificationReceived: notificationReceivedBlock,
        handleNotificationAction: notificationOpenedBlock,
        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
        print("User accepted notifications: \(accepted)")
        })
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("USER INFO: \(userInfo)")

        if let custom = userInfo["custom"] as? [AnyHashable: Any],
            let content = custom["a"] as? [AnyHashable: Any],
            let parkingIdStr = content["parkingId"] as? String, let parkingId = Int(parkingIdStr),
            let status = content["status"] as? Bool {
            
            self.updateParkingStatusDelegate?.didUpdateParkingStatus(status: status, parkingId: parkingId)
        }
    }

    func setupActionButtons() {
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
              title: "Aceitar",
              options: .foreground)
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Negar",
              options: [.destructive, .foreground])
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "PARKING_INVITATION",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveChanges()
    }

}
