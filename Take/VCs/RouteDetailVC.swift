import TwicketSegmentedControl
import UIKit

class RouteDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TwicketSegmentedControlDelegate {

    var route: Route!
    var imageKeys: [String] = []
    var images: [String: UIImage] = [:]
    var diagramKeys: [String] = []
    var diagrams: [String: [UIImage]] = [:]

    var myImagesCV: UICollectionView!
    var myDiagramsCV: UICollectionView!
    var imagesCVConst: NSLayoutConstraint!
    var bgImageView: UIImageView!
    var infoLabel: UILabel!

    let cvHeight: CGFloat = 75

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()

        DispatchQueue.global(qos: .background).async {
            self.route.fsLoadAR { diagrams in
                self.diagrams = diagrams
                for diagram in self.diagrams {
                    self.diagramKeys.append(diagram.key)
                }
                DispatchQueue.main.async {
                    self.myDiagramsCV.reloadData()
                }
            }

            self.route.fsLoadImages { images in
                self.images = images
                for image in self.images {
                    self.imageKeys.append(image.key)
                }
                DispatchQueue.main.async {
                    if let firstImage = images.first {
                        self.bgImageView.image = firstImage.value
                    }
                    self.myImagesCV.reloadData()
                }
            }
        }

    }

    @objc
    func goFavorite(sender: UIButton!) {
        print("add to favorites")
    }

    @objc
    func goToDo(sender: UIButton!) {
        print("add to do")
    }

    @objc
    func goEdit(sender: UIButton!) {
        print("going to edit")
    }

    // MARK: - Twicket Seg Control
    func didSelect(_ segmentIndex: Int) {
        self.infoLabel.text = segmentIndex == 0 ? route.info : route.protection
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == myImagesCV ? imageKeys.count : diagramKeys.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myImagesCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteDetailCVCell", for: indexPath) as? RouteDetailCVCell {
            if let cellImage = self.images[self.imageKeys[indexPath.row]] {
                cell.initImage(image: cellImage)
            }
            return cell
        } else if collectionView == myDiagramsCV, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteDetailDiagramCVCell", for: indexPath) as? RouteDetailDiagramCVCell {
            if let theImage = self.diagrams[diagramKeys[indexPath.row]] {
                cell.initImage(bgImage: theImage[0], diagramImage: theImage[1])
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func initViews() {
        self.view.backgroundColor = UIColor(named: "BluePrimary")
        self.title = route.name
        let editButton = UIBarButtonItem(image: UIImage(named: "edit.png")?.resized(withPercentage: 0.5), style: .plain, target: self, action: #selector(goEdit))
        navigationItem.rightBarButtonItem = editButton

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

        // image collectionview
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: cvHeight, height: cvHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        self.myImagesCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.myImagesCV.register(RouteDetailCVCell.self, forCellWithReuseIdentifier: "RouteDetailCVCell")
        self.myImagesCV.delegate = self
        self.myImagesCV.dataSource = self
        self.myImagesCV.backgroundColor = .clear
        self.myImagesCV.showsHorizontalScrollIndicator = false

        // diagram collectionview
        let layout2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout2.itemSize = CGSize(width: cvHeight, height: cvHeight)
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 5
        layout2.scrollDirection = .horizontal
        self.myDiagramsCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout2)
        self.myDiagramsCV.register(RouteDetailDiagramCVCell.self, forCellWithReuseIdentifier: "RouteDetailDiagramCVCell")
        self.myDiagramsCV.delegate = self
        self.myDiagramsCV.dataSource = self
        self.myDiagramsCV.backgroundColor = .clear
        self.myDiagramsCV.showsHorizontalScrollIndicator = false

        // segment control
        let segControl = TwicketSegmentedControl()
        segControl.setSegmentItems(["Description", "Protection"])
        segControl.isSliderShadowHidden = true
        segControl.sliderBackgroundColor = UIColor(named: "BlueDark") ?? .lightGray
        segControl.delegate = self

        // info label
        self.infoLabel = UILabel()
        self.infoLabel.text = route.info
        self.infoLabel.numberOfLines = 0
        self.infoLabel.textColor = .white
        self.infoLabel.font = UIFont(name: "Avenir-Oblique", size: 15)

        // add to subview
        self.view.addSubview(bgImageView)
        self.view.addSubview(gradientView)
        self.view.addSubview(myImagesCV)
        self.view.addSubview(myDiagramsCV)
        self.view.addSubview(segControl)
        self.view.addSubview(infoLabel)

        // constraints
        myImagesCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myImagesCV, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: myImagesCV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cvHeight).isActive = true

        myDiagramsCV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myDiagramsCV, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myDiagramsCV, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: myDiagramsCV, attribute: .top, relatedBy: .equal, toItem: self.myImagesCV, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: myDiagramsCV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cvHeight).isActive = true

        segControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: segControl, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -40).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .top, relatedBy: .equal, toItem: myDiagramsCV, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: segControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: infoLabel, attribute: .top, relatedBy: .equal, toItem: segControl, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
    }

}
