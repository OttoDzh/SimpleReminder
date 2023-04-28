//
//  MainVCView.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 25.03.2023.
//

import UIKit
import SnapKit


class MainVCView: UIView {
    
    let titleLabel = UILabel(text: "SimpleReminders", font: ODFonts.titleLabelFont)
    let remindLabel = UILabel(text: "What to remind?", font: ODFonts.boldTextFont)
    let remindTF = UITextField(placeholder: "")
    let whenLabel = UILabel(text: "When?", font: ODFonts.boldTextFont)
    let whenTF = UITextField(placeholder: "Here could be date, not tf")
    var datePicker = UIDatePicker()
    let addNewRemindButton = UIButton(title: "Save reminder", bgColor: .gray, textColor: .white, font: ODFonts.boldTextFont, cornerRadius: 12)
    let table = UITableView()
    init() {
        super.init(frame: CGRect())
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        remindTF.addBottomBorder(height: 1.0, color: .white)
        remindTF.backgroundColor = .clear
        backgroundColor = .black
        titleLabel.textColor = .white
        remindLabel.textColor = .white
        whenLabel.textColor = .white
        remindTF.textColor = .white
        remindTF.layer.cornerRadius = 6
        datePicker.setValue(UIColor.black, forKey: "textColor")
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
       // table.backgroundView = UIImageView(image: UIImage(named: "bwGrad"))
        table.backgroundColor = .black
        table.layer.cornerRadius = 15
        table.separatorStyle = .singleLine
        table.register(MyCell.self, forCellReuseIdentifier: MyCell.reuseId)
        
        addNewRemindButton.backgroundColor = .lightGray
        addNewRemindButton.layer.cornerRadius = 15
        addNewRemindButton.tintColor = .white

        addNewRemindButton.layer.borderWidth = 2
        addNewRemindButton.layer.borderColor = UIColor.white.cgColor

        addNewRemindButton.layer.masksToBounds = false
        
    }
    func setupConstraints() {
        let remindStack = UIStackView(arrangedSubviews: [remindLabel,remindTF], axis: .horizontal, spacing: 24)
        addSubview(titleLabel)
        addSubview(remindStack)
        addSubview(whenLabel)
        addSubview(datePicker)
        addSubview(addNewRemindButton)
        addSubview(table)
         
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(64)
            make.centerX.equalTo(self)
        }
        remindStack.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(titleLabel.snp.bottom).inset(-36)
        }
        remindTF.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(36)
        }
        whenLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(remindStack).inset(64)
        }
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(whenLabel).inset(36)
            make.centerX.equalToSuperview()
        }
        addNewRemindButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(datePicker.snp.bottom).inset(-24)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(addNewRemindButton.snp.bottom).inset(-24)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UITextField {
    internal func addBottomBorder(height: CGFloat = 1.0, color: UIColor = .darkGray) {
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderView)
        NSLayoutConstraint.activate(
            [
                borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.heightAnchor.constraint(equalToConstant: height)
            ]
        )
    }
}


