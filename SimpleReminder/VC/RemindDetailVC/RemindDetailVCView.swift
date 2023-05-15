//
//  RemindDetailVCView.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 02.04.2023.
//

import UIKit
import SnapKit

class RemindDetailVCView: UIView {
    
    let bgImage = UIImageView(image: UIImage(named: "newBgCell"))
    let remindView = UIImageView(image: UIImage(named: "newBgCell"))
    let remindLabel = UILabel(text: "Could be remind", font: ODFonts.avenirFont)
    let whenRemindLabel = UILabel(text: "Could be when remind", font: ODFonts.avenirFont)
    let reRemindButton = UIButton(title: "", bgColor: .white, textColor: .black, font: ODFonts.titleLabelFont, cornerRadius: 12)
    let deleteRemindButton = UIButton(title: "Delete", bgColor: .white, textColor: .black, font: ODFonts.titleLabelFont, cornerRadius: 12)
    let cancelButton = UIButton(title: "Back", bgColor: .white, textColor: .black, font: ODFonts.titleLabelFont, cornerRadius: 12)
    let setNewDateLabel = UILabel(text: "Set new date", font: ODFonts.avenirRoman)
    var datePicker = UIDatePicker()
    
    init() {
        super.init(frame: CGRect())
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .white
        bgImage.contentMode = .scaleAspectFill
        remindView.layer.cornerRadius = 12
        remindView.clipsToBounds = true
        remindLabel.textColor = .white
        remindLabel.numberOfLines = 0
        whenRemindLabel.numberOfLines = 0
        whenRemindLabel.textColor = .white
        setNewDateLabel.textColor = .white
        setNewDateLabel.numberOfLines = 0
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        
        let arrayButons = [reRemindButton,deleteRemindButton,cancelButton]
        
        for buttons in arrayButons {
            buttons.backgroundColor = .lightGray
            buttons.layer.cornerRadius = 12
            buttons.tintColor = .white
            buttons.layer.shadowOpacity = 2
            buttons.layer.shadowColor = UIColor.darkGray.cgColor
            buttons.layer.borderWidth = 2
            buttons.layer.borderColor = UIColor.white.cgColor
            buttons.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            buttons.layer.shadowRadius = 3.0
            buttons.layer.masksToBounds = false
        }
    }
    
    func setupConstraints() {
        let remindStack = UIStackView(arrangedSubviews: [remindLabel,whenRemindLabel], axis: .vertical, spacing: 12)
        let buttonStack = UIStackView(arrangedSubviews: [reRemindButton,deleteRemindButton,cancelButton], axis: .vertical, spacing: 6)
        
        addSubview(bgImage)
        addSubview(remindView)
        addSubview(remindStack)
        addSubview(setNewDateLabel)
        addSubview(buttonStack)
        addSubview(datePicker)
        
        bgImage.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(0)
        }
        remindView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(400)
            make.center.equalToSuperview()
        }
        remindStack.snp.makeConstraints { make in
            make.top.equalTo(remindView).inset(48)
            make.centerX.equalTo(self)
        }
        
        setNewDateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(datePicker.snp.top).inset(-12)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.bottom.equalTo(remindView).inset(12)
            make.centerX.equalTo(self)
            make.width.equalTo(250)
        }
        datePicker.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStack.snp.top).inset(-12)
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
