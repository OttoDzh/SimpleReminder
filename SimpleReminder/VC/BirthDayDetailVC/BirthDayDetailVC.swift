//
//  BirthDayDetailVC.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 15.04.2023.
//

import UIKit
import MessageUI

protocol Deleteperson {
    func deletePerson(index:Int)
}
protocol ReloadDelegate {
    func updateView()
}

class BirthDayDetailVC: UIViewController {
    
    let birthdayDetailView = BirthdayDetailVCView()
    var delegate: Deleteperson?
    var updateDelegate: ReloadDelegate?
    var person: Person
    var index: Int = 0
    let notificationCenter = UNUserNotificationCenter.current()
    
    init(person:Person,index:Int) {
        self.person = person
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = birthdayDetailView
        addTargets()
        getPersonView()
    }
    
    func addTargets() {
        birthdayDetailView.deleteButton.addTarget(self, action: #selector(deletPerson), for: .touchUpInside)
        birthdayDetailView.callButton.addTarget(self, action: #selector(callToPerson), for: .touchUpInside)
        birthdayDetailView.smsButton.addTarget(self, action: #selector(smsToPerson), for: .touchUpInside)
        birthdayDetailView.editButton.addTarget(self, action: #selector(editPerson), for: .touchUpInside)
        birthdayDetailView.dismissButton.addTarget(self, action: #selector(backButton), for: .touchUpInside)
    }
    
    @objc func backButton() {
            self.updateDelegate?.updateView()
            self.dismiss(animated: true)
    }
    
    @objc func editPerson() {
        let vc = CreatePersonVC(person: person)
        vc.personDelegate = self
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
    
    @objc func callToPerson() {
        guard person.phoneNumber != "" else {
                 let anotherAlert = UIAlertController(title: "", message: "This person has no phone number", preferredStyle: .alert)
                 let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                 anotherAlert.addAction(okAction)
                 self.present(anotherAlert, animated: true, completion: nil)
            return
        }
        let secPhoneNumber = person.phoneNumber
        let str = secPhoneNumber
        let stringWithoutDigit = (str.components(separatedBy: CharacterSet.punctuationCharacters)).joined(separator: "")
        let stringLast = (stringWithoutDigit.components(separatedBy: CharacterSet.whitespaces)).joined(separator: "")
                 if let url = URL(string: "tel://" + stringLast) {
                     if UIApplication.shared.canOpenURL(url) {
                         UIApplication.shared.open(url,
                                                   options: [:],
                                                   completionHandler: nil)
            }
        }
    }
    @objc func smsToPerson() {
        let body: String = "HAPPY FUCKING BIRTHDAY!"
        guard person.phoneNumber != "" else {
                 let anotherAlert = UIAlertController(title: "", message: "This person has no phone number", preferredStyle: .alert)
                 let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                 anotherAlert.addAction(okAction)
                 self.present(anotherAlert, animated: true, completion: nil)
            return
        }
        let secPhoneNumber = person.phoneNumber
        let str = secPhoneNumber
        let stringWithoutDigit = (str.components(separatedBy: CharacterSet.punctuationCharacters)).joined(separator: "")
        let stringLast = (stringWithoutDigit.components(separatedBy: CharacterSet.whitespaces)).joined(separator: "")
          
           if MFMessageComposeViewController.canSendText() {
               let controller = MFMessageComposeViewController()
               controller.body = body
               controller.recipients = [stringLast]
               controller.messageComposeDelegate = self
               present(controller, animated: true, completion: nil)
           } else {
               print("You can handle the method if your device cannot send SMS. For example, this is not available for the simulator.")
           }
    }
    
    func getPersonView() {
        birthdayDetailView.personImage.image = UIImage(data: person.personImage)
        birthdayDetailView.personName.text = person.name
        birthdayDetailView.birthDay.text = person.birthday
    }
    
    @objc func deletPerson() {
                let alertController = UIAlertController(title: "", message: "Would you like to permanently delete this reminder?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Delete", style: .destructive) {(action) in
                    
                    FirestoreService.shared.deletePerson(id: self.person.id) { result  in
                        switch result {
        
                        case .success(let id):
                            print("Person with \(id) deleted")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [self.person.name])
                    self.delegate?.deletePerson(index: self.index)
                    self.dismiss(animated: true)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) {(action) in
                }
                alertController.addAction(action)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
    }
    
}
extension BirthDayDetailVC: MFMessageComposeViewControllerDelegate {
     func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                       didFinishWith result: MessageComposeResult) {
         switch result {
         case .cancelled:
             print("Cancelled case")
         case .failed:
             print("failed case")
         case .sent:
             print("Sent case")
         default:
             break
         }
         controller.dismiss(animated: true)
     }
}

extension BirthDayDetailVC: personAfterEditDelegate {
    func getPersonAfterEditing(person: Person) {
        self.birthdayDetailView.personImage.image = UIImage(data: person.personImage)
        birthdayDetailView.personName.text = person.name
        birthdayDetailView.birthDay.text = person.birthday
        self.person = person
    }
    
    
}


