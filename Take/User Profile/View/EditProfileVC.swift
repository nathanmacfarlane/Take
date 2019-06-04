import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GMStepper
import MultiSlider
import UIKit
import Presentr

class EditProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User?
    let ageSlider = MultiSlider()
    var toggler: UISwitch!
    var trStepper: GMStepper!
    var tradStepper: GMStepper!
    var sportStepper: GMStepper!
    var bStepper: GMStepper!
    var info = [String]()
    var infoTableView: UITableView!
    var numGradeDict: [Double: Int] = [0: 0,
                               1: 1,
                               2: 2,
                               3: 3,
                               4: 4,
                               5: 5,
                               6: 6,
                               7: 7,
                               8: 8,
                               9: 9,
                               10: 10,
                               11: 10,
                               12: 10,
                               13: 10,
                               14: 11,
                               15: 11,
                               16: 11,
                               17: 11,
                               18: 12,
                               19: 12,
                               20: 12,
                               21: 12,
                               22: 13,
                               23: 13,
                               24: 13,
                               25: 13,
                               26: 14,
                               27: 14,
                               28: 14,
                               29: 14,
                               30: 15,
                               31: 15,
                               32: 15,
                               33: 15]
    var letterDict: [Double: String] = [0: "",
                                       1: "",
                                       2: "",
                                       3: "",
                                       4: "",
                                       5: "",
                                       6: "",
                                       7: "",
                                       8: "",
                                       9: "",
                                       10: "a",
                                       11: "b",
                                       12: "c",
                                       13: "d",
                                       14: "a",
                                       15: "b",
                                       16: "c",
                                       17: "d",
                                       18: "a",
                                       19: "b",
                                       20: "c",
                                       21: "d",
                                       22: "a",
                                       23: "b",
                                       24: "c",
                                       25: "d",
                                       26: "a",
                                       27: "b",
                                       28: "c",
                                       29: "d",
                                       30: "a",
                                       31: "b",
                                       32: "c",
                                       33: "d"]
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BluePrimaryDark")
        super.viewDidLoad()
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.infoTableView.reloadData()
    }
    
    @objc
    private func goLogout(sender: UIButton!) {
        try? Auth.auth().signOut()
        self.present(LoginVC(), animated: true, completion: nil)
    }
    
    @objc func backToProf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func toggledEdit() {
        if UISettings.shared.mode == .light {
            //UISettings.shared.mode = UISettings.shared.dark
            fatalError()
        }
        else {
            //UISettings.shared.mode = UISettings.shared.light
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: InfoEditCell = self.infoTableView.dequeueReusableCell(withIdentifier: "InfoEditCell") as? InfoEditCell else { print("yooooooo"); return InfoEditCell() }
        
        cell.infoLabel.text = self.info[indexPath.row]
        
        return cell
    }
    
    var seg: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Top Rope", "Sport", "Trad", "Boulder"])
        sc.tintColor = UISettings.shared.colorScheme.textSecondary
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChanges), for: .valueChanged)
        return sc
    }()
    
    @objc
    func updateProf() {
        
        guard let trG = numGradeDict[self.trStepper.value] else { return }
        guard let sportG = numGradeDict[self.sportStepper.value] else { return }
        guard let tradG = numGradeDict[self.tradStepper.value] else { return }
        let bG = Int(self.bStepper.value)
        
        guard let trLet = letterDict[self.trStepper.value] else { return }
        guard let sportLet = letterDict[self.sportStepper.value] else { return }
        guard let tradLet = letterDict[self.tradStepper.value] else { return }
        
        self.user?.trGrade = trG
        self.user?.sportGrade = sportG
        self.user?.tradGrade = tradG
        self.user?.boulderGrade = bG
        
        self.user?.trLetter = trLet
        self.user?.sportLetter = sportLet
        self.user?.tradLetter = tradLet
        self.user?.age = Int(self.ageSlider.value[0])
        
        Firestore.firestore().save(object: self.user, to: "users", with: self.user?.id ?? "error in updating profile", completion: nil)
//        let userViewModel = UserViewModel(user: user)
//        userViewModel.getProfilePhoto { image in
//            DispatchQueue.main.async {
//                self.profPic.setBackgroundImage(image, for: .normal)
//            }
//        }
        self.backToProf()
    }
    
    @objc
    func handleSegmentChanges() {
        if seg.selectedSegmentIndex == 0 { // tr
            trStepper.isHidden = false
            sportStepper.isHidden = true
            tradStepper.isHidden = true
            bStepper.isHidden = true
        }
        else if seg.selectedSegmentIndex == 1 { // sport
            trStepper.isHidden = true
            sportStepper.isHidden = false
            tradStepper.isHidden = true
            bStepper.isHidden = true
        }
        else if seg.selectedSegmentIndex == 2 { // trad
            trStepper.isHidden = true
            sportStepper.isHidden = true
            tradStepper.isHidden = false
            bStepper.isHidden = true
        }
        else if seg.selectedSegmentIndex == 3 { // boulder
            trStepper.isHidden = true
            sportStepper.isHidden = true
            tradStepper.isHidden = true
            bStepper.isHidden = false
        }
        
    }
    
    @objc
    func findIndex(target: String, arr: Array<String>) -> Int {
        var currentIndex = 0
        for i in arr {
            if i == target {
                break
            }
            currentIndex += 1
        }
        return currentIndex
    }
    
    @objc
    func hitAddPhotos() {
        // guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        let addpic = AddProfPicVC()
        addpic.user = user
        addpic.userId = self.user?.id
        let presenter = Presentr(presentationType: .fullScreen)
        self.customPresentViewController(presenter, viewController: addpic, animated: true)
        
    }
    
    func initViews() {
        
        guard let user = self.user else { return }
        
        toggler = UISwitch()
        toggler.addTarget(self, action: #selector(toggledEdit), for: .valueChanged)
        toggler.onTintColor = UISettings.shared.colorScheme.accent
        
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToProf))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Edit Profile"
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(goLogout))
        logoutButton.tintColor = UISettings.shared.colorScheme.accent
        self.navigationItem.rightBarButtonItem = logoutButton
        
        let updateButton = UIButton()
        updateButton.addTarget(self, action: #selector(updateProf), for: UIControl.Event.allTouchEvents)
        updateButton.setTitle("Update", for: .normal)
        updateButton.setTitleColor( .black, for: .normal)
        updateButton.backgroundColor = UISettings.shared.colorScheme.accent
        updateButton.layer.cornerRadius = 8
        
        let gArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10a", "10b", "10c", "10d", "11a", "11b",
                      "11c", "11d", "12a", "12b", "12c", "12d", "13a", "13b", "13c", "13d", "14a", "14b",
                      "14c", "14d", "15a", "15b", "15c", "15d"]
        
        trStepper = GMStepper()
        trStepper.minimumValue = 0
        trStepper.maximumValue = 33
        trStepper.stepValue = 1.0
        trStepper.items = gArray.map { "5.\($0)" }
        trStepper.buttonsBackgroundColor = UIColor(hex: "#888888")
        trStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        trStepper.value = Double(findIndex(target: "\(user.trGrade)" + user.trLetter, arr: gArray))
        
        sportStepper = GMStepper()
        sportStepper.minimumValue = 0
        sportStepper.maximumValue = 33
        sportStepper.stepValue = 1.0
        sportStepper.items = gArray.map { "5.\($0)" }
        sportStepper.buttonsBackgroundColor = UIColor(hex: "#888888")
        sportStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        sportStepper.value = Double(findIndex(target: "\(user.sportGrade)" + user.sportLetter, arr: gArray))
        sportStepper.isHidden = true
        
        tradStepper = GMStepper()
        tradStepper.minimumValue = 0
        tradStepper.maximumValue = 33
        tradStepper.stepValue = 1.0
        tradStepper.items = gArray.map { "5.\($0)" }
        tradStepper.buttonsBackgroundColor = UIColor(hex: "#888888")
        tradStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        tradStepper.value = Double(findIndex(target: "\(user.tradGrade)" + user.tradLetter, arr: gArray))
        tradStepper.isHidden = true
        
        bStepper = GMStepper()
        bStepper.minimumValue = 0
        bStepper.maximumValue = 15
        bStepper.stepValue = 1.0
        bStepper.items = Array(0...15).map { "V\($0)" }
        bStepper.buttonsBackgroundColor = UIColor(hex: "#888888")
        bStepper.labelBackgroundColor = UIColor(hex: "#4B4D50")
        bStepper.value = Double(user.boulderGrade)
        bStepper.isHidden = true
        
        let gradeLabel = UILabel()
        gradeLabel.text = "Edit Grades"
        gradeLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        gradeLabel.textAlignment = .center
        gradeLabel.textColor = UISettings.shared.colorScheme.textSecondary
        
        let picButton = UIButton()
        picButton.addTarget(self, action: #selector(hitAddPhotos), for: UIControl.Event.allTouchEvents)
        picButton.setTitle("Upload Photo", for: .normal)
        picButton.setTitleColor( UISettings.shared.colorScheme.backgroundCell, for: .normal)
        picButton.backgroundColor = UISettings.shared.colorScheme.complimentary
        picButton.layer.cornerRadius = 8
        
        self.infoTableView = UITableView()
        infoTableView.register(InfoEditCell.self, forCellReuseIdentifier: "InfoEditCell")
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.separatorStyle = .none
        infoTableView.backgroundColor = UISettings.shared.colorScheme.backgroundPrimary
        infoTableView.isHidden = false
        
//        ageSlider.minimumTrackTintColor = .green
//        ageSlider.maximumTrackTintColor = .red
//        ageSlider.thumbTintColor = .black
//        ageSlider.minimumValue = 18
//        ageSlider.maximumValue = 55
//        ageSlider.setValue(Float(user.age), animated: false)
//        ageSlider.isContinuous = false
        
        ageSlider.minimumValue = 18
        ageSlider.maximumValue = 55
        ageSlider.trackWidth = 5
        ageSlider.tintColor = UIColor(named: "PinkAccent")
        ageSlider.value = [CGFloat(user.age)]
        ageSlider.orientation = .horizontal
        ageSlider.outerTrackColor = UISettings.shared.colorScheme.textPrimary
        ageSlider.valueLabelPosition = .top
        ageSlider.valueLabels[0].textColor = UISettings.shared.colorScheme.complimentary
        ageSlider.valueLabels[0].font = UIFont(name: "Avenir", size: 16)
        ageSlider.thumbCount = 1
        ageSlider.snapStepSize = 1
        
        
        
//        ageSlider.lab
        
        view.addSubview(updateButton)
        view.addSubview(picButton)
        view.addSubview(seg)
        view.addSubview(gradeLabel)
        view.addSubview(trStepper)
        view.addSubview(sportStepper)
        view.addSubview(tradStepper)
        view.addSubview(bStepper)
//        view.addSubview(toggler)
        view.addSubview(infoTableView)
        view.addSubview(ageSlider)
        
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: gradeLabel, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: gradeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        seg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: seg, attribute: .leading , relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: seg, attribute: .top, relatedBy: .equal, toItem: gradeLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: seg, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: seg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40).isActive = true
        
        trStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: trStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: trStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        sportStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: sportStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sportStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: sportStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: sportStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        tradStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tradStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: tradStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: tradStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        bStepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bStepper, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bStepper, attribute: .top, relatedBy: .equal, toItem: seg, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: bStepper, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: bStepper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: updateButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: updateButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: updateButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/3, constant: 0).isActive = true
        NSLayoutConstraint(item: updateButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        picButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: picButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: picButton, attribute: .top, relatedBy: .equal, toItem: tradStepper, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: picButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/3, constant: 0).isActive = true
        NSLayoutConstraint(item: picButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        ageSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: ageSlider, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .top, relatedBy: .equal, toItem: picButton, attribute: .bottom, multiplier: 1, constant: 45).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: ageSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15).isActive = true
        
//        toggler.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: toggler, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: toggler, attribute: .top, relatedBy: .equal, toItem: picButton, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
//        NSLayoutConstraint(item: toggler, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/4, constant: 0).isActive = true
//        NSLayoutConstraint(item: toggler, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoTableView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoTableView, attribute: .top, relatedBy: .equal, toItem: ageSlider, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: infoTableView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoTableView, attribute: .bottom, relatedBy: .equal, toItem: updateButton, attribute: .top, multiplier: 1, constant: -10).isActive = true
        
        
    
    }
    
}


class InfoEditCell: UITableViewCell {
    
    var infoLabel = UILabel()
    let container = UIView()
    var indent = CGFloat(100)
    var infoPic = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = UIColor(named: "BluePrimaryDark")
        
        infoLabel.textColor = UISettings.shared.colorScheme.textPrimary
        infoLabel.font = UIFont(name: "Avenir-Heavy", size: 18)
        infoLabel.textAlignment = .left
        
        
        container.backgroundColor = UISettings.shared.colorScheme.backgroundCell
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 8
        
        infoPic.contentMode = .scaleAspectFill
        
        addSubview(container)
        addSubview(infoLabel)
        addSubview(infoPic)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 8/9, constant: 0).isActive = true
        
        infoPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: infoPic, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: infoPic, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoPic, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: infoPic, attribute: .width, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.leadingAnchor.constraint(equalTo: infoPic.trailingAnchor, constant: 10).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1).isActive = true
        infoLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1/3).isActive = true
    }
    
}
