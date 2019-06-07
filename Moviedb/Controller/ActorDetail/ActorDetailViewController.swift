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
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDateOfBirth: UILabel!
    @IBOutlet weak var lbPlaceOfBirth: UILabel!
    @IBOutlet weak var lbKnownOfDepartment: UILabel!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var imgActor : UIImageView!
    @IBOutlet weak var lbKnownFor: UILabel!
    @IBOutlet weak var collectionViewFilmCredits: UICollectionView!
    @IBOutlet weak var lbBiography: UILabel!
    @IBOutlet weak var lineSeperate1: UIView!
    @IBOutlet weak var lineSeperate2: UIView!

    var id = 0
    var actorDetail : ActorEntity!
    var listFilmCredits : [FilmEntity] = []
    
    func getId(idActor : Int){
        self.id = idActor
    }
    let loadingView: NVActivityIndicatorView = {
        let type: NVActivityIndicatorType = .circleStrokeSpin
        let color = UIColor.white
        let padding: CGFloat = 30
        let frame = CGRect(x: UIScreen.main.bounds.width/2 - 10, y: UIScreen.main.bounds.height/2 - 10, width: 20, height: 20)
        let animation = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        return animation
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        
        collectionViewFilmCredits.dataSource = self
        collectionViewFilmCredits.delegate = self
        getPeopleDetailFromAPI()
        getFilmCredits()
        self.view.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        registerNib()
        setUpTabBar()
        setUpVIew()
        setUpNavigationbar()
  
    }
    func showLoadingView(value : Bool){
        if value{
            self.loadingView.startAnimating()
        }else{
            self.loadingView.stopAnimating()
        }
        imgActor.isHidden = value
        lbName.isHidden = value
        lbDateOfBirth.isHidden = value
        lbKnownFor.isHidden = value
        lbBiography.isHidden = value
        lbPlaceOfBirth.isHidden = value
        lbKnownOfDepartment.isHidden = value
        tvSummary.isHidden = value
        lbBiography.isHidden = value
        collectionViewFilmCredits.isHidden = value
        lineSeperate1.isHidden = value
        lineSeperate2.isHidden = value
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
        showLoadingView(value: true)
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
        APIManager.getPeopleDetail(urlString: urlString) { (peopleDetail) in
            self.actorDetail = peopleDetail
            self.displayData()
        }
    }
    func getFilmCredits(){
        let urlString = "https://api.themoviedb.org/3/person/\(id)/movie_credits?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US"
        APIManager.getFilmCredits(urlString: urlString) { (filmCredits) in
            self.listFilmCredits = filmCredits
            self.collectionViewFilmCredits.reloadData()
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
        showLoadingView(value: false)

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
    

