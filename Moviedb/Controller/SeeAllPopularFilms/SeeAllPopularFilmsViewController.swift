//
//  SeeAllPopularFilmsViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 5/25/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import Alamofire
class SeeAllPopularFilmsViewController: UIViewController {
    @IBOutlet weak var tableViewPopularFilms : UITableView!
    var listFilms : [FilmEntity] = []
    var isNowPlaying =  false
    var page = 1
    func getFilms(arrFilms : [FilmEntity], isNowPlaying : Bool){
        self.listFilms = arrFilms
        self.isNowPlaying = isNowPlaying
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
        let nib = UINib(nibName: "CellForSeeAllPopularFilmsTableViewCell", bundle: nil)
        tableViewPopularFilms.register(nib, forCellReuseIdentifier: "cellForSeeAllPopularFilms")
        
        tableViewPopularFilms.backgroundColor = Color.backgroundColor
        tableViewPopularFilms.delegate = self
        tableViewPopularFilms.dataSource = self
        
    }
    func setUpTabBar(){
        tabBarController?.tabBar.tintColor = .orange
        tabBarController?.tabBar.barTintColor = .black
    }
    func setUpNavigationBar(){

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationItem.title = "Popular Films"
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.barTintColor = .black
 
    }
    func loadMoreFilms(){
        var urlString  = ""
        if isNowPlaying == true{
            urlString = LinkAPI.apiAllNowPlaying
        }else{
            urlString  = LinkAPI.apiAllPopularFilms
        }
        
        urlString = String(format: urlString, "\(page)")
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let responeValue = response.result.value as? [String: Any]{
                    if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                        for dic in listDictFilm {
                            let film = FilmEntity(dictionary: dic)
                            self.listFilms.append(film)
                        }
                    }
                }
                self.tableViewPopularFilms.reloadData()
            }else{
                print("error")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SeeAllPopularFilmsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFilms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForSeeAllPopularFilms", for: indexPath) as! CellForSeeAllPopularFilmsTableViewCell
        if listFilms.count != 0{
            if let title = listFilms[indexPath.row].title{
                cell.lbTile.text = title
                cell.lbDate.text = listFilms[indexPath.row].release_date
                
                cell.starRateBar.rating = listFilms[indexPath.row].vote_average ?? 0
                
                cell.starRateBar.settings.textColor = .orange
            }
            if let vote = listFilms[indexPath.row].vote_count{
                cell.lbVote.text = "Vote: \(vote)"
            }
            if let score = listFilms[indexPath.row].vote_average{
                cell.starRateBar.text = "\(score)"
                
            
            }
            //set image
            if let linkImg = listFilms[indexPath.row].poster_path{
                let link = "https://image.tmdb.org/t/p/original\(linkImg)"
                let url = URL(string: link)
                cell.imgFilm.sd_setImage(with: url)///
            }
            
            cell.lbTile.textColor = .white
            cell.lbDate.textColor = .lightGray
            cell.lbVote.textColor = .lightGray
            cell.vBackground.backgroundColor = Color.backgroundColor
            cell.selectionStyle = .none
            cell.starRateBar.settings.updateOnTouch = false
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filmDetailViewController = FilmDetailViewController()
        filmDetailViewController.getId(idFilm: listFilms[indexPath.row].id ?? 0)
        navigationController?.pushViewController(filmDetailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listFilms.count-1 {///
            page += 1
            loadMoreFilms()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
}
