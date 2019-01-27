import Foundation
import Pageboy

extension RouteManagerVC: PageboyViewControllerDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {

        detail = RouteDetailVC()
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

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
