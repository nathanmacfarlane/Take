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

        let mapVC = MapVC()
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
            nav.navigationBar.barTintColor = UIColor(named: "BluePrimaryDark")
            nav.navigationBar.tintColor = UIColor(named: "PinkAccent")
            nav.navigationBar.isTranslucent = false
            nav.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor(named: "Placeholder") ?? .white,
                .font: UIFont(name: "Avenir-Black", size: 26) ?? .systemFont(ofSize: 26)
            ]
            return nav
        }

        tabBarCnt.tabBar.barTintColor = UIColor(named: "BluePrimaryDark")
        tabBarCnt.tabBar.tintColor = UIColor(named: "PinkAccent")
        tabBarCnt.tabBar.isTranslucent = false

        self.view.addSubview(tabBarCnt.view)

    }
}
