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
    let bgView = UIView()
    let personImageView = UIImageView(image: UIImage(named: "maryImage"))
    let personNameLabel = UILabel(text: "Mary", font: ODFonts.avenirLight12)
    let personBirthdate = UILabel(text: "26.07.1989", font: ODFonts.avenirLight12)
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        personImageView.contentMode = .scaleAspectFill
        personImageView.layer.cornerRadius =  50
        personImageView.clipsToBounds = true
        personNameLabel.textColor = .black
        personNameLabel.numberOfLines = 3
        personNameLabel.textAlignment = .center
        personBirthdate.textColor = .black
        bgView.backgroundColor = .lightGray
        bgView.layer.cornerRadius = 30
    }
    func setupConstraints() {
        
        addSubview(bgView)
        addSubview(personImageView)
        addSubview(personNameLabel)
        addSubview(personBirthdate)
       
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        personImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        personNameLabel.snp.makeConstraints { make in
            make.top.equalTo(personImageView.snp.bottom).inset(-4)
            make.width.equalTo(personImageView.snp.width)
            make.centerX.equalToSuperview()
        }
        personBirthdate.snp.makeConstraints { make in
            make.top.equalTo(personNameLabel.snp.bottom).inset(-4)
            make.centerX.equalToSuperview()
        }
        
    }
    
}
