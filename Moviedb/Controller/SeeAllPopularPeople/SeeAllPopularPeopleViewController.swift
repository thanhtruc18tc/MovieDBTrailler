//
//  SeeAllPopularPeopleViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 5/28/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Reachability
class SeeAllPopularPeopleViewController: UIViewController {
    @IBOutlet weak var tableViewPopularPeople : UITableView!
    
    var listPeople : [ActorEntity] = []
    var page = 1
    let reach : Reachability = Reachability.init(hostname: "www.google.com")!
    
    let loadingView: NVActivityIndicatorView = {
        let type: NVActivityIndicatorType = .circleStrokeSpin
        let color = UIColor.white
        let padding: CGFloat = 30
        let frame = CGRect(x: UIScreen.main.bounds.width/2 - 10, y: UIScreen.main.bounds.height/2 - 10, width: 20, height: 20)
        let animation = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        return animation
    }()
    
    func getId(idActor : [ActorEntity]){
        self.listPeople = idActor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.global().async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.networkChanged(note:)), name: .reachabilityChanged, object: nil)
            do {
                try self.reach.startNotifier()
            }
            catch{
                print("errror")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged , object: nil)
        reach.stopNotifier()
    }
    
    @objc func networkChanged(note: NSNotification){
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            print("have internet discover")
//            self.loadingView.stopAnimating()
        case .none:
            print("no internet")
            self.loadingView.startAnimating()
            setAlter()
        }
    }
    
    @objc func setAlter(){
        let alert = UIAlertController(title: "No internet connection!", message: "Please connect the internet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Color.backgroundColor
        setUpTableView()
        setUpTabBar()
        setUpNavigationBar()
    }
    
    func setUpTableView(){
        //register nib
        let nib = UINib(nibName: "CellForSeeAllPopularPeople", bundle: nil)
        tableViewPopularPeople.register(nib, forCellReuseIdentifier: "cellForSeeAllPopularPeople")
        
        tableViewPopularPeople.backgroundColor = Color.backgroundColor
        tableViewPopularPeople.delegate = self
        tableViewPopularPeople.dataSource = self
        
    }
    
    func setUpTabBar(){
        tabBarController?.tabBar.tintColor = .orange
        tabBarController?.tabBar.barTintColor = .black
    }
    
    func setUpNavigationBar(){
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationItem.title = "Popular People"
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.barTintColor = .black
        
    }
    
    func loadMorePeople(){
        var urlString  = LinkAPI.apiAllPopularPeople
        urlString = String(format: urlString, "\(page)")
        APIManager.loadMorePeople(urlString: urlString) { (people) in
            self.listPeople += people
            self.tableViewPopularPeople.reloadData()
        }
    }
}
extension SeeAllPopularPeopleViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForSeeAllPopularPeople", for: indexPath) as! CellForSeeAllPopularPeople
        
        cell.lbName.text = listPeople[indexPath.row].name
        if let linkImg = listPeople[indexPath.row].profile_path{
            let link = "https://image.tmdb.org/t/p/original\(linkImg)"
            let url = URL(string: link)
            cell.imgPeople.sd_setImage(with: url, placeholderImage: UIImage(named: "noImage"))
            cell.vBackgrounnd.backgroundColor = Color.backgroundColor
            cell.lbName.textColor = .white
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actorDetailViewController = ActorDetailViewController()
        actorDetailViewController.getId(idActor: listPeople[indexPath.row].id ?? 0)
        navigationController?.pushViewController(actorDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listPeople.count-5 {
            page += 1
            loadMorePeople()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
}
