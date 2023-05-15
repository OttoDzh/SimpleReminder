//
//  RemindDetailVC.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 02.04.2023.
//

import UIKit

protocol Reremind {
    func updateRemind(remindDate:String,remind:String,date:Date,index:Int)
}
protocol Deleteremind {
    func deleteRemind(index:Int)
}

class RemindDetailVC: UIViewController {
    
    let defaults = UserDefaults.standard
    let remindDetailView = RemindDetailVCView()
    var remind: Remind
    var index: Int = 0
    let notificationCenter = UNUserNotificationCenter.current()
    var delegate: Reremind?
    var delegater: Deleteremind?
    
    init(remind:Remind,index:Int) {
        self.remind = remind
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = remindDetailView
        addTargets()
        striker()
        remindDetailView.remindLabel.text = remind.remind
        remindDetailView.whenRemindLabel.text = remind.remindDate
    }
    
    func striker() {
        let dateNew = self.remind.remindDate.toDate()
        if dateNew! <= Date() {
            remindDetailView.remindLabel.attributedText = MainVC.shared.strikeText(strike: remindDetailView.remindLabel.text!)
            remindDetailView.whenRemindLabel.attributedText = MainVC.shared.strikeText(strike: remindDetailView.whenRemindLabel.text!)
            remindDetailView.reRemindButton.setTitle("Reremind", for: .normal)
        } else {
            remindDetailView.reRemindButton.setTitle("Save", for: .normal)
        }
    }
    
    func getNewDate() {
        let date = self.remindDetailView.datePicker.date
        let formatedDate = MainVC.shared.formattedDate(date: date)
        remindDetailView.whenRemindLabel.text = formatedDate
    }
    
    func addTargets() {
        remindDetailView.cancelButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        remindDetailView.deleteRemindButton.addTarget(self, action: #selector(deleteRemind), for: .touchUpInside)
        remindDetailView.reRemindButton.addTarget(self, action: #selector(reRemind), for: .touchUpInside)
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true)
    }
    
    @objc func deleteRemind() {
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [remind.remind])
        self.delegater?.deleteRemind(index: index)
        self.dismiss(animated: true)
        
    }
    
    @objc func reRemind() {
        guard remindDetailView.datePicker.date >= Date() else  {
            let alertController = UIAlertController(title: "Ooops", message: "Set new date", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default) {(action) in
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
            
            return
        }
            var array = MainVC.shared.decodeDataFromUserDefaults()
            array.sort(by:{$0.remindDate.toDate()! < $1.remindDate.toDate()!})
            array.remove(at: index)
           getNewDate()
           self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [remind.remind])
            self.delegate?.updateRemind(remindDate: remindDetailView.whenRemindLabel.text!,remind: remindDetailView.remindLabel.text!,date: remindDetailView.datePicker.date,index: index)
            self.dismiss(animated: true)
        }
        
    }
    
    

