import Mapbox
import TwicketSegmentedControl
import UIKit
//import VerticalCardSwiper

class RouteDetailVC: UIViewController, /*UICollectionViewDelegate, UICollectionViewDataSource,*/ TwicketSegmentedControlDelegate, MGLMapViewDelegate {

    var route: Route!
//    var imageKeys: [String] = []
//    var images: [String: UIImage] = [:]
//    var diagramKeys: [String] = []
//    var diagrams: [String: [UIImage]] = [:]
//
//    var myImagesCV: UICollectionView!
//    var myDiagramsCV: UICollectionView!
//    var imagesCVConst: NSLayoutConstraint!
    var bgImageView: UIImageView!
    var infoLabel: UILabel!

    let cvHeight: CGFloat = 75

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

//        DispatchQueue.global(qos: .background).async {
//            self.route.fsLoadAR { diagrams in
//                self.diagrams = diagrams
//                for diagram in self.diagrams {
//                    self.diagramKeys.append(diagram.key)
//                }
//                DispatchQueue.main.async {
//                    self.myDiagramsCV.reloadData()
//                }
//            }
//
//            self.route.fsLoadImages { images in
//                self.images = images
//                for image in self.images {
//                    self.imageKeys.append(image.key)
//                }
//                DispatchQueue.main.async {
//                    if let firstImage = images.first {
//                        self.bgImageView.image = firstImage.value
//                    }
//                    self.myImagesCV.reloadData()
//                }
//            }
//        }

    }

    @objc
    func goFavorite(sender: UIButton!) {
        // TODO: add to favorites
    }

    @objc
    func goToDo(sender: UIButton!) {
        // TODO: add to do
    }

    @objc
    func goEdit(sender: UIButton!) {
        let editVC = RouteEditVC()
        editVC.bgImage = self.bgImageView.image
        self.present(editVC, animated: true, completion: nil)
    }

    @objc
    func goDownload(sender: UIButton!) {
        let downloadActionSheet: UIAlertController = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        let photosAndInformationButton = UIAlertAction(title: "Photos and Information", style: .default) { _ in
            // TODO: Downloading Photos and Information
        }
        let justInformationButton = UIAlertAction(title: "Just Information", style: .default) { _ in
            // TODO: Downloading Just Information
        }
        downloadActionSheet.addAction(cancelActionButton)
        downloadActionSheet.addAction(justInformationButton)
        downloadActionSheet.addAction(photosAndInformationButton)
        self.present(downloadActionSheet, animated: true, completion: nil)
    }

    @objc
    func goShare(sender: UIButton!) {
        let shareActionSheet: UIAlertController = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        let deleteActionButton = UIAlertAction(title: "Send to Friend", style: .default) { _ in
            // TODO: Sending to Friend
        }
        let saveActionButton = UIAlertAction(title: "Add To Do", style: .default) { _ in
            // TODO: Adding to do
        }
        shareActionSheet.addAction(cancelActionButton)
        shareActionSheet.addAction(saveActionButton)
        shareActionSheet.addAction(deleteActionButton)
        self.present(shareActionSheet, animated: true, completion: nil)
    }

    // MARK: - Twicket Seg Control
    func didSelect(_ segmentIndex: Int) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.infoLabel.alpha = 0.0
        }, completion: { _ in
            self.infoLabel.text = segmentIndex == 0 ? self.route.info : self.route.protection
            UIView.animate(withDuration: 0.3,
                           animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.infoLabel.alpha = 1.0
                }
            })
        })
    }

//    // MARK: - CollectionView
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return collectionView == myImagesCV ? imageKeys.count : diagramKeys.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == myImagesCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteDetailCVCell", for: indexPath) as? RouteDetailCVCell {
//            if let cellImage = self.images[self.imageKeys[indexPath.row]] {
//                cell.initImage(image: cellImage)
//            }
//            return cell
//        } else if collectionView == myDiagramsCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteDetailDiagramCVCell", for: indexPath) as? RouteDetailDiagramCVCell {
//            if let theImage = self.diagrams[diagramKeys[indexPath.row]] {
//                cell.initImage(bgImage: theImage[0], diagramImage: theImage[1])
//            }
//            return cell
//        }
//        return UICollectionViewCell()
//    }

    // MARK: - mapbox
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimary")
        self.title = route.name
        let editButton = UIBarButtonItem(image: UIImage(named: "edit.png")?.resized(withPercentage: 0.5), style: .plain, target: self, action: #selector(goEdit))
        let shareButton = UIBarButtonItem(image: UIImage(named: "share.png")?.resized(withPercentage: 0.5), style: .plain, target: self, action: #selector(goShare))
        let downloadButton = UIBarButtonItem(image: UIImage(named: "download.png")?.resized(withPercentage: 0.5), style: .plain, target: self, action: #selector(goDownload))
        navigationItem.rightBarButtonItems = [shareButton, editButton, downloadButton]

        // bg image
        self.bgImageView = UIImageView(frame: self.view.frame)
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.clipsToBounds = true
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = self.view.frame
        self.bgImageView.addSubview(effectView)
        let gradientView = UIView(frame: self.view.frame)
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.frame
        gradient.colors = [UIColor(named: "BluePrimaryDark")?.cgColor as Any, UIColor.clear.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)

//        // image collectionview
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        layout.itemSize = CGSize(width: cvHeight, height: cvHeight)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 5
//        layout.scrollDirection = .horizontal
//        self.myImagesCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        self.myImagesCV.register(RouteDetailCVCell.self, forCellWithReuseIdentifier: "RouteDetailCVCell")
//        self.myImagesCV.delegate = self
//        self.myImagesCV.dataSource = self
//        self.myImagesCV.backgroundColor = .clear
//        self.myImagesCV.showsHorizontalScrollIndicator = false
//
//        // diagram collectionview
//        let layout2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout2.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        layout2.itemSize = CGSize(width: cvHeight, height: cvHeight)
//        layout2.minimumInteritemSpacing = 0
//        layout2.minimumLineSpacing = 5
//        layout2.scrollDirection = .horizontal
//        self.myDiagramsCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout2)
//        self.myDiagramsCV.register(RouteDetailDiagramCVCell.self, forCellWithReuseIdentifier: "RouteDetailDiagramCVCell")
//        self.myDiagramsCV.delegate = self
//        self.myDiagramsCV.dataSource = self
//        self.myDiagramsCV.backgroundColor = .clear
//        self.myDiagramsCV.showsHorizontalScrollIndicator = false

        // rating header
        let ratingLabel = UILabel()
        ratingLabel.text = "RATING"
        ratingLabel.textColor = .lightGray
        ratingLabel.textAlignment = .center
        ratingLabel.font = UIFont(name: "Avenir", size: 14)

        // rating value
        let ratingValue = UILabel()
        ratingValue.text = route.rating ?? "N/A"
        ratingValue.textColor = .white
        ratingValue.textAlignment = .center
        ratingValue.font = UIFont(name: "Avenir", size: 24)

        // stars header
        let starsLabel = UILabel()
        starsLabel.text = "STARS"
        starsLabel.textColor = .lightGray
        starsLabel.textAlignment = .center
        starsLabel.font = UIFont(name: "Avenir", size: 14)

        // stars value
        let starsValue = UILabel()
        starsValue.text = route.averageStarString
        starsValue.textColor = .white
        starsValue.textAlignment = .center
        starsValue.font = UIFont(name: "Avenir", size: 24)

        // pitches header
        let pitchesLabel = UILabel()
        pitchesLabel.text = "PITCHES"
        pitchesLabel.textColor = .lightGray
        pitchesLabel.textAlignment = .center
        pitchesLabel.font = UIFont(name: "Avenir", size: 14)

        // pitches value
        let pitchesValue = UILabel()
        pitchesValue.text = "\(route.pitches)"
        pitchesValue.textColor = .white
        pitchesValue.textAlignment = .center
        pitchesValue.font = UIFont(name: "Avenir", size: 24)

        // type buttons
        let sportButton = TypeButton()
        sportButton.setTitle("S", for: .normal)
        sportButton.setType(isType: route.isSport())
        sportButton.addBorder(width: 1)
        let boulderButton = TypeButton()
        boulderButton.setTitle("B", for: .normal)
        boulderButton.setType(isType: route.isBoulder())
        boulderButton.addBorder(width: 1)
        let trButton = TypeButton()
        trButton.setTitle("TR", for: .normal)
        trButton.setType(isType: route.isTR())
        trButton.addBorder(width: 1)
        let tradButton = TypeButton()
        tradButton.setTitle("T", for: .normal)
        tradButton.setType(isType: route.isTrad())
        tradButton.addBorder(width: 1)
        let aidButton = TypeButton()
        aidButton.setTitle("A", for: .normal)
        aidButton.setType(isType: route.isAid())
        aidButton.addBorder(width: 1)

        // segment control
        let segControl = TwicketSegmentedControl()
        segControl.setSegmentItems(["Description", "Protection"])
        segControl.isSliderShadowHidden = true
        segControl.sliderBackgroundColor = UIColor(named: "BlueDark") ?? .lightGray
        segControl.backgroundColor = .clear
        segControl.delegate = self

        // info label
        infoLabel = UILabel()
        infoLabel.text = route.info
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .white
        infoLabel.font = UIFont(name: "Avenir-Oblique", size: 15)

        // mapbox map
        let url = URL(string: "mapbox://styles/mapbox/dark-v9")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: route.latitude ?? 0, longitude: route.longitude ?? 0), zoomLevel: 15, animated: false)
        mapView.layer.cornerRadius = 5
        mapView.clipsToBounds = true
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.showsUserLocation = true
        let routeMarker = MGLPointAnnotation()
        routeMarker.coordinate = CLLocationCoordinate2D(latitude: route.latitude ?? 0, longitude: route.longitude ?? 0)
        routeMarker.title = route.name
        routeMarker.subtitle = "\(route.rating ?? "") \(route.typesString)"
        mapView.addAnnotation(routeMarker)

        // add to subview
        view.addSubview(bgImageView)
        view.addSubview(gradientView)
        view.addSubview(ratingLabel)
        view.addSubview(ratingValue)
        view.addSubview(starsLabel)
        view.addSubview(starsValue)
        view.addSubview(pitchesLabel)
        view.addSubview(pitchesValue)
        view.addSubview(sportButton)
        view.addSubview(boulderButton)
        view.addSubview(trButton)
        view.addSubview(tradButton)
        view.addSubview(aidButton)
//        view.addSubview(myImagesCV)
//        view.addSubview(myDiagramsCV)
        view.addSubview(segControl)
        view.addSubview(infoLabel)
        view.addSubview(mapView)

//        // constraints
//        myImagesCV.translatesAutoresizingMaskIntoConstraints = false
//        let imageCVHeight: CGFloat = route.imageUrls.isEmpty ? 0.0 : 75.0
//        let diagramCVHeight: CGFloat = route.routeArUrls.isEmpty ? 0.0 : 75.0
//        NSLayoutConstraint(item: myImagesCV, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: myImagesCV, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: myImagesCV, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
//        NSLayoutConstraint(item: myImagesCV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageCVHeight).isActive = true
//
//        myDiagramsCV.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: myDiagramsCV, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: myDiagramsCV, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: myDiagramsCV, attribute: .top, relatedBy: .equal, toItem: myImagesCV, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: myDiagramsCV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: diagramCVHeight).isActive = true

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ratingLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        ratingValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ratingValue, attribute: .leading, relatedBy: .equal, toItem: ratingLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .trailing, relatedBy: .equal, toItem: ratingLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .top, relatedBy: .equal, toItem: ratingLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingValue, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: starsLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: starsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        starsValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: starsValue, attribute: .leading, relatedBy: .equal, toItem: starsLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsValue, attribute: .trailing, relatedBy: .equal, toItem: starsLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsValue, attribute: .top, relatedBy: .equal, toItem: starsLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starsValue, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        pitchesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 3, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true

        pitchesValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesValue, attribute: .leading, relatedBy: .equal, toItem: pitchesLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .trailing, relatedBy: .equal, toItem: pitchesLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .top, relatedBy: .equal, toItem: pitchesLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesValue, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        let buttonPadding: CGFloat = 8.0

        sportButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .leading, relatedBy: .equal, toItem: trButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .trailing, relatedBy: .equal, toItem: tradButton, attribute: .leading, multiplier: 1, constant: -buttonPadding).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true

        boulderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boulderButton, attribute: .trailing, relatedBy: .equal, toItem: trButton, attribute: .leading, multiplier: 1, constant: -buttonPadding).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boulderButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true

        trButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trButton, attribute: .trailing, relatedBy: .equal, toItem: sportButton, attribute: .leading, multiplier: 1, constant: -buttonPadding).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .leading, relatedBy: .equal, toItem: boulderButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 10, constant: 0).isActive = true
        NSLayoutConstraint(item: trButton, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1 / 10, constant: 0).isActive = true

        tradButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradButton, attribute: .trailing, relatedBy: .equal, toItem: aidButton, attribute: .leading, multiplier: 1, constant: -buttonPadding).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .leading, relatedBy: .equal, toItem: sportButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true

        aidButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: aidButton, attribute: .leading, relatedBy: .equal, toItem: tradButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: aidButton, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: aidButton, attribute: .width, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: aidButton, attribute: .height, relatedBy: .equal, toItem: trButton, attribute: .width, multiplier: 1, constant: 0).isActive = true

        segControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: segControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .top, relatedBy: .equal, toItem: sportButton, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .top, relatedBy: .equal, toItem: segControl, attribute: .bottom, multiplier: 1, constant: 10).isActive = true

        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: infoLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
//        NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
    }

}
