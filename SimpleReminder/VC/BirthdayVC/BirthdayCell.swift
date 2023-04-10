//
//  BirthdayCell.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 09.04.2023.
//

import UIKit
import SnapKit

class BirthdayCell: UICollectionViewCell {
    
    static let birthDayReusId = "BirthdayCell"
    let personImageView = UIImageView(image: UIImage(named: "maryImage"))
    let personNameLabel = UILabel(text: "Mary", font: ODFonts.avenirLight)
    let personBirthdate = UILabel(text: "26.07.1989", font: ODFonts.avenirLight)
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        personImageView.contentMode = .scaleAspectFit
        personImageView.layer.cornerRadius = 60
        personImageView.clipsToBounds = true
        personNameLabel.textColor = .black
        personBirthdate.textColor = .black
    }
    func setupConstraints() {
        
        let stack = UIStackView(arrangedSubviews: [personNameLabel,personBirthdate], axis: .horizontal, spacing: 6)
        
        addSubview(personImageView)
        addSubview(stack)
        
        
        personImageView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-30)
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(personImageView.snp.bottom).inset(-4)
            make.centerX.equalToSuperview()

        }
        
    }
    
}
