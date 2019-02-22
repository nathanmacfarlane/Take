import Pageboy
import Presentr
import Tabman
import UIKit
import FirebaseFirestore

class RouteManagerVC: TabmanViewController {

    var routeViewModel: RouteViewModel!
    var vcs: [UIViewController] = []
    var add: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
    }
    var edit: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "icon_edit"), style: .plain, target: self, action: #selector(goEditRoute))
    }
    var ar: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "icon_ar"), style: .plain, target: self, action: #selector(hitArButton))
    }

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

    @objc
    func hitArButton() {
        let presenter: Presentr = {
            let customType = PresentationType.custom(width: .full, height: ModalSize.custom(size: 150), center: .customOrigin(origin: CGPoint(x: 0, y: 0)))
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = TransitionType.coverVertical
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = 15
            customPresenter.backgroundColor = .white
            customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        let arVC = ARAddorViewVC()
        self.customPresentViewController(presenter, viewController: arVC, animated: true)
    }

    @objc
    func goEditRoute() {
        detail.goEditRoute()
    }

    @objc
    func addNewPhoto() {
        photos.toggleCommentView()
    }

    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: NavigationDirection, animated: Bool) {
        switch index {
        case 0: navigationItem.rightBarButtonItems = [ar, edit]
        case 3: navigationItem.setRightBarButton(add, animated: true)
        default: navigationItem.rightBarButtonItems = []
        }
    }

}
