//
//  SearchMovieViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 5/24/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import Alamofire
class SearchMovieViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewMovie: UITableView!
    @IBOutlet weak var lbNoResultsFound : UILabel!
    var listFilmFound : [FilmEntity] = []
    var searchKey = ""
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableViewMovie.dataSource = self
        tableViewMovie.delegate = self
        self.view.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        
        setUpView()
        setUpNavigationBar()
        setUpSearchbar()
        setUpTableView()
        
    }
    func setUpView(){
        tableViewMovie.isHidden = true
        lbNoResultsFound.isHidden = false
    }
    func setUpTableView(){
        //register nib
        let nib = UINib(nibName: "CellForSeeAllPopularFilmsTableViewCell", bundle: nil)
        tableViewMovie.register(nib, forCellReuseIdentifier: "cellForSeeAllPopularFilms")
        
        tableViewMovie.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        searchBar.keyboardAppearance = .dark
        tableViewMovie.keyboardDismissMode = .onDrag
        
    }
    func setUpSearchbar(){
        searchBar.barTintColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        searchBar.tintColor = .orange
    }
    func setUpNavigationBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationItem.title = "Search"
        navigationController?.navigationBar.barTintColor = .black
    }
    
    func searchFilms(key: String, page : Int){
        var urlString = LinkAPI.apiSearchMoreFilms
        urlString = String(format: urlString, key,"\(page)")
        print(urlString)
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: Any]{
                    if let results = dic["results"] as? [[String : Any]]{
                        for result in results{
                            let film = FilmEntity(dictionary: result)
                            self.listFilmFound.append(film)
                        }
                    }
                    
                }
                print(self.listFilmFound.count)
                self.tableViewMovie.reloadData()
            }else if response.result.isFailure{
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
extension SearchMovieViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //get page
        page = 1
        // get search key
        let key = searchBar.text!
        self.searchKey = key.replacingOccurrences(of: " ", with: "%20")
        
        if searchBar.text != ""{
            lbNoResultsFound.isHidden =  true
            tableViewMovie.isHidden = false
            self.listFilmFound.removeAll()
            searchFilms(key: self.searchKey, page: page)
            
        }else{
            lbNoResultsFound.isHidden = false
            tableViewMovie.isHidden = true
            listFilmFound.removeAll()
        }
        self.tableViewMovie.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        listFilmFound.removeAll()
        tableViewMovie.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
extension SearchMovieViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFilmFound.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForSeeAllPopularFilms", for: indexPath) as! CellForSeeAllPopularFilmsTableViewCell
        if let title = listFilmFound[indexPath.row].title{
            cell.lbTile.text = title
            cell.lbDate.text = listFilmFound[indexPath.row].release_date
            
            cell.starRateBar.rating = listFilmFound[indexPath.row].vote_average ?? 0
            
            cell.starRateBar.settings.textColor = .orange
        }
        if let vote = listFilmFound[indexPath.row].vote_count{
            cell.lbVote.text = "Vote: \(vote)"
        }
        if let score = listFilmFound[indexPath.row].vote_average{
            cell.starRateBar.text = "\(score)"
            
            
        }
        //set image
        if let linkImg = listFilmFound[indexPath.row].poster_path{
            let link = "https://image.tmdb.org/t/p/original\(linkImg)"
            let url = URL(string: link)
            cell.imgFilm.sd_setImage(with: url)
        }
        
        cell.lbTile.textColor = .white
        cell.lbDate.textColor = .lightGray
        cell.lbVote.textColor = .lightGray
        cell.vBackground.backgroundColor = Color.backgroundColor
        cell.selectionStyle = .none
        cell.starRateBar.settings.updateOnTouch = false
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filmDetailController = FilmDetailViewController()
        filmDetailController.getId(idFilm: listFilmFound[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(filmDetailController, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if page == 50{
            return
        }
        if indexPath.row == listFilmFound.count-1{
            page = page + 1
            searchFilms(key: self.searchKey, page: page)

        }
        
    }
    
}
