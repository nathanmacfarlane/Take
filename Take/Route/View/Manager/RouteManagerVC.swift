import ARKit
import Pageboy
import Presentr
import Tabman
import UIKit

class RouteManagerVC: TabmanViewController, AddImagesDelegate, RoutePhotosAddDelegate {

    var routeViewModel: RouteViewModel!
    var vcs: [UIViewController] = []
    var add: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImages))
    }
    var edit: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "icon_edit"), style: .plain, target: self, action: #selector(goEditRoute))
    }
//    var ar: UIBarButtonItem {
//        return UIBarButtonItem(image: UIImage(named: "icon_ar"), style: .plain, target: self, action: #selector(hitArButton))
//    }

    var photos: RoutePhotosVC!
    var detail: RouteDetailVC!

    var bgImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: "BluePrimaryDark")

        self.dataSource = self
        bar.appearance = TabmanBar.Appearance { appearance in
            appearance.text.font = UIFont(name: "Avenir", size: 16)
            appearance.indicator.color = .white
            appearance.style.background = .solid(color: .clear)
            appearance.state.selectedColor = .white
            appearance.state.color = .gray
            appearance.layout.itemDistribution = .centered
        }
        self.title = routeViewModel.name
    }

    // add images delegate
    func hitAddAr() {
        let routeAddArVC = RouteAddArVC()
        routeAddArVC.route = routeViewModel.route
        present(routeAddArVC, animated: true, completion: nil)
    }

    func hitAddPhotos() {
        let routeAddPhotosVC = RoutePhotosAddVC()
        routeAddPhotosVC.delegate = self
        let presenter = Presentr(presentationType: .fullScreen)
        self.customPresentViewController(presenter, viewController: routeAddPhotosVC, animated: true)
    }

    func addedPhotos(message: String, images: [UIImage]) {
        photos.updatedImages(message: message, images: images)
    }

    @objc
    func goEditRoute() {
        detail.goEditRoute()
    }

    @objc
    func addNewImages() {
        let presenter: Presentr = {
            let customType = PresentationType.custom(width: .full, height: .half, center: ModalCenterPosition.bottomCenter)
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVertical
            customPresenter.dismissTransitionType = TransitionType.coverVertical
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 15
            customPresenter.backgroundColor = .white
            customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        let arVC = RouteAddImagesPresentrVC()
        arVC.delegate = self
        self.customPresentViewController(presenter, viewController: arVC, animated: true)

    }

    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: NavigationDirection, animated: Bool) {
        switch index {
        case 0: navigationItem.setRightBarButton(edit, animated: true)
        case 3:  navigationItem.setRightBarButton(add, animated: true)
        default: navigationItem.rightBarButtonItems = []
        }
    }

}
