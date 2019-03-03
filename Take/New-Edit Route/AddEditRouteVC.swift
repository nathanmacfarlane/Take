import FirebaseFirestore
import GMStepper
import MapKit
import Presentr
import TwicketSegmentedControl
import UIKit
import WSTagsField

class AddEditRouteVC: UIViewController, TwicketSegmentedControlDelegate, ChooseLocationDelegate, MKMapViewDelegate {

    var route: Route?
    var difficultyStepper: GMStepper!
    var pitchesStepper: GMStepper!
    var cragBg: UIView!
    var cragNameLabel: UILabel!
    var locationNameLabel: UILabel!
    var latLongLabel: UILabel!
    var nameField: UITextField!
    var typesField: WSTagsField!
    var buffer: Int?
    var mapView: MKMapView!

    var tags: [String] = ([RouteType.tr, RouteType.sport, RouteType.trad, RouteType.aid].map { $0.rawValue })

    override func viewDidLoad() {
        super.viewDidLoad()

        if route == nil {
            route = Route(name: "", id: UUID().uuidString, pitches: 1)
        }
        buffer = route?.buffer

        initViews()
    }

    @objc
    func closeView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func saveRoute() {
        guard let route = route else { return }
        route.rating = Int(difficultyStepper.value)
        route.name = nameField.text ?? ""
        route.pitches = Int(pitchesStepper.value)
        route.buffer = self.buffer
        route.types = typesField.tags.map { $0.text }
        if route.latitude == nil {
            route.latitude = 35.51425171
        }
        if route.longitude == nil {
            route.longitude = -120.67471753
        }
        FirestoreService.shared.fs.save(object: route, to: "routes", with: route.id) {
            RouteViewModel(route: route).saveToGeoFire()
        }
        self.dismiss(animated: true, completion: nil)
    }

    // twicket seg control
    func didSelect(_ segmentIndex: Int) {
        segmentIndex > 0 ? self.buffer = segmentIndex - 1 : nil
    }

    func choseLocation(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        setMap(location: location)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        setMap(location: mapView.region.center)
    }

    @objc
    func tappedMapRegion() {
        let presentr = Presentr(presentationType: .popup)
        presentr.backgroundOpacity = 0.8
        let chooseLocationVC = ChooseLocationVC()
        chooseLocationVC.delegate = self
        customPresentViewController(presentr, viewController: chooseLocationVC, animated: true)
    }

    func setMap(location: CLLocationCoordinate2D) {
        mapView.removeAllAnnotations()
        let anno = MKPointAnnotation()
        anno.coordinate = location
        anno.title = ""
        mapView.addAnnotation(anno)
        latLongLabel.text = "\(Double(location.latitude).rounded(toPlaces: 6)), \(Double(location.longitude).rounded(toPlaces: 6))"
        CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude).cityAndState { city, state, _ in
            guard let city = city, let state = state else { return }
            self.locationNameLabel.text = "\(city), \(state)"
        }
    }

    func initViews() {
        view.backgroundColor = UIColor(named: "BluePrimaryDark")

        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 24)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)

        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 24)
        saveButton.addTarget(self, action: #selector(saveRoute), for: .touchUpInside)

        nameField = UITextField()
        nameField.backgroundColor = .white
        nameField.layer.cornerRadius = 20
        nameField.clipsToBounds = true
        nameField.setLeftPaddingPoints(10)
        nameField.placeholder = "Name"
        nameField.text = route?.name

        let difficultyLabel = UILabel()
        difficultyLabel.text = "Difficulty"
        difficultyLabel.textColor = .gray
        difficultyLabel.font = UIFont(name: "Avenir-Black", size: 16)

        difficultyStepper = GMStepper()
        difficultyStepper.minimumValue = 0
        difficultyStepper.maximumValue = 15
        difficultyStepper.stepValue = 1.0
        difficultyStepper.items = Array(0...15).map { "5.\($0)" }
        difficultyStepper.buttonsBackgroundColor = UIColor(hex: "#888888")
        difficultyStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        if let rating = route?.rating {
            difficultyStepper.value = Double(rating)
        }

        let bufferSeg = TwicketSegmentedControl()
        bufferSeg.setSegmentItems(["", "a", "b", "c", "d"])
        bufferSeg.isSliderShadowHidden = true
        bufferSeg.sliderBackgroundColor = UIColor(hex: "#888888")
        bufferSeg.segmentsBackgroundColor = UIColor(hex: "#4B4D50")
        bufferSeg.backgroundColor = .clear
        bufferSeg.defaultTextColor = .white
        bufferSeg.highlightTextColor = .white
        if let buffer = route?.buffer {
            bufferSeg.move(to: buffer + 1)
        }
        bufferSeg.delegate = self

        let pitchesLabel = UILabel()
        pitchesLabel.text = "Pitches"
        pitchesLabel.textColor = .gray
        pitchesLabel.font = UIFont(name: "Avenir-Black", size: 16)

        pitchesStepper = GMStepper()
        pitchesStepper.minimumValue = 1
        pitchesStepper.maximumValue = 99
        pitchesStepper.stepValue = 1.0
        if let route = route {
            pitchesStepper.value = Double(route.pitches)
        }
        pitchesStepper.buttonsBackgroundColor = UIColor(hex: "#888888")
        pitchesStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")

        let typesLabel = UILabel()
        typesLabel.text = "Types"
        typesLabel.textColor = .gray
        typesLabel.font = UIFont(name: "Avenir-Black", size: 16)

        typesField = WSTagsField()
        typesField.layer.cornerRadius = 20
        typesField.clipsToBounds = true
        typesField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        typesField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        typesField.spaceBetweenLines = 5.0
        typesField.spaceBetweenTags = 10.0
        typesField.numberOfLines = 1
        typesField.font = UIFont(name: "Avenir", size: 18)
        typesField.backgroundColor = UIColor(hex: "#4B4D50")
        typesField.tintColor = UIColor(hex: "#15171A")
        typesField.textColor = UIColor(hex: "#E5E5E5")
        typesField.fieldTextColor = UIColor(hex: "#E5E5E5")
        typesField.selectedColor = .black
        typesField.selectedTextColor = UIColor(named: "PinkAccent")
        typesField.isDelimiterVisible = false
        typesField.placeholderColor = .white
        typesField.placeholderAlwaysVisible = true
        typesField.returnKeyType = .next
        typesField.acceptTagOption = .space
        route?.types.forEach {
            let tag = $0
            typesField.addTag(tag)
            self.tags = self.tags.filter { $0.uppercased() != tag.uppercased() }
        }
        typesField.placeholder = tags.joined(separator: ", ")
        typesField.onValidateTag = { tag, tags in
            RouteType(rawValue: tag.text) != nil && !tags.contains { $0.text.uppercased() == tag.text.uppercased() }
        }
        typesField.onDidAddTag = { _, tag in
            self.tags = self.tags.filter { $0.uppercased() != tag.text.uppercased() }
            self.typesField.placeholder = self.tags.joined(separator: ", ")
        }
        typesField.onDidRemoveTag = { _, tag in
            self.tags.append(tag.text)
            self.typesField.placeholder = self.tags.joined(separator: ", ")
        }
        typesField.onDidChangeText = { field, text in
            if self.tags.contains(text ?? "") {
                self.typesField.addTag(text ?? "")
                field.text = ""
            }
        }

        let cragLabel = UILabel()
        cragLabel.text = "Crag"
        cragLabel.textColor = .gray
        cragLabel.font = UIFont(name: "Avenir-Black", size: 16)

        cragBg = UIView()
        cragBg.backgroundColor = UIColor(hex: "#15171A")
        cragBg.clipsToBounds = true
        cragBg.isUserInteractionEnabled = true

        let tapMapRegion = UITapGestureRecognizer(target: self, action: #selector(tappedMapRegion))
        cragBg.addGestureRecognizer(tapMapRegion)

        cragNameLabel = UILabel()
        cragNameLabel.text = ""
        cragNameLabel.textColor = .white
        cragNameLabel.font = UIFont(name: "Avenir-Heavy", size: 20)

        locationNameLabel = UILabel()
        locationNameLabel.text = "Tap to Search"
        locationNameLabel.textColor = UIColor(hex: "#B9ABAB")
        locationNameLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
        locationNameLabel.numberOfLines = 0

        latLongLabel = UILabel()
        latLongLabel.text = ""
        latLongLabel.textColor = UIColor(hex: "#B9ABAB")
        latLongLabel.font = UIFont(name: "Avenir-Heavy", size: 9)

        if let route = self.route, let areaId = route.area {
            FirestoreService.shared.fs.query(collection: "areas", by: "id", with: areaId, of: Area.self, and: 1) { area in
                guard let area = area.first else { return }
                let areaViewModel = AreaViewModel(area: area)
                self.cragNameLabel.text = areaViewModel.name
                areaViewModel.cityAndState { c, s in
                    self.locationNameLabel.text = "\(c), \(s)"
                }
                self.latLongLabel.text = areaViewModel.latAndLongString
            }
        }

        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        if let loc = LocationService.shared.location?.coordinate {
            let region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        }

        view.addSubview(nameField)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        view.addSubview(difficultyLabel)
        view.addSubview(difficultyStepper)
        view.addSubview(bufferSeg)
        view.addSubview(pitchesLabel)
        view.addSubview(pitchesStepper)
        view.addSubview(typesLabel)
        view.addSubview(typesField)
        view.addSubview(cragLabel)
        view.addSubview(cragBg)
        cragBg.addSubview(mapView)
        cragBg.addSubview(cragNameLabel)
        cragBg.addSubview(locationNameLabel)
        cragBg.addSubview(latLongLabel)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: closeButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        nameField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: nameField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: nameField, attribute: .top, relatedBy: .equal, toItem: closeButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: nameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: difficultyLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .top, relatedBy: .equal, toItem: nameField, attribute: .bottom, multiplier: 1, constant: 30).isActive = true

        difficultyStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: difficultyStepper, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: difficultyStepper, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: difficultyStepper, attribute: .top, relatedBy: .equal, toItem: difficultyLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: difficultyStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

        bufferSeg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bufferSeg, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: bufferSeg, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: bufferSeg, attribute: .top, relatedBy: .equal, toItem: difficultyStepper, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bufferSeg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

        pitchesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .top, relatedBy: .equal, toItem: bufferSeg, attribute: .bottom, multiplier: 1, constant: 30).isActive = true

        pitchesStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesStepper, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: pitchesStepper, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: pitchesStepper, attribute: .top, relatedBy: .equal, toItem: pitchesLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: typesLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: typesLabel, attribute: .top, relatedBy: .equal, toItem: pitchesStepper, attribute: .bottom, multiplier: 1, constant: 30).isActive = true

        typesField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: typesField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: typesField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: typesField, attribute: .top, relatedBy: .equal, toItem: typesLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: typesField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45).isActive = true

        cragLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cragLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: cragLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: cragLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: cragLabel, attribute: .top, relatedBy: .equal, toItem: typesField, attribute: .bottom, multiplier: 1, constant: 30).isActive = true

        cragBg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cragBg, attribute: .leading, relatedBy: .equal, toItem: cragLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cragBg, attribute: .trailing, relatedBy: .equal, toItem: cragLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cragBg, attribute: .top, relatedBy: .equal, toItem: cragLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: cragBg, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: cragBg, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: cragBg, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: cragBg, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: cragBg, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        cragNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cragNameLabel, attribute: .leading, relatedBy: .equal, toItem: cragBg, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cragNameLabel, attribute: .trailing, relatedBy: .equal, toItem: cragBg, attribute: .centerX, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: cragNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: cragNameLabel, attribute: .bottom, relatedBy: .equal, toItem: locationNameLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true

        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: locationNameLabel, attribute: .leading, relatedBy: .equal, toItem: cragBg, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: locationNameLabel, attribute: .trailing, relatedBy: .equal, toItem: cragBg, attribute: .centerX, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: locationNameLabel, attribute: .centerY, relatedBy: .equal, toItem: cragBg, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: locationNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        latLongLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: latLongLabel, attribute: .leading, relatedBy: .equal, toItem: cragBg, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: latLongLabel, attribute: .trailing, relatedBy: .equal, toItem: cragBg, attribute: .centerX, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: latLongLabel, attribute: .top, relatedBy: .equal, toItem: locationNameLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: latLongLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

    }

    override func viewWillLayoutSubviews() {
        cragBg.layer.cornerRadius = 5
        cragBg.clipsToBounds = true
    }

}
