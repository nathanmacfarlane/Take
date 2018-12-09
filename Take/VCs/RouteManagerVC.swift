import Pageboy
import Tabman
import UIKit

class RouteManagerVC: TabmanViewController, PageboyViewControllerDataSource {

    var routeViewModel: RouteViewModel!
    var vcs: [UIViewController] = []
    var add: UIBarButtonItem!

    var photos: RoutePhotosVC!

    var bgImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

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

        add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
    }

    @objc
    func addNewPhoto() {
        photos.toggleCommentView()
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {

        let detail = RouteDetailVC()
        detail.routeViewModel = routeViewModel

        let hype = RouteHypeVC()
        hype.routeViewModel = routeViewModel

        photos = RoutePhotosVC()
        photos.routeViewModel = routeViewModel

        let now = RouteNowVC()
        now.routeViewModel = routeViewModel

        vcs = [detail, hype, now, photos]
        self.bar.items = [Item(title: "Overview"), Item(title: "Hype"), Item(title: "Now"), Item(title: "Photos")]
        return vcs.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }

    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: NavigationDirection, animated: Bool) {
        switch index {
        case 3: navigationItem.setRightBarButton(add, animated: true)
        default: navigationItem.setRightBarButton(nil, animated: true)
        }
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

}
