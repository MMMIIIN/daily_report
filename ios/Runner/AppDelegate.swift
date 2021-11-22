import UIKit
import Flutter
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    GeneratedPluginRegistrant.register(with: self)
    requestIDFA()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    func requestIDFA() {
        if #available(iOS 14, *){
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            })
        }
    }
}
