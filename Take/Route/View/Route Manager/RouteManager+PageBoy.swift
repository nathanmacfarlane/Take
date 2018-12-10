import Foundation
import Pageboy

extension RouteManagerViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {

        let detail = RouteDetailViewController()
        detail.routeViewModel = routeViewModel

        let hype = RouteHypeViewController()
        hype.routeViewModel = routeViewModel

        photos = RoutePhotosViewController()
        photos.routeViewModel = routeViewModel

        let now = RouteNowViewController()
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
