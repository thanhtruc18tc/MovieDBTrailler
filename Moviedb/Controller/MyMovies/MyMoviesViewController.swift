//
//  MyMoviesViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 5/29/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit

class MyMoviesViewController: UIViewController {
    var listFilms : [FilmEntity] = []
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var tableViewMyMovie : UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.listFilms.removeAll()
        getMovieDataFromDB(data: Database.shared.getMovieData())
        self.tableViewMyMovie.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        self.view.backgroundColor = Color.backgroundColor
        // Do any additional setup after loading the view.
        self.listFilms.removeAll()
        getMovieDataFromDB(data: Database.shared.getMovieData())
        setUpTableView()
        
    }
    func setUpTableView(){
        //register nib
        let nib = UINib(nibName: "CellForSeeAllPopularFilmsTableViewCell", bundle: nil)
        tableViewMyMovie.register(nib, forCellReuseIdentifier: "cellForSeeAllPopularFilms")
        
        tableViewMyMovie.backgroundColor = Color.backgroundColor
        tableViewMyMovie.separatorStyle = .none
        tableViewMyMovie.delegate = self
        tableViewMyMovie.dataSource = self
        
    }
    func setUpNavigationBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationItem.title = "My Movies"
        navigationController?.navigationBar.barTintColor = .black
    }
    func getMovieDataFromDB(data : [Movie]){
        var i = 0
        if data != []{
            for _ in data{
                let film = FilmEntity(id: Int(data[i].id ?? "") ?? 0, title: data[i].title ?? "", release_date: data[i].data_release ?? "", poster_path: data[i].poster_path ?? "", vote_average: data[i].vote_average )
                self.listFilms.append(film)
                i += 1
            }
        }
        if listFilms.count != 0{
            //tableViewMyMovie.isHidden = false
            lbEmpty.isHidden = true 
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
extension MyMoviesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForSeeAllPopularFilms", for: indexPath) as! CellForSeeAllPopularFilmsTableViewCell
        cell.lbTile.text = listFilms[indexPath.row].title
        cell.lbDate.text = listFilms[indexPath.row].release_date
        cell.starRateBar.rating = listFilms[indexPath.row].vote_average ?? 0
        cell.starRateBar.settings.textColor = .orange
        cell.lbVote.isHidden = true
        if let score = listFilms[indexPath.row].vote_average{
            cell.starRateBar.text = "\(score)"
  
        }
        //set image
        if let linkImg = listFilms[indexPath.row].poster_path{
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            //Database.shared.deleteMovieData(index: indexPath.row)
           
            Database.shared.deleteMovieDataByID(idMovie: listFilms[indexPath.row].id ?? 0)
            self.listFilms.remove(at: indexPath.row)
            self.tableViewMyMovie.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = listFilms[indexPath.row].id{
            let filmDetailsViewController = FilmDetailViewController()
            filmDetailsViewController.getId(idFilm: id)
            navigationController?.pushViewController(filmDetailsViewController, animated: true)
        }
        
    }
}
