//
//  CreatePersonVC.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 13.04.2023.
//

import UIKit

protocol AddPersonDelegate {
    func reloadUI()
}
protocol personAfterEditDelegate {
    func getPersonAfterEditing(person:Person)
}

class CreatePersonVC: UIViewController {
    
    let datePicker = UIDatePicker()
    let createPersonView = CreatePersonVCView()
    var delegate: AddPersonDelegate?
    var personDelegate: personAfterEditDelegate?
    var person: Person
    let notificationCenter = UNUserNotificationCenter.current()
    
    init(person:Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = createPersonView
        
        datePickerTf()
        addTargets()
        createPersonView.saveButton.isEnabled = false
        setupAddTargetIsNotEmptyTextFields()
        enteringView()
    }
    
    func enteringView() {
        createPersonView.personNameTF.text = person.name
        createPersonView.personBirthday.text = person.birthday
        createPersonView.phoneNumberTF.text = person.phoneNumber
        if createPersonView.personNameTF.text != "" {
            createPersonView.personImage.image = UIImage(data: person.personImage)
            createPersonView.saveButton.setTitleColor(.darkGray, for: .normal)
            createPersonView.saveButton.isEnabled = true
            
        } else {
            createPersonView.personImage.image = UIImage(named: "maryImage")
        }
       
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        createPersonView.personNameTF.addTarget(self, action: #selector(textFieldsIsNotEmpty),for: .allEditingEvents)
        createPersonView.personBirthday.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .allEditingEvents)
        createPersonView.phoneNumberTF.addTarget(self, action: #selector(textFieldsIsNotEmpty),for: .allEditingEvents)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .allEditingEvents)
       }
    @objc func datePickerChanged() {
        guard createPersonView.personBirthday.text != ""  else {return}
        createPersonView.saveButton.setTitleColor(.blue, for: .normal)
    }
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard
            let name = createPersonView.personNameTF.text, !name.isEmpty,
            let birthday = createPersonView.personBirthday.text, !birthday.isEmpty
          else
        {
            self.createPersonView.saveButton.isEnabled = false
            createPersonView.saveButton.setTitleColor(.lightGray, for: .normal)
          return
        }
        createPersonView.saveButton.isEnabled = true
        createPersonView.saveButton.setTitleColor(.darkGray, for: .normal)
       }
    func addTargets() {
        createPersonView.addPhotoButton.addTarget(self, action: #selector(imagePicker), for: .touchUpInside)
        createPersonView.saveButton.addTarget(self, action: #selector(savePerson), for: .touchUpInside)
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @objc func savePerson() {
        if person.name != "" {
            FirestoreService.shared.deletePerson(id: self.person.id) { result  in
                 switch result {

                 case .success(let id):
                     print("Person with \(id) deleted")
                 case .failure(let error):
                     print(error.localizedDescription)
                 }
             }
     //        self.delegate?.deletePerson(index: self.index)
        }
        
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [self.person.name])
//        let image = createPersonView.personImage.image
        let image = resizeImage(image: createPersonView.personImage.image!, targetSize: CGSizeMake(500.0, 500.0))
        let dataImage = image.pngData()
        let pngImage = UIImageView(image: UIImage(named: "maryImage"))
        let pngData = pngImage.image?.pngData()

        guard createPersonView.personNameTF.text != "" || createPersonView.personBirthday.text != ""  else {return}
      
        FirestoreService.shared.savePerson(id: UUID().uuidString,
                                           name: createPersonView.personNameTF.text!,
                                           birthday: createPersonView.personBirthday.text!,
                                           personImage: dataImage ?? pngData!,
                                           phoneNumber: createPersonView.phoneNumberTF.text!) { result in
            switch result {
            case .success(let person):
                print(person)
                
                let date = self.datePicker.date
                let calendar = Calendar.current
                let componentsMonth = calendar.dateComponents([.month], from: date)
                let month = componentsMonth.month
                let componentsDay = calendar.dateComponents([.day], from: date)
                let day = componentsDay.day
                var hourComp = DateComponents()
                hourComp.hour = 9
   //             ReminderService.setRemind(name: self.createPersonView.personNameTF.text!,dateMonth: month!,dateDay: day!,dateHour: hourComp.hour!)
                
                self.notificationCenter.getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        let title = "Birthday:\(person.name)"
                            let content = UNMutableNotificationContent()
                            content.title = title
                            content.sound = UNNotificationSound.defaultRingtone
                        var hourComp = DateComponents()
                        hourComp.hour = 9
                        let dateCompCheck = DateComponents(month: month, day: day, hour: hourComp.hour)
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
        
                self.delegate?.reloadUI()
                self.personDelegate?.getPersonAfterEditing(person: person)
                self.dismiss(animated: true)
            case .failure(let error):
                print(error)
                print("oshibka zapisi v bazu dannyx")
                let alertController = UIAlertController(title: "", message: "Selected image too big size", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default) {(action) in
                }
                alertController.addAction(action)
                self.present(alertController, animated: true) 
            }
        }
    }
    
    func datePickerTf() {
        datePicker.preferredDatePickerStyle = .wheels
        createPersonView.personBirthday.inputView = datePicker
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.backgroundColor = .lightGray
        toolbar.barTintColor = .lightGray
        toolbar.tintColor = .darkGray
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        toolbar.setItems([cancelButton,flexSpace,doneButton], animated: true)
        createPersonView.personBirthday.inputAccessoryView = toolbar
    }
    
    @objc func doneAction() {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM"
        createPersonView.personBirthday.text = formater.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func cancelAction() {
        view.endEditing(true)
    }
    
    @objc func imagePicker() {
                let alert = UIAlertController(title: "Select image", message: "", preferredStyle: .actionSheet)
                let libraryMethod = UIAlertAction(title: "From library", style: .default) { [weak self] (_) in
                    self?.showImagePicker(method: .photoLibrary)
                }
                let cancel = UIAlertAction(title: "Cancel", style: .destructive)
                alert.addAction(libraryMethod)
                alert.addAction(cancel)
                self.present(alert,animated: true)
    }
    
    func showImagePicker(method:UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(method) else {
            print("Selected source not available")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = method
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true)
    }

}

extension CreatePersonVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        createPersonView.personImage.image = info[.editedImage] as? UIImage
        dismiss(animated: true)
    }
}
