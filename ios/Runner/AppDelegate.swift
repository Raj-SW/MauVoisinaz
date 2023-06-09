import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications
import flutter_background_service_ios  

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallBack{(registry) in
    GeneratedPluginRegistrant.register(with: registry)
    }
   
    GMSServices.provideAPIKey("AIzaSyDFqzfgotg6784NLJ8Mh0l2whFoeI-UwDA")
    GeneratedPluginRegistrant.register(with: self)
     if #available(iOS 10.0, *){
      UNUserNotificationCenter.current().delegate= selfas? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
