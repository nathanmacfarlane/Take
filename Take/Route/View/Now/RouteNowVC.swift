import Firebase
import UIKit

class RouteNowVC: UIViewController {

    var routeViewModel: RouteViewModel!
    var weatherIconImageView: UIImageView!
    var cityLabel: UILabel!
    var stateLabel: UILabel!
    var latAndLongLabel: UILabel!
    var windValueLabel: UILabel!
    var tempValueLabel: UILabel!
    var sunsetValueLabel: UILabel!
    var windTypeLabel: UILabel!
    var tempTypeLabel: UILabel!
    var sunsetTypeLabel: UILabel!
    var closuresDetailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()

        routeViewModel.getCurrentWeather { weatherViewModel in
            DispatchQueue.main.async {
                self.tempValueLabel.text = "\(Int(weatherViewModel.temperature))"
                self.windValueLabel.text = "\(Int(weatherViewModel.windSpeed))"
                self.sunsetValueLabel.text = weatherViewModel.sunsetStrings.0
                self.sunsetTypeLabel.text = weatherViewModel.sunsetStrings.1
                self.weatherIconImageView.image = weatherViewModel.weatherIcon
            }
        }

        routeViewModel.cityAndState { city, state in
            DispatchQueue.main.async {
                self.stateLabel.text = state
                self.cityLabel.text = city
            }
        }

        weatherIconImageView.image = UIImage()
        latAndLongLabel.text = routeViewModel.latAndLongString
        sunsetValueLabel.text = ""
        windTypeLabel.text = "MPH"
        tempTypeLabel.text = "°F"
        sunsetTypeLabel.text = "PM"

    }

    func initViews() {
        self.view.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary

        let weatherViewBG = UILabel()
        weatherViewBG.backgroundColor = UISettings.shared.mode == .dark ? UIColor(hex: "#333741") : UIColor(hex: "#CCCED1")
        weatherViewBG.layer.cornerRadius = 15
        weatherViewBG.clipsToBounds = true

        let imageBg = UILabel()
        imageBg.backgroundColor = UISettings.shared.colorScheme.backgroundDarker
        imageBg.layer.cornerRadius = 40
        imageBg.clipsToBounds = true

        weatherIconImageView = UIImageView()

        cityLabel = LabelAvenir(size: 24, type: .Black, alignment: .center)
        stateLabel = LabelAvenir(size: 12, type: .Black, alignment: .center)

        let txtColor = UISettings.shared.mode == .dark ? UIColor(hex: "#202226") : UIColor(hex: "#727479")
        latAndLongLabel = LabelAvenir(size: 18, type: .Black, color: txtColor, alignment: .center)

        let windIconImageView = UIImageView()
        windIconImageView.image = UIImage(named: "icon_wind\(UISettings.shared.mode == .dark ? "" : "_blue")")

        let tempIconImageView = UIImageView()
        tempIconImageView.image = UIImage(named: "icon_temp\(UISettings.shared.mode == .dark ? "" : "_blue")")

        let sunsetIconImageView = UIImageView()
        sunsetIconImageView.image = UIImage(named: "icon_sunset\(UISettings.shared.mode == .dark ? "" : "_blue")")

        let txtValCol = UISettings.shared.mode == .dark ? UISettings.shared.colorScheme.backgroundPrimary : UIColor(hex: "#424446")
        windValueLabel = LabelAvenir(size: 42, type: .Black, color: txtValCol, alignment: .center)
        tempValueLabel = LabelAvenir(size: 42, type: .Black, color: txtValCol, alignment: .center)
        sunsetValueLabel = LabelAvenir(size: 42, type: .Black, color: txtValCol, alignment: .center)

        let txtTypeCol = UISettings.shared.mode == .dark ? UISettings.shared.colorScheme.textPrimary : UISettings.shared.colorScheme.accent
        windTypeLabel = LabelAvenir(size: 20, type: .Black, color: txtTypeCol, alignment: .center)
        tempTypeLabel = LabelAvenir(size: 20, type: .Black, color: txtTypeCol, alignment: .center)
        sunsetTypeLabel = LabelAvenir(size: 20, type: .Black, color: txtTypeCol, alignment: .center)

        view.addSubview(weatherViewBG)
        view.addSubview(imageBg)
        view.addSubview(weatherIconImageView)
        view.addSubview(cityLabel)
        view.addSubview(stateLabel)
        view.addSubview(latAndLongLabel)
        view.addSubview(windIconImageView)
        view.addSubview(sunsetIconImageView)
        view.addSubview(tempIconImageView)
        view.addSubview(windValueLabel)
        view.addSubview(tempValueLabel)
        view.addSubview(sunsetValueLabel)
        view.addSubview(windTypeLabel)
        view.addSubview(tempTypeLabel)
        view.addSubview(sunsetTypeLabel)

        weatherViewBG.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: weatherViewBG, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: weatherViewBG, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        if routeViewModel.closureInfo != nil {
            NSLayoutConstraint(item: weatherViewBG, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        } else {
            NSLayoutConstraint(item: weatherViewBG, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        }
        NSLayoutConstraint(item: weatherViewBG, attribute: .bottom, relatedBy: .equal, toItem: tempTypeLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true

        imageBg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageBg, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageBg, attribute: .top, relatedBy: .equal, toItem: weatherViewBG, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: imageBg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: imageBg, attribute: .width, relatedBy: .equal, toItem: imageBg, attribute: .height, multiplier: 1, constant: 1).isActive = true

        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: weatherIconImageView, attribute: .leading, relatedBy: .equal, toItem: imageBg, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: weatherIconImageView, attribute: .trailing, relatedBy: .equal, toItem: imageBg, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: weatherIconImageView, attribute: .top, relatedBy: .equal, toItem: imageBg, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: weatherIconImageView, attribute: .bottom, relatedBy: .equal, toItem: imageBg, attribute: .bottom, multiplier: 1, constant: -10).isActive = true

        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cityLabel, attribute: .leading, relatedBy: .equal, toItem: weatherViewBG, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cityLabel, attribute: .trailing, relatedBy: .equal, toItem: weatherViewBG, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: cityLabel, attribute: .top, relatedBy: .equal, toItem: imageBg, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: cityLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true

        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: stateLabel, attribute: .leading, relatedBy: .equal, toItem: weatherViewBG, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: stateLabel, attribute: .trailing, relatedBy: .equal, toItem: weatherViewBG, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: stateLabel, attribute: .top, relatedBy: .equal, toItem: cityLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: stateLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true

        latAndLongLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: latAndLongLabel, attribute: .leading, relatedBy: .equal, toItem: weatherViewBG, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: latAndLongLabel, attribute: .trailing, relatedBy: .equal, toItem: weatherViewBG, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: latAndLongLabel, attribute: .top, relatedBy: .equal, toItem: stateLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: latAndLongLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        // three weather icons
        windIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: windIconImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 2 / 5, constant: 0).isActive = true
        NSLayoutConstraint(item: windIconImageView, attribute: .top, relatedBy: .equal, toItem: latAndLongLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: windIconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: windIconImageView, attribute: .width, relatedBy: .equal, toItem: windIconImageView, attribute: .height, multiplier: 1, constant: 1).isActive = true

        tempIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tempIconImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tempIconImageView, attribute: .top, relatedBy: .equal, toItem: latAndLongLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tempIconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: tempIconImageView, attribute: .width, relatedBy: .equal, toItem: tempIconImageView, attribute: .height, multiplier: 1, constant: 1).isActive = true

        sunsetIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sunsetIconImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 8 / 5, constant: 0).isActive = true
        NSLayoutConstraint(item: sunsetIconImageView, attribute: .top, relatedBy: .equal, toItem: latAndLongLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: sunsetIconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: sunsetIconImageView, attribute: .width, relatedBy: .equal, toItem: sunsetIconImageView, attribute: .height, multiplier: 1, constant: 1).isActive = true

        windValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: windValueLabel, attribute: .leading, relatedBy: .equal, toItem: windIconImageView, attribute: .leading, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: windValueLabel, attribute: .trailing, relatedBy: .equal, toItem: windIconImageView, attribute: .trailing, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: windValueLabel, attribute: .top, relatedBy: .equal, toItem: windIconImageView, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: windValueLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 55).isActive = true

        tempValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tempValueLabel, attribute: .leading, relatedBy: .equal, toItem: tempIconImageView, attribute: .leading, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: tempValueLabel, attribute: .trailing, relatedBy: .equal, toItem: tempIconImageView, attribute: .trailing, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: tempValueLabel, attribute: .top, relatedBy: .equal, toItem: tempIconImageView, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: tempValueLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 55).isActive = true

        sunsetValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sunsetValueLabel, attribute: .leading, relatedBy: .equal, toItem: sunsetIconImageView, attribute: .leading, multiplier: 1, constant: -30).isActive = true
        NSLayoutConstraint(item: sunsetValueLabel, attribute: .trailing, relatedBy: .equal, toItem: sunsetIconImageView, attribute: .trailing, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: sunsetValueLabel, attribute: .top, relatedBy: .equal, toItem: sunsetIconImageView, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: sunsetValueLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 55).isActive = true

        windTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: windTypeLabel, attribute: .leading, relatedBy: .equal, toItem: windValueLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: windTypeLabel, attribute: .trailing, relatedBy: .equal, toItem: windValueLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: windTypeLabel, attribute: .top, relatedBy: .equal, toItem: windValueLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: windTypeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        tempTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tempTypeLabel, attribute: .leading, relatedBy: .equal, toItem: tempValueLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tempTypeLabel, attribute: .trailing, relatedBy: .equal, toItem: tempValueLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tempTypeLabel, attribute: .top, relatedBy: .equal, toItem: tempValueLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: tempTypeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        sunsetTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sunsetTypeLabel, attribute: .leading, relatedBy: .equal, toItem: sunsetValueLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sunsetTypeLabel, attribute: .trailing, relatedBy: .equal, toItem: sunsetValueLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sunsetTypeLabel, attribute: .top, relatedBy: .equal, toItem: sunsetValueLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: sunsetTypeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        if let closureInfo = routeViewModel.closureInfo {

            let closuresViewBG = UILabel()
            closuresViewBG.backgroundColor = UISettings.shared.mode == .dark ? UIColor(hex: "#333741") : UIColor(hex: "#CCCED1")
            closuresViewBG.layer.cornerRadius = 15
            closuresViewBG.clipsToBounds = true

            closuresDetailLabel = UILabel()
            closuresDetailLabel.textColor = UISettings.shared.colorScheme.textPrimary
            closuresDetailLabel.font = UIFont(name: "Avenir-Book", size: 16)
            closuresDetailLabel.numberOfLines = 0
            closuresDetailLabel.textAlignment = .left
            closuresDetailLabel.text = closureInfo

            view.addSubview(closuresViewBG)
            view.addSubview(closuresDetailLabel)

            closuresViewBG.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: closuresViewBG, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
            NSLayoutConstraint(item: closuresViewBG, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
            NSLayoutConstraint(item: closuresViewBG, attribute: .top, relatedBy: .equal, toItem: weatherViewBG, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
            NSLayoutConstraint(item: closuresViewBG, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true

            closuresDetailLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: closuresDetailLabel, attribute: .leading, relatedBy: .equal, toItem: closuresViewBG, attribute: .leading, multiplier: 1, constant: 10).isActive = true
            NSLayoutConstraint(item: closuresDetailLabel, attribute: .trailing, relatedBy: .equal, toItem: closuresViewBG, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
            NSLayoutConstraint(item: closuresDetailLabel, attribute: .top, relatedBy: .equal, toItem: closuresViewBG, attribute: .top, multiplier: 1, constant: 10).isActive = true
            NSLayoutConstraint(item: closuresDetailLabel, attribute: .bottom, relatedBy: .equal, toItem: closuresViewBG, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        }
    }

}
