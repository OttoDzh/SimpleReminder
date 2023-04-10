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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = birthDayView
        birthDayView.collection.delegate = self
        birthDayView.collection.dataSource = self
        addTargets()

    }
    
    func addTargets() {
        birthDayView.addButton.addTarget(self, action: #selector(getContact), for: .touchUpInside)
    }
   
    @objc func getContact() {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
}



extension BirthDayVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        birthdayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BirthdayCell.birthDayReusId, for: indexPath) as! BirthdayCell
        cell.personNameLabel.text = birthdayArray[indexPath.row].name
        cell.personBirthdate.text = "\(birthdayArray[indexPath.row].birthday)"
        cell.personImageView.image = birthdayArray[indexPath.row].personImage.image
        return cell
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        let pngImage = UIImageView(image: UIImage(named: "maryImage"))
        let pngData = pngImage.image?.pngData()
        birthdayArray.append(Person(id: contact.identifier,
                                    name: contact.givenName,
                                    birthday: formatter.string(from: contact.birthday!.date!),
                                    personImage: UIImageView(image: UIImage(data: contact.imageData ?? pngData!))))
                             
        birthDayView.collection.reloadData()
        
  
    }
    
    
}
