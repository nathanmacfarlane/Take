import Blueprints
import Cosmos
import Foundation
import UIKit

class MapRoutePreview: MapPreviewView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var typeLabel: UILabel!
    var difficultyLabel: UILabel!
    var cosmos: CosmosView!
    var pitchesLabel: UILabel!
    var collectionView: UICollectionView!
    private var photoUrls: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        initRouteViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initRouteViews()
    }

    func addImage(photoUrl: String) {
        photoUrls.append(photoUrl)
        collectionView.reloadData()
    }

    func clearImages() {
        photoUrls = []
        collectionView.reloadData()
    }

    func initRouteViews() {
        difficultyLabel = UILabel()
        difficultyLabel.textAlignment = .center
        difficultyLabel.textColor = #colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2509803922, alpha: 1)
        difficultyLabel.font = UIFont(name: "Avenir-Black", size: 17)
        difficultyLabel.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)

        typeLabel = UILabel()
        typeLabel.textColor = #colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2509803922, alpha: 1)
        typeLabel.font = UIFont(name: "Avenir-Black", size: 17)

        cosmos = CosmosView()
        cosmos.settings.starSize = 25
        cosmos.settings.totalStars = 4
        cosmos.settings.emptyBorderColor = .clear
        cosmos.settings.emptyBorderWidth = 0
        cosmos.settings.filledBorderWidth = 0
        cosmos.settings.filledBorderColor = .clear
        cosmos.settings.updateOnTouch = false
        cosmos.settings.starMargin = -4
        cosmos.settings.filledImage = UISettings.shared.mode == .dark ? UIImage(named: "icon_star_selected") : UIImage(named: "icon_star")
        cosmos.settings.emptyImage = UISettings.shared.mode == .dark ? UIImage(named: "icon_star") : UIImage(named: "icon_star_selected")
        cosmos.settings.fillMode = .precise

        pitchesLabel = UILabel()
        pitchesLabel.textColor = #colorLiteral(red: 0.6235294118, green: 0.6235294118, blue: 0.6235294118, alpha: 1)
        pitchesLabel.font = UIFont(name: "Avenir-Black", size: 17)

        let blueprintLayout = HorizontalBlueprintLayout(
            itemsPerRow: 2,
            itemsPerColumn: 1,
            itemSize: CGSize(width: 75, height: 75),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 0, left: 20, bottom: 0, right: 0),
            stickyHeaders: true,
            stickyFooters: true
        )

        blueprintLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: blueprintLayout)
        collectionView.register(RoutePhotosCVC.self, forCellWithReuseIdentifier: "RoutePhotoCVCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        addSubview(difficultyLabel)
        addSubview(typeLabel)
        addSubview(cosmos)
        addSubview(pitchesLabel)
        addSubview(collectionView)

        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: difficultyLabel, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 65).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: difficultyLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: typeLabel, attribute: .leading, relatedBy: .equal, toItem: difficultyLabel, attribute: .trailing, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: typeLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: typeLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: typeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        cosmos.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cosmos, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90).isActive = true
        NSLayoutConstraint(item: cosmos, attribute: .leading, relatedBy: .equal, toItem: difficultyLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cosmos, attribute: .top, relatedBy: .equal, toItem: typeLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: cosmos, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        pitchesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pitchesLabel, attribute: .leading, relatedBy: .equal, toItem: difficultyLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .top, relatedBy: .equal, toItem: cosmos, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: pitchesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: pitchesLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutePhotoCVCell", for: indexPath) as? RoutePhotosCVC {
            ImageCache.shared.getImage(for: photoUrls[indexPath.row]) { image in
                DispatchQueue.main.async {
                    cell.bgImageView.image = image
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }

    override func layoutSubviews() {
        difficultyLabel.layer.cornerRadius = 5
        difficultyLabel.clipsToBounds = true
    }
}
