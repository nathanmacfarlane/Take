import Pageboy
import Tabman
import UIKit

class AreaManagerVC: TabmanViewController, PageboyViewControllerDataSource {

    var areaViewModel: AreaViewModel!
    var vcs: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary
        self.dataSource = self
        bar.appearance = TabmanBar.Appearance { appearance in
            appearance.text.font = UIFont(name: "Avenir", size: 16)
            appearance.indicator.color = UISettings.shared.colorScheme.textPrimary
            appearance.style.background = .solid(color: .clear)
            appearance.state.selectedColor = UISettings.shared.colorScheme.textPrimary
            appearance.state.color = UISettings.shared.colorScheme.textSecondary
            appearance.layout.itemDistribution = .centered
        }
        title = areaViewModel.name
        
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {

        let detail = AreaDetailVC()
        detail.areaViewModel = areaViewModel

        let routes = AreaRoutesVC()
        routes.areaViewModel = areaViewModel

        vcs = [detail, routes]
        self.bar.items = [Item(title: "Overview"), Item(title: "Routes")]
        return vcs.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

}
