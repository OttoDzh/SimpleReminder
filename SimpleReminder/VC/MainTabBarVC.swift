//
//  MainTabBarVC.swift
//  SimpleReminder
//
//  Created by Otto Dzhandzhuliya on 09.04.2023.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setupViews()
    }
    
    func generateTabBar() {
        
    viewControllers = [
      generateNavVc(vc: MainVC(), title: "Reminders", image: UIImage(systemName: "clock.circle")),
      generateNavVc(vc: BirthDayVC(), title: "Birthday reminders", image: UIImage(systemName: "gift"))
    ]
    }
    private func generateNavVc(vc:UIViewController,title:String,image:UIImage?) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
    
    private func setupViews() {
        tabBar.backgroundColor = .darkGray
        tabBar.layer.cornerRadius = 15
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
    }
}
