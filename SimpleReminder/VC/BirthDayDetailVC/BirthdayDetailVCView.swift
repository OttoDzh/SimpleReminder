//
//  BirthdayDetailVCView.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 15.04.2023.
//

import UIKit
import SnapKit

class BirthdayDetailVCView: UIView {
    
    let personImage = UIImageView()
    let personName = UILabel(text: "Here could be name", font: ODFonts.titleLabelFont)
    let birthDay = UILabel(text: "BirthdayDate", font: ODFonts.titleLabelFont)
    let smsButton = UIButton()
    let callButton = UIButton()
//    let deleteButton = UIButton(title: "Delete", bgColor: .clear, textColor: .blue, font: ODFonts.titleLabelFont, cornerRadius: 15)
    let deleteButton = UIButton()
//    let editButton = UIButton(title: "Edit", bgColor: .clear, textColor: .blue, font: ODFonts.titleLabelFont, cornerRadius: 15)
    let editButton = UIButton()
//    let dismissButton = UIButton(title: "Back", bgColor: .clear, textColor: .blue, font: ODFonts.titleLabelFont, cornerRadius: 15)
    let dismissButton = UIButton()
    init() {
        super.init(frame: CGRect())
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .gray
        personImage.contentMode = .scaleAspectFill
        personImage.clipsToBounds = true
        personImage.layer.cornerRadius = 185
        personImage.layer.borderWidth = 2
        personImage.layer.borderColor = UIColor.white.cgColor
        
        let arrayButonns = [dismissButton,editButton,deleteButton,smsButton,callButton]
        editButton.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
        dismissButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        deleteButton.setImage(UIImage(systemName: "clear"), for: .normal)
        smsButton.setImage(UIImage(systemName: "ellipsis.message"), for: .normal)
        callButton.setImage(UIImage(systemName: "phone.connection"),for: .normal)
        
        for buttons in arrayButonns {
            buttons.backgroundColor = .lightGray
            buttons.layer.cornerRadius = 25
            buttons.tintColor = .white
            buttons.layer.shadowOpacity = 2
            buttons.layer.shadowColor = UIColor.white.cgColor
            buttons.layer.borderWidth = 2
            buttons.layer.borderColor = UIColor.white.cgColor
            buttons.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            buttons.layer.shadowRadius = 3.0
            buttons.layer.masksToBounds = false
        }
        personName.textColor = .darkGray
        birthDay.textColor = .darkGray
    }
    
    func setupConstraints() {
        addSubview(personImage)
        addSubview(deleteButton)
        addSubview(smsButton)
        addSubview(callButton)
        addSubview(editButton)
        addSubview(dismissButton)
        addSubview(birthDay)
        addSubview(personName)
        
        personImage.snp.makeConstraints { make in
            make.width.equalTo(370)
            make.height.equalTo(370)
            make.center.equalToSuperview()
        }
        
        birthDay.snp.makeConstraints { make in
            make.top.equalTo(personImage.snp.bottom).inset(-12)
            make.centerX.equalTo(self)
        }
        
        personName.snp.makeConstraints { make in
            make.bottom.equalTo(personImage.snp.top).inset(-12)
            make.centerX.equalTo(self)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(-24)
            make.top.equalTo(64)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        smsButton.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.bottom.equalTo(snp.bottom).inset(48)
            make.width.height.equalTo(50)
        }
        callButton.snp.makeConstraints { make in
            make.right.equalTo(-24)
            make.bottom.equalTo(snp.bottom).inset(48)
            make.width.height.equalTo(50)
        }
        
        
        editButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(64)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        dismissButton.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(64)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
