//
//  ActorDetailViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 5/24/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import  Alamofire
import NVActivityIndicatorView
class ActorDetailViewController: UIViewController, NVActivityIndicatorViewable {
    var id = 0
    func getId(idActor : Int){
        self.id = idActor
    }
    var actorDetail : ActorEntity!
    var listFilmCredits : [FilmEntity] = []
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDateOfBirth: UILabel!
    @IBOutlet weak var lbPlaceOfBirth: UILabel!
    @IBOutlet weak var lbKnownOfDepartment: UILabel!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var imgActor : UIImageView!
    @IBOutlet weak var lbKnownFor: UILabel!
    
    @IBOutlet weak var collectionViewFilmCredits: UICollectionView!
    @IBOutlet weak var lbBiography: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView()
        collectionViewFilmCredits.dataSource = self
        collectionViewFilmCredits.delegate = self
        getPeopleDetailFromAPI()
        getFilmCredits()
        // Do any additional setup after loading the view.
        print(self.id)

        self.view.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        registerNib()
        setUpTabBar()
        setUpVIew()
        setUpNavigationbar()
  
    }
    func loadingView(){
        let size = CGSize(width: 10 , height: 10)
        let font = UIFont(name: "System", size: 12)
        startAnimating(size, message: "Loading", messageFont: font, type: .ballPulse, color: .white, padding: 20, displayTimeThreshold: 2, minimumDisplayTime: 2, backgroundColor: Color.backgroundColor, textColor: .white, fadeInAnimation: nil)
    }
    func registerNib(){
        let nibCell = UINib(nibName: "CellForFilm", bundle: nil)
        collectionViewFilmCredits.register(nibCell, forCellWithReuseIdentifier: "cell")
    }
    func setUpNavigationbar(){
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = .orange
    }
    func setUpTabBar(){
        tabBarController?.tabBar.tintColor = .orange
        tabBarController?.tabBar.barTintColor = .black
    }
    func setUpVIew(){
        lbBiography.textColor = .white
        lbKnownFor.textColor = .white
        lbName.textColor = .white
        lbDateOfBirth.textColor = .white
        lbPlaceOfBirth.textColor = .white
        lbKnownOfDepartment.textColor = .white
        
        tvSummary.textColor = .white
        tvSummary.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        collectionViewFilmCredits.backgroundColor = Color.backgroundColor
        if let layout = collectionViewFilmCredits.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .horizontal
        }
    }
    func getPeopleDetailFromAPI(){
        let urlString = "https://api.themoviedb.org/3/person/\(id)?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US"
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: Any]{
                    let actor = ActorEntity(dic: dic)
                    self.actorDetail = actor
                    
                }
                self.displayData()
                
            }else{
                print("error")
            }
        }
    }
    func getFilmCredits(){
        let urlString = "https://api.themoviedb.org/3/person/\(id)/movie_credits?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US"
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess{
                if let responeValue = response.result.value as? [String: Any]{
                    if let listDictFilm = responeValue["cast"] as? [[String: Any]]{
                        for dic in listDictFilm {
                            let film = FilmEntity(dictionary: dic)
                            self.listFilmCredits.append(film)
                            
                        }
                        
                    }
                    
                }
                self.collectionViewFilmCredits.reloadData()
                
            }else{
                print("error")
            }
        }
    }
    func displayData(){
        lbName.text = actorDetail.name
        if let dateOfBirth = actorDetail.birthday{
            lbDateOfBirth.text = "Date of Birth: " + dateOfBirth
        }
        if let placeOfBirth = actorDetail.place_of_birth{
            lbPlaceOfBirth.text = "Place of Birth: " + placeOfBirth
        }
        if let knownOfDepartment = actorDetail.known_for_department{
            lbKnownOfDepartment.text = "Known of Department: " + knownOfDepartment
        }
        tvSummary.text = actorDetail.biography
        self.loadImageForActor()
        stopAnimating()
    }
    func loadImageForActor(){
        if let path = actorDetail.profile_path{
            let linkImg = "https://image.tmdb.org/t/p/original\(path)"
            let url = URL(string: linkImg)
            imgActor.sd_setImage(with: url, placeholderImage: UIImage(named: "noImage"))
        }
        
    }
    func loadImageForFilm(path : String, imageView : UIImageView){
        let linkImg = "https://image.tmdb.org/t/p/original\(path )"
        let url = URL(string: linkImg)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "noImage"))
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
extension ActorDetailViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let idFilm = listFilmCredits[indexPath.row].id{
            let filmDetailController = FilmDetailViewController()
            filmDetailController.getId(idFilm: idFilm)
            self.navigationController?.pushViewController(filmDetailController, animated: true)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return listFilmCredits.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellForFilm
        cell.lbName.text = listFilmCredits[indexPath.row].title
        cell.lbDate.text = listFilmCredits[indexPath.row].release_date
        cell.lbName.textColor = .white
        cell.lbDate.textColor = .lightGray
        loadImageForFilm(path: listFilmCredits[indexPath.row].poster_path ?? "", imageView: cell.imgFilm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: 90, height: height)
    }

    
}
    

