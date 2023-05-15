//
//  MainVC.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 25.03.2023.
//

import UIKit
import UserNotifications
import CoreData

class MainVC: UIViewController,UITextFieldDelegate {
    
    static let shared = MainVC()
    let userDefaults = UserDefaults.standard
    var remindsArray = [Remind]()
    let mainView = MainVCView()
    let notificationCenter = UNUserNotificationCenter.current()
    let pickerArray = ["None","Hourly","Daily","Weekly","Monthly","Yearly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        mainView.remindTF.delegate = self
        mainView.table.delegate = self
        mainView.table.dataSource = self
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { permissionGranted, error in
            if !permissionGranted {
                print("Permission denied")
            }
        }
        addTargets()
        FetchData.decode { remindArray in
            self.remindsArray = remindArray.sorted(by: {$0.remindDate.toDate()! < $1.remindDate.toDate()!})
        }
    }
    
    func addTargets() {
        mainView.addNewRemindButton.addTarget(self, action: #selector(notif), for: .touchUpInside)
    }
    
    func decodeDataFromUserDefaults() -> [Remind] {
        if let data = UserDefaults.standard.data(forKey: "reminds") {
            do {
                let decoder = JSONDecoder()
                let note = try decoder.decode([Remind].self, from: data)
                remindsArray = note
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return remindsArray
    }
    
    @objc func notif() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let title = self.mainView.remindTF.text!
                let date = self.mainView.datePicker.date
                if settings.authorizationStatus == .authorized {
                    ReminderService.setSimpleRemind(name: title, date: date)
                    if self.mainView.remindTF.text!.count >= 25 || self.mainView.remindTF.text!.count == 0  {
                        let alert = UIAlertController(title: "Ooops", message: "Fill in the field the maximum allowed number of letters is 25", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        let ac = UIAlertController(title: "Remind", message: "On " + self.formattedDate(date: date), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(ac, animated: true)
                        let newRemind = Remind(remind: self.mainView.remindTF.text!, remindDate: self.formattedDate(date: date))
                        self.remindsArray.append(newRemind)
                        FetchData.encodeData(array: self.remindsArray)
                        self.mainView.remindTF.text = ""
                        DispatchQueue.main.async {
                            self.remindsArray.sort(by: {$0.remindDate.toDate()! < $1.remindDate.toDate()!})
                            self.mainView.table.reloadData()
                        }
                    }
                } else {
                    let ac = UIAlertController(title: "Enable Notifications?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSetting = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                        else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsURL) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                    ac.addAction(goToSetting)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    func formattedDate(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func strikeText(strike : String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func strikeTexxt(strike : String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.patternDash.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
}

extension MainVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        let vc = RemindDetailVC(remind: self.remindsArray[indexPath.row],index: indexPathRow)
        vc.delegate = self
        vc.delegater = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        remindsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainView.table.dequeueReusableCell(withIdentifier: MyCell.reuseId, for: indexPath) as! MyCell
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        cell.backgroundColor = .clear
        cell.remindLabel.text = self.remindsArray[indexPath.row].remind
        cell.whenRemindLabel.text = self.remindsArray[indexPath.row].remindDate
        let secondDate = self.remindsArray[indexPath.row].remindDate
        let dateNew = secondDate.toDate()
        if dateNew! <= Date() {
            cell.remindLabel.textColor = .lightGray
            cell.whenRemindLabel.textColor = .lightGray
            cell.remindLabel.font = ODFonts.avenirLight
            cell.whenRemindLabel.font = ODFonts.avenirLight
            cell.bgImage.image = UIImage(named: "newBgCell")
            cell.remindLabel.attributedText = strikeText(strike: self.remindsArray[indexPath.row].remind)
            cell.whenRemindLabel.attributedText = strikeText(strike: self.remindsArray[indexPath.row].remindDate)
        } else {
            cell.remindLabel.textColor = .lightGray
            cell.whenRemindLabel.textColor = .lightGray
            cell.bgImage.image = UIImage(named: "newBgCell")
            cell.remindLabel.font = ODFonts.avenirRoman
            cell.whenRemindLabel.font = ODFonts.avenirRoman
            cell.remindLabel.attributedText = strikeTexxt(strike: self.remindsArray[indexPath.row].remind)
            cell.whenRemindLabel.attributedText = strikeTexxt(strike: self.remindsArray[indexPath.row].remindDate)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            var array = self.decodeDataFromUserDefaults()
            array.remove(at: indexPath.row)
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [self.remindsArray[indexPath.row].remind])
            self.remindsArray.sort(by: {$0.remindDate.toDate()! < $1.remindDate.toDate()!})
            self.remindsArray.remove(at: indexPath.row)
            FetchData.encodeData(array: self.remindsArray)
            DispatchQueue.main.async {
                FetchData.decode { remindArray in
                    self.remindsArray = remindArray
                }
                self.mainView.table.reloadData()
            }
        }
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 37.0, weight: .bold, scale: .large)
        contextAction.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.black)
        contextAction.title = "Delete"
        contextAction.backgroundColor = .black
        let config = UISwipeActionsConfiguration(actions: [contextAction])
        return config
    }
}

extension UIImage {
    func addBackgroundCircle(_ color: UIColor?) -> UIImage? {
        let circleDiameter = max(size.width * 1.3, size.height * 1.3)
        let circleRadius = circleDiameter * 0.5
        let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(x: circleRadius - (size.width * 0.5), y: circleRadius - (size.height * 0.5), width: size.width, height: size.height)
        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? .systemRed
        view.layer.cornerRadius = circleDiameter * 0.5
        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)
        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { ctx in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }
        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension MainVC: Reremind {
    func updateRemind(remindDate:String,remind:String,date:Date,index:Int) {
        ReminderService.setSimpleRemind(name: remind, date: date)
        self.remindsArray.remove(at: index)
        let newRemind = Remind(remind: remind, remindDate: remindDate)
        self.remindsArray.append(newRemind)
        FetchData.encodeData(array: self.remindsArray)
        DispatchQueue.main.async {
            self.remindsArray.sort(by:  {$0.remindDate.toDate()! < $1.remindDate.toDate()!})
            self.mainView.table.reloadData()
        }
    }
}

extension MainVC: Deleteremind {
    func deleteRemind(index: Int) {
        self.remindsArray.remove(at: index)
        FetchData.encodeData(array: self.remindsArray)
        DispatchQueue.main.async {
            self.remindsArray.sort(by:  {$0.remindDate.toDate()! < $1.remindDate.toDate()!})
            self.mainView.table.reloadData()
        }
    }
}
extension String {
    func toDate(format:String? = "dd-MM-yyyy HH:mm") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
