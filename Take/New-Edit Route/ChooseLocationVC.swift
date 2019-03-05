import MapKit
import UIKit

class ChooseLocationVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    var mapView: MKMapView!

    var delegate: ChooseLocationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        initViews()

        if let loc = LocationService.shared.location?.coordinate {
            let region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            let anno = MKPointAnnotation()
            anno.coordinate = loc
            mapView.addAnnotation(anno)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.resignFirstResponder()
        FirestoreService.shared.fs.query(collection: "areas", by: "name", with: searchText, of: Area.self) { area in
            guard let area = area.first else { return }
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: area.latitude, longitude: area.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }

    func initViews() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self

        let searchField = UISearchBar()
        searchField.delegate = self
        searchField.searchBarStyle = .minimal
        searchField.placeholder = "Ex. Bishop Peak"

        view.addSubview(mapView)
        view.addSubview(searchField)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        searchField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: searchField, attribute: .leading, relatedBy: .equal, toItem: mapView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchField, attribute: .trailing, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAllAnnotations()
        let anno = MKPointAnnotation()
        anno.coordinate = mapView.region.center
        anno.title = ""
        mapView.addAnnotation(anno)
        delegate?.choseLocation(location: mapView.region.center)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
}

protocol ChooseLocationDelegate: class {
    func choseLocation(location: CLLocationCoordinate2D)
}
