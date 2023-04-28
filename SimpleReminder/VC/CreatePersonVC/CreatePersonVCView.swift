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
    let addPhotoButton = UIButton(title: "Add photo", bgColor: .lightGray, textColor: .black, font: ODFonts.avenirRoman, cornerRadius: 9)
    let saveButton = UIButton(title: "Save", bgColor: .gray, textColor: .lightGray, font: ODFonts.avenirRoman, cornerRadius: 9)
    let phoneNumberTF = UITextField(placeholder: "Phone")

    init() {
        super.init(frame: CGRect())
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        backgroundColor = .lightGray
        personImage.tintColor = .darkGray
        personNameTF.addBottomBorder(height: 1.0, color: .darkGray)
        personNameTF.backgroundColor = .clear
        phoneNumberTF.addBottomBorder(height: 1.0, color: .darkGray)
        phoneNumberTF.backgroundColor = .clear
        personBirthday.addBottomBorder(height: 1.0, color: .darkGray)
        personBirthday.backgroundColor = .clear
        personImage.layer.cornerRadius = 90
        personImage.clipsToBounds = true
        personImage.contentMode = .scaleAspectFill
        personNameTF.textColor = .darkGray
        phoneNumberTF.textColor = .darkGray
        personBirthday.textColor = .darkGray
    }
    func setupConstraints() {
        
        let stack = UIStackView(arrangedSubviews: [personNameTF,personBirthday,phoneNumberTF], axis: .vertical, spacing: 25)
        
        addSubview(personImage)
        addSubview(stack)
        addSubview(saveButton)
        addSubview(addPhotoButton)
        
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

