//
//  BirthDayVC.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 09.04.2023.
//

import UIKit
import Contacts
import ContactsUI

class BirthDayVC: UIViewController,CNContactPickerDelegate {
     
    let birthDayView = BirthDayVCView()
    var birthdayArray = [Person]()
    let notificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = birthDayView
        birthDayView.collection.delegate = self
        birthDayView.collection.dataSource = self
        addTargets()
        getPersons()
    }
    
    func addTargets() {
        birthDayView.addButton.addTarget(self, action: #selector(getContact), for: .touchUpInside)
    }
   
    @objc func getContact() {
        let alertController = UIAlertController(title: "", message: "Choose method", preferredStyle: .actionSheet)
        let addFromContactsAction = UIAlertAction(title: "Add From Contacts", style: .default) {(action) in
            let vc = CNContactPickerViewController()
            vc.delegate = self
            self.present(vc, animated: true)
        }
        let selfAddAction = UIAlertAction(title: "Add Manually", style: .default) {(action) in
            let vc = CreatePersonVC(person: Person(id: "",
                                                   name: "",
                                                   birthday: "",
                                                   personImage: Data(),
                                                   phoneNumber: ""))
            vc.delegate = self
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addFromContactsAction)
        alertController.addAction(selfAddAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
       
    }
    
    func getPersons() {
        FirestoreService.shared.getPersons { result in
            switch result  {
            case .success(let persons):
                self.birthdayArray = persons
                self.birthDayView.collection.reloadData()
            case .failure(_):
                print("error")
            }
        }
    }
}

extension BirthDayVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        birthdayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BirthdayCell.birthDayReusId, for: indexPath) as! BirthdayCell
       
        let sortedArray = self.birthdayArray.sorted(by: {$0.birthday < $1.birthday})
        birthdayArray = sortedArray
        
        cell.personNameLabel.text = birthdayArray[indexPath.row].name
        cell.personBirthdate.text = "\(birthdayArray[indexPath.row].birthday)"
        cell.personImageView.image = UIImage(data: birthdayArray[indexPath.row].personImage)
        return cell
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = BirthDayDetailVC(person: self.birthdayArray[indexPath.row],index: indexPath.row)
        vc.delegate = self
        vc.updateDelegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        if contact.birthday == nil || self.birthdayArray.contains(where: { person in
            contact.identifier == person.id

        }){
            self.dismiss(animated: true)
            let alertController = UIAlertController(title: "", message: "Fill in the contact's birthday field", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default) {(action) in
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
//            dismiss(animated: true)
//            let vc = CNContactViewController(for: contact)
//            vc.modalPresentationStyle = .formSheet
//            present(UINavigationController(rootViewController: vc), animated: true)
//           
           // return
            
        } else {
            
            let personNumberPhone = (contact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            let pngImage = UIImageView(image: UIImage(named: "maryImage"))
            let pngData = pngImage.image?.pngData()
            birthdayArray.append(Person(id: contact.identifier,
                                        name: "\(contact.givenName) \(contact.familyName)",
                                        birthday: formatter.string(from: contact.birthday?.date ?? Date()),
                                        personImage: contact.imageData ?? pngData!,
                                        phoneNumber: personNumberPhone!))

            FirestoreService.shared.savePerson(id: contact.identifier,
                                               name: "\(contact.givenName) \(contact.familyName)",
                                               birthday: formatter.string(from: contact.birthday?.date ?? Date()),
                                               personImage: contact.imageData ?? pngData!,
                                               phoneNumber: personNumberPhone!) { result in
                switch result {
                case .success(let person):
                    print(person)
                    self.notificationCenter.getNotificationSettings { settings in
                        DispatchQueue.main.async {
                            let title = "Birthday:\(person.name)"
                                let content = UNMutableNotificationContent()
                                content.title = title
                                content.sound = UNNotificationSound.defaultRingtone
                            var hourComp = DateComponents()
                            hourComp.hour = 9
                            let dateCompCheck = DateComponents(month: contact.birthday?.month, day: contact.birthday?.day, hour: hourComp.hour)
//                            let dateComp = Calendar.current.dateComponents([.month,.day,.hour], from: date!)
//                            print(dateComp)
                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompCheck, repeats: true)
                                let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
                                self.notificationCenter.add(request) { error in
                                    if error != nil {
                                        print("Error" + error.debugDescription)
                                        return
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    print("oshibka zapisi v bazu")
                }
            }
            birthDayView.collection.reloadData()
        }
    }
}

extension BirthDayVC: ReloadDelegate  {
    func updateView() {
        getPersons()
    }

}

extension BirthDayVC: Deleteperson {
    func deletePerson(index: Int) {
        self.birthdayArray.remove(at: index)
        DispatchQueue.main.async {
            self.birthDayView.collection.reloadData()
        }
    }
}
    
extension BirthDayVC: AddPersonDelegate {
        func reloadUI() {
            getPersons()
        }
    }

