import Pageboy
import Tabman
import UIKit

class RouteManagerVC: TabmanViewController {

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

    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: NavigationDirection, animated: Bool) {
        switch index {
        case 3: navigationItem.setRightBarButton(add, animated: true)
        default: navigationItem.setRightBarButton(nil, animated: true)
        }
    }

}
