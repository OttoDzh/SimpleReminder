//
//  BirthDayVCView.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 09.04.2023.
//

import UIKit
import SnapKit

class BirthDayVCView: UIView {
    
    var collection: UICollectionView!
    let addButton = UIButton(title: "Add", bgColor: .blue, textColor: .white, font: ODFonts.avenirRoman, cornerRadius: 12)
    
    init() {
        super.init(frame: CGRect())
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .white
        collection = UICollectionView(frame: CGRect(), collectionViewLayout: createCompositionalLayout())
        collection.register(BirthdayCell.self, forCellWithReuseIdentifier: BirthdayCell.birthDayReusId)
        collection.backgroundColor = .white
    }
    
    func setupConstraints() {
        Helper.tamicOff(views: [collection])
        addSubview(collection)
        addSubview(addButton)
        NSLayoutConstraint.activate([collection.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     collection.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     collection.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     collection.topAnchor.constraint(equalTo: topAnchor, constant: 75)])
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(36)
            make.right.equalTo(-36)
            make.width.equalTo(75)
        }
                                   
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    enum Section: Int,CaseIterable {
        case birthday
        func desciption() -> String {
            switch self {
            case .birthday:
                return "Birthday"
            }
        }
        
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (section, layoutEnvironment) -> NSCollectionLayoutSection in
            guard let section = Section(rawValue: section) else {fatalError("Ne polu4ilos sozdat sekciu")}
            switch section {
            case .birthday:
                return self.createSections()
            }
            
        }
        
        return layout
    }
    
    private func createSections() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45),
                                              heightDimension: .fractionalHeight(0.97))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.6))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        //Section
        let spacing = CGFloat(8)
        group.interItemSpacing = .fixed(spacing)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 0, trailing: -12)
        
        return section
        
        
    }
}
