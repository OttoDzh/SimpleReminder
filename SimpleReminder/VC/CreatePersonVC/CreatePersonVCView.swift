//
//  CreatePersonVCView.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 13.04.2023.
//

import UIKit
import SnapKit

class CreatePersonVCView: UIView {
    
    let personImage = UIImageView(image: UIImage(named: "maryImage"))
    let personNameTF = UITextField(placeholder: "Name")
    let personBirthday = UITextField(placeholder: "Birthday")
    let id = ""
    let addPhotoButton = UIButton(title: "Add photo", bgColor: .black, textColor: .white, font: ODFonts.avenirRoman, cornerRadius: 9)
    let saveButton = UIButton(title: "Save", bgColor: .gray, textColor: .darkGray, font: ODFonts.avenirRoman, cornerRadius: 9)
    let phoneNumberTF = UITextField(placeholder: "Phone")
    let viewForSwipe = UIView()
    let viewForSwipeChevron = UIView()
    let swipeLabel = UILabel(text: "Swipe Down", font: ODFonts.titleLabelFont)
    let swipeDownImage = UIImageView(image: UIImage(systemName: "chevron.down"))

    init() {
        super.init(frame: CGRect())
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        backgroundColor = .black
        personImage.tintColor = .darkGray
        personImage.layer.borderColor = UIColor.lightGray.cgColor
        personImage.layer.borderWidth = 2
        personNameTF.addBottomBorder(height: 1.0, color: .lightGray)
        personNameTF.backgroundColor = .clear
        phoneNumberTF.addBottomBorder(height: 1.0, color: .lightGray)
        phoneNumberTF.backgroundColor = .clear
        personBirthday.addBottomBorder(height: 1.0, color: .lightGray)
        personBirthday.backgroundColor = .clear
        personImage.layer.cornerRadius = 90
        personImage.clipsToBounds = true
        personImage.contentMode = .scaleAspectFill
        personNameTF.textColor = .white
        phoneNumberTF.textColor = .white
        personBirthday.textColor = .white
        saveButton.backgroundColor = .lightGray
        saveButton.layer.cornerRadius = 15
        saveButton.tintColor = .white
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.masksToBounds = false
        swipeDownImage.tintColor = .white
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    func setupConstraints() {
        
        let stack = UIStackView(arrangedSubviews: [personNameTF,personBirthday,phoneNumberTF], axis: .vertical, spacing: 25)
        
        addSubview(personImage)
        addSubview(stack)
        addSubview(saveButton)
        addSubview(addPhotoButton)
        addSubview(viewForSwipe)
        viewForSwipe.addSubview(swipeLabel)
        addSubview(viewForSwipeChevron)
        viewForSwipeChevron.addSubview(swipeDownImage)
        
        personImage.snp.makeConstraints { make in
            make.top.equalTo(75)
            make.centerX.equalTo(self)
            make.width.equalTo(180)
            make.height.equalTo(180)
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(personImage.snp.bottom).inset(-48)
            make.left.equalTo(24)
            make.width.equalTo(150)
        }
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(stack.snp.bottom).inset(-32)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        addPhotoButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(personImage.snp.bottom).inset(-4)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }

        viewForSwipe.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.top.equalTo(saveButton.snp.bottom).inset(-72)
        }
        
        swipeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        viewForSwipeChevron.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(viewForSwipe.snp.bottom).inset(-12)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        swipeDownImage.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

