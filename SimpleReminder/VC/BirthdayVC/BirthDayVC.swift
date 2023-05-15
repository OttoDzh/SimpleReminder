//
//  BirthDayVC.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 09.04.2023.
//

import UIKit
import Contacts
import ContactsUI
import Network


class BirthDayVC: UIViewController,CNContactPickerDelegate {
    
    let birthDayView = BirthDayVCView()
    var birthdayArray = [Person]()
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = birthDayView
        self.networkMonitoring()
        birthDayView.collection.delegate = self
        birthDayView.collection.dataSource = self
        addTargets()
        getPersons()
    }
    
    func addTargets() {
        birthDayView.addButton.addTarget(self, action: #selector(getContact), for: .touchUpInside)
    }
    
    fileprivate func networkMonitoring() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "monitoring")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                switch path.status {
                case .satisfied:
                    self.birthDayView.isHidden = false
                case .unsatisfied:
                    self.birthDayView.isHidden = true
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), flags: .noQoS) {
                        let alertController = UIAlertController(title: "Error!", message: "No Internet Connection", preferredStyle: .alert)
                        alertController.view.backgroundColor = .red
                        alertController.view.layer.cornerRadius = 9
                        let action = UIAlertAction(title: "Ок", style: .cancel) {(action) in
                        }
                        alertController.addAction(action)
                        self.present(alertController, animated: true)
                    }
                case .requiresConnection:
                    print("May be activated")
                @unknown default:  fatalError()
                }
            }
        }
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
                                                   phoneNumber: "",
                                                   userId: ""))
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
        self.birthDayView.activityIndicator.startAnimating()
        self.birthDayView.collection.isHidden = true
        FirestoreService.shared.getPersons { result in
            switch result  {
            case .success(let persons):
                self.birthdayArray = persons
                self.birthDayView.collection.reloadData()
                self.birthDayView.collection.isHidden = false
                self.birthDayView.activityIndicator.stopAnimating()
                self.birthDayView.activityIndicator.hidesWhenStopped = true
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
        let sorted = birthdayArray.sorted(by: {$0.birthday.prefix(2) < $1.birthday.prefix(2)}).sorted(by: {$0.birthday.suffix(2) < $1.birthday.suffix(2)})
        birthdayArray = sorted
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
        if contact.birthday == nil {
            self.dismiss(animated: true)
            let alertController = UIAlertController(title: "", message: "Fill in the contact's birthday field", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default) {(action) in
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
        } else if self.birthdayArray.contains(where: { person in
            contact.identifier == person.id
        }) {
            self.dismiss(animated: true)
            let alertController = UIAlertController(title: "", message: "This person alreay has reminder", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default) {(action) in
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
        } else {
            let personNumberPhone = (contact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            let pngImage = UIImageView(image: UIImage(named: "maryImage"))
            let pngData = pngImage.image?.pngData()
            let resizedImaged = MonitorNetwork.resizeImage(image: UIImage(data: contact.imageData ?? pngData!)!, targetSize: CGSizeMake(500.0, 500.0))
            let resizedImagedData = resizedImaged.pngData()
            AuthService().signUp { result in
                switch result {
                case .success(let user):
                    self.birthdayArray.append(Person(id: contact.identifier,
                                                     name: "\(contact.givenName) \(contact.familyName)",
                                                     birthday: formatter.string(from: contact.birthday?.date ?? Date()),
                                                     personImage: resizedImagedData ?? pngData!,
                                                     phoneNumber: personNumberPhone!,
                                                     userId: user.uid))
                    
                    FirestoreService.shared.savePerson(id: contact.identifier,
                                                       name: "\(contact.givenName) \(contact.familyName)",
                                                       birthday: formatter.string(from: contact.birthday?.date ?? Date()),
                                                       personImage: resizedImagedData ?? pngData!,
                                                       phoneNumber: personNumberPhone!,
                                                       userId: user.uid) { result in
                        switch result {
                        case .success(let person):
                            print(person)
                            DispatchQueue.main.async {
                                var hourComp = DateComponents()
                                hourComp.hour = 9
                                ReminderService.setRemindBirthday(name: person.name, dateMonth: (contact.birthday?.month)!, dateDay: (contact.birthday?.day)!, dateHour: hourComp.hour!)
                            }
                        case .failure(let error):
                            print(error)
                            print("oshibka zapisi v bazu")
                        }
                        DispatchQueue.main.async {
                            self.birthDayView.collection.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
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

extension String {
    func toSdDate(format:String? = "dd.MM") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
