import Firebase
import FirebaseAuth
import Foundation
import UIKit

class InitialVC: UIViewController {

    let tabBarCnt = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.present(LoginVC(), animated: true, completion: nil)
            }
        }

        let searchRoutes = SearchRoutesVC()
        searchRoutes.title = "Search Routes"
        searchRoutes.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "TabSearch.png"), tag: 0)
        searchRoutes.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)

        let userProfile = UserProfileVC()
        userProfile.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "TabBarUser.png"), tag: 1)
        userProfile.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        if let userId = Auth.auth().currentUser?.uid {
            Firestore.firestore().query(collection: "users", by: "id", with: userId, of: User.self) { users in
                guard let loggedInUser: User = users.first else { return }
                // here you have access to the user that is currently logged in in the variable loggedInUser
                userProfile.navigationItem.title = loggedInUser.username
            }
        }

        let mapVC = TestMapVC()
        mapVC.title = "Map View"
        mapVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "TabMap.png"), tag: 1)
        mapVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)

        let routeArView = ARMenu()
        routeArView.title = "AR Viewer"
        routeArView.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_ar"), tag: 1)
        routeArView.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)

        let controllerArray = [searchRoutes, userProfile, mapVC, routeArView]
        tabBarCnt.viewControllers = controllerArray.map {
            let nav = UINavigationController(rootViewController: $0)
            nav.navigationBar.barTintColor = UISettings.shared.colorScheme.backgroundPrimary
            nav.navigationBar.tintColor = UISettings.shared.colorScheme.accent
            nav.navigationBar.isTranslucent = false
            nav.navigationBar.titleTextAttributes = [
                .foregroundColor: UISettings.shared.colorScheme.textPrimary,
                .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
            ]
            return nav
        }

        tabBarCnt.tabBar.barTintColor = UISettings.shared.colorScheme.backgroundPrimary
        tabBarCnt.tabBar.tintColor = UISettings.shared.colorScheme.accent
        tabBarCnt.tabBar.isTranslucent = false

        self.view.addSubview(tabBarCnt.view)

    }
}
