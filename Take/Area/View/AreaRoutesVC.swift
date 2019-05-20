import UIKit

class AreaRoutesVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // injections
    var areaViewModel: AreaViewModel?

    // ui
    var tableView: UITableView!
    var areaChartTVC: AreaChartTVC?

    // other variables
    var routes: [Route] = []
    var filteredRoutes: [Route] = []
    var firstComments: [Route: Comment] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        initViews()

        if let areaChartTVC = tableView.dequeueReusableCell(withIdentifier: "AreaChartTVC") as? AreaChartTVC {
            self.areaChartTVC = areaChartTVC
            areaChartTVC.nameLabel.text = "Difficulties"
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        }

        if let area = areaViewModel?.area {
            FirestoreService.shared.fs.query(collection: "routes", by: "area", with: area.id, of: Route.self) { routes in
                self.routes = routes
                self.filteredRoutes = routes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.areaChartTVC?.reloadData(routes: self.routes)
                }
            }
        }
    }

    func initViews() {
        let searchField = UISearchBar()
        searchField.delegate = self
        searchField.searchBarStyle = .minimal
        searchField.placeholder = "Search Routes"
        let textFieldInsideSearchBar = searchField.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UISettings.shared.colorScheme.textPrimary

        tableView = UITableView()
        tableView.register(RouteTVC.self, forCellReuseIdentifier: "RouteTVC")
        tableView.register(AreaChartTVC.self, forCellReuseIdentifier: "AreaChartTVC")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(searchField)
        view.addSubview(tableView)

        searchField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: searchField, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: searchField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: searchField, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0    ).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            filteredRoutes = self.routes
        } else {
            let routes = self.routes.filter { $0.name.uppercased().contains(text.uppercased()) }
            filteredRoutes = routes
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AreaChartTVC {
            cell.toggleVisibility()
            cell.reloadData(routes: routes)
        } else if tableView.cellForRow(at: indexPath) as? RouteTVC != nil {
            let route = routes[indexPath.row - 1]
            let routeManager = RouteManagerVC()
            routeManager.routeViewModel = RouteViewModel(route: route)
            self.navigationController?.pushViewController(routeManager, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 250 : 110
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRoutes.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.areaChartTVC ?? UITableViewCell()
        default:
            return getRouteCell(route: filteredRoutes[indexPath.row - 1])
        }
    }

    func getRouteCell(route: Route) -> RouteTVC {
        guard let cell: RouteTVC = self.tableView.dequeueReusableCell(withIdentifier: "RouteTVC") as? RouteTVC else { return RouteTVC() }
        let rvm = RouteViewModel(route: route)
        cell.nameLabel.text = rvm.name
        cell.difficultyLabel.text = rvm.rating
        cell.typesLabel.text = rvm.typesString
        cell.firstImageView.image = nil
        cell.selectionStyle = .none
        if let comment = firstComments[route], let url = comment.imageUrl {
            ImageCache.shared.getImage(for: url) { image in
                DispatchQueue.main.async {
                    cell.setImage(image: image)
                }
            }
        } else {
            cell.widthConst?.constant = 0
            DispatchQueue.global(qos: .background).async {
                FirestoreService.shared.fs.query(collection: "comments", by: "routeId", with: route.id, of: Comment.self, and: 1) { comment in
                    guard let comment = comment.first else { return }
                    self.firstComments[route] = comment
                    comment.imageUrl?.getImage { image in
                        cell.setImage(image: image)
                    }
                }
            }
        }
        return cell
    }
}

class TypesChart: UIView {
    var routes: [Route] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func reloadData() {
        for view in subviews {
            view.removeFromSuperview()
        }

        let lightColors: [String: UIColor] = ["TR": #colorLiteral(red: 0.6509803922, green: 0.7450980392, blue: 0.7803921569, alpha: 1), "Sport": #colorLiteral(red: 0.3098039216, green: 0.368627451, blue: 0.4823529412, alpha: 1), "Trad": #colorLiteral(red: 0.1764705882, green: 0.262745098, blue: 0.2941176471, alpha: 1), "Aid": #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)]
        let darkColors: [String: UIColor] = ["TR": #colorLiteral(red: 0.9176470588, green: 0.6274509804, blue: 0.6274509804, alpha: 1), "Sport": #colorLiteral(red: 0.7254901961, green: 0.3725490196, blue: 0.3725490196, alpha: 1), "Trad": #colorLiteral(red: 0.2901960784, green: 0.1568627451, blue: 0.1568627451, alpha: 1), "Aid": #colorLiteral(red: 0.1411764706, green: 0.1254901961, blue: 0.1254901961, alpha: 1)]

        let colors = UISettings.shared.mode == .dark ? darkColors : lightColors

        let types = routes.map { $0.types }.flatMap { $0 }
        let uniqueTypes = Array(Set(types))

        let pieChartView = PieChartView()
        pieChartView.segments = uniqueTypes.map { type in Segment(color: colors[type] ?? .black, value: types.reduce(0) { $0 + ($1.contains(type) ? 1 : 0) }) }

        var typeLabels: [UILabel] = []

        self.addSubview(pieChartView)

        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pieChartView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: pieChartView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pieChartView, attribute: .width, relatedBy: .equal, toItem: pieChartView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pieChartView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true

        for (i, type) in uniqueTypes.enumerated() {
            let typeLabel = LabelAvenir(size: 20, type: .Black, color: UISettings.shared.colorScheme.textPrimary)
            typeLabel.text = type

            let colorCircle = UILabel()
            colorCircle.backgroundColor = colors[type]
            colorCircle.layer.cornerRadius = 12.5
            colorCircle.clipsToBounds = true

            typeLabels.append(typeLabel)

            addSubview(typeLabel)
            addSubview(colorCircle)

            typeLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: typeLabel, attribute: .leading, relatedBy: .equal, toItem: colorCircle, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
            NSLayoutConstraint(item: typeLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -5).isActive = true
            NSLayoutConstraint(item: typeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
            NSLayoutConstraint(item: typeLabel, attribute: .top, relatedBy: .equal, toItem: i == 0 ? self : typeLabels[i - 1], attribute: i == 0 ? .top : .bottom, multiplier: 1, constant: 7).isActive = true

            colorCircle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: colorCircle, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 20).isActive = true
            NSLayoutConstraint(item: colorCircle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
            NSLayoutConstraint(item: colorCircle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
            NSLayoutConstraint(item: colorCircle, attribute: .top, relatedBy: .equal, toItem: typeLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        }
    }
}

class DifficultyChart: UIView {

    var routes: [Route] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func reloadData() {

        for view in subviews {
            view.removeFromSuperview()
        }
        var previousBar: UILabel?
        var max: Int = 0
        for i in 0...16 {
            let filteredRoutes = routes.filter { $0.rating == i }
            if filteredRoutes.count > max {
                max = filteredRoutes.count
            }
        }
        for i in 0...16 {
            let filteredRoutes = routes.filter { $0.rating == i }
            if filteredRoutes.isEmpty { continue }
            let barValue = UILabel()
            barValue.text = ".\(i)"
            barValue.textColor = .white
            barValue.textAlignment = .center
            barValue.layer.cornerRadius = 5
            barValue.clipsToBounds = true
            barValue.font = UIFont(name: "Avenir-Medium", size: 14)
            barValue.backgroundColor = UISettings.shared.colorScheme.accent

            addSubview(barValue)

            barValue.translatesAutoresizingMaskIntoConstraints = false
            var height: NSLayoutConstraint?
            let val: CGFloat = CGFloat(Float(filteredRoutes.count) / Float(max))
            if let previousBar = previousBar { // not the first bar
                NSLayoutConstraint(item: barValue, attribute: .leading, relatedBy: .equal, toItem: previousBar, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
                NSLayoutConstraint(item: barValue, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
                height = NSLayoutConstraint(item: barValue, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: val, constant: 0)
                NSLayoutConstraint(item: barValue, attribute: .width, relatedBy: .equal, toItem: previousBar, attribute: .width, multiplier: 1, constant: 0).isActive = true
            } else { // is the first bar
                NSLayoutConstraint(item: barValue, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
                NSLayoutConstraint(item: barValue, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
                height = NSLayoutConstraint(item: barValue, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: val, constant: 0)
                NSLayoutConstraint(item: barValue, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
            }
            height?.isActive = true
//            height?.constant = val
//            UIView.animate(withDuration: 0.3) {
//                barValue.layoutIfNeeded()
//            }

            previousBar = barValue
        }
        if let previousBar = previousBar {
            NSLayoutConstraint(item: previousBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        }
    }
}

class AreaChartTVC: UITableViewCell {

    var nameLabel: UILabel!
    var difficultyChart: DifficultyChart!
    var typesChart: TypesChart!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UISettings.shared.mode == .dark ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1)

        initViews()
    }

    func reloadData(routes: [Route]) {
        difficultyChart.routes = routes
        typesChart.routes = routes
        difficultyChart.reloadData()
        typesChart.reloadData()
    }

    func toggleVisibility() {
        if typesChart.alpha == 0.0 {
            fadeOutInLabel(label: nameLabel, newString: "Types", time: 0.3)
            fadeOutIn(outView: difficultyChart, inView: typesChart, time: 0.3)
        } else {
            fadeOutInLabel(label: nameLabel, newString: "Difficulties", time: 0.3)
            fadeOutIn(outView: typesChart, inView: difficultyChart, time: 0.3)
        }
    }

    func fadeOutInLabel(label: UILabel, newString: String, time: Double) {
        UIView.animate(withDuration: time,
                       animations: {
                        label.alpha = 0.0
        }, completion: { _ in
            label.text = newString
            UIView.animate(withDuration: time) {
                label.alpha = 1.0
            }
        })
    }

    func fadeOutIn(outView: UIView, inView: UIView, time: Double) {
        UIView.animate(withDuration: time,
                       animations: {
            outView.alpha = 0.0
        }, completion: { _ in
            UIView.animate(withDuration: time) {
                inView.alpha = 1.0
            }
        })
    }

    func initViews() {
        nameLabel = LabelAvenir(size: 25, type: .Medium, color: UISettings.shared.colorScheme.textSecondary)

        difficultyChart = DifficultyChart()
        typesChart = TypesChart()
        typesChart.alpha = 0.0

        addSubview(nameLabel)
        addSubview(difficultyChart)
        addSubview(typesChart)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true

        difficultyChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: difficultyChart, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: difficultyChart, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: difficultyChart, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: difficultyChart, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20).isActive = true

        typesChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: typesChart, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: typesChart, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: typesChart, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: typesChart, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
