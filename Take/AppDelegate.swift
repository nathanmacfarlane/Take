import CodableFirebase
import Firebase
import FirebaseFirestore
import FirebaseInstanceID
import FirebaseMessaging
import IQKeyboardManagerSwift
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var initialViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
//
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().delegate = self
//            UNUserNotificationCenter.current().requestAuthorization { _, _ in }
//            Messaging.messaging().delegate = self
//        } else {
//            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()

        FirebaseApp.configure()

        // init so that other view controllers can access the location singleton
        _ = LocationService.shared

        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        FirestoreService.shared.fs.settings = settings

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainView = InitialVC()
        self.window?.rootViewController = mainView
        self.window?.makeKeyAndVisible()

        registerForPushNotifications()

        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
            handleNotification(aps: aps)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)

        return true
    }

    @objc
    func willResignActive() {
        print("app entering background... clearing cache")
        ImageCache.shared.clearCache()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        handleNotification(aps: aps)
    }

    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }

    func handleNotification(aps: [String: AnyObject]) {
        print("aps: \(aps)")
        if let noti = try? FirebaseDecoder().decode(FirebaseNotification.self, from: aps) {
            print("notification body: \(noti.alert.body)")
            print("notification title: \(noti.alert.title)")
        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}
