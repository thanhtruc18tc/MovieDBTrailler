//
//  Tabbar.swift
//  Moviedb
//
//  Created by Truc Tran on 5/22/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
class TabBar : UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabBar()
    }
    func createTabBar(){
        
        let featuredViewController  = FeaturedViewController()
        let navFeaturedViewController = UINavigationController(rootViewController: featuredViewController)
        navFeaturedViewController.tabBarItem.image = #imageLiteral(resourceName: "feature")
        navFeaturedViewController.tabBarItem.title = "Discover"
        
        let searchViewController  = SearchMovieViewController()
        let navSearchViewController = UINavigationController(rootViewController: searchViewController)
        navSearchViewController.tabBarItem.image = #imageLiteral(resourceName: "search")
        navSearchViewController.tabBarItem.title = "Search"
        
        
        let myMovieViewController = MyMoviesViewController()
        let navMyMovieViewController = UINavigationController(rootViewController: myMovieViewController)
        navMyMovieViewController.tabBarItem.image = #imageLiteral(resourceName: "starFill")
        navMyMovieViewController.tabBarItem.title = "My Movies"
        
        
        let cinemaViewController = CinemaViewController()
        let navCinemaViewController = UINavigationController(rootViewController: cinemaViewController)
        navCinemaViewController.tabBarItem.image = #imageLiteral(resourceName: "cinema")
        navCinemaViewController.tabBarItem.title = "Cinema"
        //UITabBar.appearance().barTintColor =  #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        UITabBar.appearance().tintColor = .orange
        viewControllers = [navFeaturedViewController, navSearchViewController,navMyMovieViewController,navCinemaViewController]
    }
}
