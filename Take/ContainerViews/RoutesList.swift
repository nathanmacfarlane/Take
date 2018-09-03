//
//  RoutesList.swift
//  Take
//
//  Created by Nathan Macfarlane on 9/3/18.
//  Copyright © 2018 N8. All rights reserved.
//

import UIKit

class RoutesList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: IBOutlets
    @IBOutlet private weak var myTableView: UITableView!

    // MARK: - Variables
    var routes: [Route] = []
    var theArea: Area!
    var selectedImage: UIImage?
    var areaImage: UIImage?

    // MARK: - View Load/Unload
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myTableView.backgroundColor = UIColor.clear
        self.myTableView.separatorStyle = .none

    }

    func reloadTV() {
        print("reloading routes: \(self.routes)")
        self.myTableView.reloadData()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let theRoute = self.routes[indexPath.row]
        self.selectedImage = nil
        if let routeCell = tableView.cellForRow(at: indexPath) as? RouteCell {
            self.selectedImage = routeCell.getImage()
        }
        guard let areaView = self.parent as? AreaView else { return }
        areaView.goToRoute(route: theRoute, image: selectedImage)
//        self.performSegue(withIdentifier: "goToDetail", sender: theRoute)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? RouteCell else { return RouteCell() }

        let route = routes[indexPath.row]
        cell.setLabels(name: route.name, types: route.typesString, difficulty: route.rating ?? "N/A")

        DispatchQueue.global(qos: .background).async {
            route.fsLoadFirstImage { _, image in
                DispatchQueue.main.async {
                    if let image = image {
                        cell.setImage(with: image)
                    }
                }
            }
            if let image = self.areaImage {
                DispatchQueue.main.async {
                    cell.setLocationImage(with: image)
                }
            } else {
                self.theArea.getCoverPhoto { image in
                    DispatchQueue.main.async {
                        if let image = image {
                            cell.setLocationImage(with: image)
                        }
                    }
                }
            }
        }

        if let area = route.area {
            cell.setLocationImage(with: UIImage())
            cell.setAreaAbrev(with: area)
        } else {
            cell.setAreaButtonTitle()
        }

        return cell
    }

}
