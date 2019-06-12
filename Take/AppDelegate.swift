import CodableFirebase
import Firebase
import FirebaseFirestore
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UIKit
import UserNotifications

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var initialViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        if let colorScheme = UserDefaults.standard.string(forKey: "colorScheme") {
            if colorScheme == "dark" {
                UISettings.shared.mode = .dark
            } else {
                UISettings.shared.mode = .light
            }
        }
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

        GMSServices.provideAPIKey("AIzaSyABwatGpHYZOMUgTQ469NFHg6CLSWDL2HQ")
        GMSPlacesClient.provideAPIKey("AIzaSyABwatGpHYZOMUgTQ469NFHg6CLSWDL2HQ")

        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        FirestoreService.shared.fs.settings = settings

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainView = InitialVC()
//        let mainView = PlanTripVC2()
//
//        let camel = MPRoute(id: 123, name: "Camel", type: "TR, Sport", rating: "5.10c", stars: 3.4, starVotes: IntorString(), pitches: IntorString(), location: [], url: "", latitude: 35.302186, longitude: -120.694003)
//        let sixtySeconds = MPRoute(id: 456, name: "60 Seconds", type: "TR, Trad", rating: "5.9", stars: 2.4, starVotes: IntorString(), pitches: IntorString(), location: [], url: "", latitude: 35.302104, longitude: -120.693959)
//
//        let westernAirlines = MPRoute(id: 789, name: "Western Airlines", type: "TR, Sport", rating: "5.11a", stars: 3.1, starVotes: IntorString(), pitches: IntorString(), location: [], url: "", latitude: 12345.0, longitude: 12345.0)
//        let civilizedEvil = MPRoute(id: 01233423, name: "Civilized Evil", type: "TR, Sport, Trad", rating: "5.11b", stars: 2.9, starVotes: IntorString(), pitches: IntorString(), location: [], url: "", latitude: 12345.0, longitude: 12345.0)
//        let llama = MPRoute(id: 456, name: "Llama", type: "TR", rating: "5.10b-c", stars: 2.8, starVotes: IntorString(), pitches: IntorString(), location: [], url: "", latitude: 12345.0, longitude: 12345.0)
//        let humps = MPRoute(id: 789, name: "Humps", type: "Sport", rating: "5.11c", stars: 3.4, starVotes: IntorString(), pitches: IntorString(), location: [], url: "", latitude: 12345.0, longitude: 12345.0)
//
//        mainView.suggestedRoutes = [camel, sixtySeconds, westernAirlines, civilizedEvil, llama, humps]
//        mainView.userClimbs = (10, 1)

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
//        print(remoteMessage.appData)
    }

    func handleNotification(aps: [String: AnyObject]) {
        print("aps: \(aps)")
        if let noti = try? FirebaseDecoder().decode(FirebaseNotification.self, from: aps) {
//            print("notification body: \(noti.alert.body)")
//            print("notification title: \(noti.alert.title)")
        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
//            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Notification settings: \(settings)")
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
