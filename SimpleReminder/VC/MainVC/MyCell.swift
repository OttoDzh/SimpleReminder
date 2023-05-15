//
//  MyCell.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 25.03.2023.
//

import UIKit
import SnapKit

class MyCell: UITableViewCell {
    
    static let reuseId = "MyCell"
    var bgImage = UIImageView(image: UIImage(named: "bgImage"))
    let remindLabel = UILabel(text: "Could be remind", font: ODFonts.avenirLight)
    let whenRemindLabel = UILabel(text: "26.03.2021 16:54", font: ODFonts.avenirLight)
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MyCell.reuseId)
        
        remindLabel.textColor = .black
        remindLabel.numberOfLines = 0
        whenRemindLabel.textColor = .black
        bgImage.layer.cornerRadius = 15
        bgImage.contentMode = .scaleAspectFill
        bgImage.clipsToBounds = true
        
        addSubview(bgImage)
        addSubview(remindLabel)
        addSubview(whenRemindLabel)
        
        bgImage.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-3)
            make.top.equalTo(3)
        }
        
        remindLabel.snp.makeConstraints { make in
            make.left.equalTo(6)
            make.centerY.equalTo(self)
            make.width.equalTo(self).inset(100)
        }
        
        whenRemindLabel.snp.makeConstraints { make in
            make.right.equalTo(-6)
            make.centerY.equalTo(self)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
