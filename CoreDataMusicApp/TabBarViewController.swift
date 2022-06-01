//
//  TabBarViewController.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.barTintColor = UIColor .black
        self.tabBar.isTranslucent = false
        self.tabBar.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let top100Tab = MainViewController(viewModel: AlbumListViewModel())
        let tab1 = UITabBarItem(title: "", image: UIImage(systemName: "music.note.list"), tag: 0)
        top100Tab.tabBarItem = tab1
        
        let favoritesTab = FavoritesViewController(viewModel: AlbumListViewModel())
        let tab2 = UITabBarItem(title: "", image: UIImage(systemName: "star"), tag: 0)
        favoritesTab.tabBarItem = tab2
        self.viewControllers = [top100Tab, favoritesTab]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tabBar.barTintColor = UIColor .black
    }
    
}
