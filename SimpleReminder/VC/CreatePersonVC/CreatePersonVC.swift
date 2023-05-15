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

class CreatePersonVC: UIViewController, UITextFieldDelegate {
    
    let datePicker = UIDatePicker()
    let createPersonView = CreatePersonVCView()
    var delegate: AddPersonDelegate?
    var personDelegate: personAfterEditDelegate?
    var person: Person
    let notificationCenter = UNUserNotificationCenter.current()
    var buttonIsActive = false
    
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
        createPersonView.phoneNumberTF.delegate = self
        datePickerTf()
        addTargets()
        createPersonView.saveButton.isEnabled = false
        setupAddTargetIsNotEmptyTextFields()
        enteringView()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        animateLabelView()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        animateLabelView()
    }

    @objc func willEnterForeground() {
       animateLabelView()
    }
    
    
    func animateLabelView() {
        let operations = UIView.AnimationOptions.repeat
        let operationsback = UIView.AnimationOptions.autoreverse
        UIView.transition(with: self.createPersonView.viewForSwipe, duration: 1, options: operations, animations: {
            self.createPersonView.viewForSwipe.alpha = 1.0
            self.createPersonView.viewForSwipe.center.y = self.createPersonView.viewForSwipe.frame.maxY
        }, completion: nil)
        UIView.transition(with: self.createPersonView.viewForSwipeChevron, duration: 0.5, options: [operations,operationsback], animations: {
            self.createPersonView.viewForSwipeChevron.center.y = self.createPersonView.viewForSwipeChevron.frame.maxY
        }, completion: nil)
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"+0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func enteringView() {
        createPersonView.personNameTF.text = person.name
        createPersonView.personBirthday.text = person.birthday
        createPersonView.phoneNumberTF.text = person.phoneNumber
        if createPersonView.personNameTF.text != ""  {
            createPersonView.personImage.image = UIImage(data: person.personImage)
            createPersonView.saveButton.setTitleColor(.darkGray, for: .normal)
            createPersonView.addPhotoButton.setTitle("Edit photo", for: .normal)
            createPersonView.saveButton.isEnabled = false
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
        createPersonView.saveButton.setTitleColor(.gray, for: .normal)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard
            let name = createPersonView.personNameTF.text, !name.isEmpty,
            let birthday = createPersonView.personBirthday.text, !birthday.isEmpty
        else
        {
            self.createPersonView.saveButton.isEnabled = false
            createPersonView.saveButton.setTitleColor(.gray, for: .normal)
            return
        }
        createPersonView.saveButton.isEnabled = true
        createPersonView.saveButton.setTitleColor(.white, for: .normal)
    }
    
    func addTargets() {
        createPersonView.addPhotoButton.addTarget(self, action: #selector(imagePicker), for: .touchUpInside)
        createPersonView.saveButton.addTarget(self, action: #selector(savePerson), for: .touchUpInside)
    }
    
    @objc func savePerson() {
        if buttonIsActive == false {
            if person.name != "" {
                FirestoreService.shared.deletePerson(id: self.person.id) { result  in
                    switch result {
                        
                    case .success(let id):
                        print("Person with \(id) deleted")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [self.person.name])
            let resizedImaged = MonitorNetwork.resizeImage(image: createPersonView.personImage.image!, targetSize: CGSizeMake(500.0, 500.0))
            let dataImage = resizedImaged.pngData()
            let pngImage = UIImageView(image: UIImage(named: "maryImage"))
            let pngData = pngImage.image?.pngData()
            
            guard createPersonView.personNameTF.text != "" || createPersonView.personBirthday.text != ""  else {return}
            
            
            AuthService.shared.signUp { result in
                switch result {
                case .success(let user):
                    FirestoreService.shared.savePerson(id: UUID().uuidString,
                                                       name: self.createPersonView.personNameTF.text!,
                                                       birthday: self.createPersonView.personBirthday.text!,
                                                       personImage: dataImage ?? pngData!,
                                                       phoneNumber: self.createPersonView.phoneNumberTF.text!,
                                                       userId: user.uid) { result in
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
                            DispatchQueue.main.async {
                                ReminderService.setRemindBirthday(name: self.createPersonView.personNameTF.text!,dateMonth: month!,dateDay: day!,dateHour: hourComp.hour!)
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
                case .failure(let error):
                    print(error)
                }
                
            }
            buttonIsActive = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.buttonIsActive = false
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let deletePhotoAction = UIAlertAction(title: "Delete photo", style: .destructive) { _ in
            self.createPersonView.personImage.image = UIImage(named: "maryImage")
            self.createPersonView.saveButton.isEnabled = true
            self.createPersonView.saveButton.setTitleColor(.white, for: .normal)
        }
        alert.addAction(libraryMethod)
        alert.addAction(deletePhotoAction)
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
        createPersonView.saveButton.isEnabled = true
        createPersonView.saveButton.setTitleColor(.white, for: .normal)
        dismiss(animated: true)
    }
}
