//
//  FeaturedViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 5/22/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SDWebImage
import NVActivityIndicatorView
class FeaturedViewController: UIViewController, NVActivityIndicatorViewable{
    
    @IBOutlet weak var cltViewPopularMovies : UICollectionView!
    @IBOutlet weak var slideShow :  ImageSlideshow!
    @IBOutlet weak var lbpopularFilm: UILabel!
    var listPopularMovies : [FilmEntity] = []
    var listNowPlayingMovies : [FilmEntity] = []
    var listPopularPeople : [ActorEntity] = []
    var listHotMovies : [FilmEntity] = []
    var listImageFilmHot : [String] = []
    
//    let type: NVActivityIndicatorType = .circleStrokeSpin
//    let color = UIColor.white
//    let padding: CGFloat = 30
//    let frame = CGRect(x: UIScreen.main.bounds.width/2 - 10, y: UIScreen.main.bounds.height/2 - 10, width: 20, height: 20)
//    let animation = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
//    return animation
    
    @IBOutlet weak var btnSeeAllPopularMovies : UIView!
    @IBOutlet weak var btnSeeAllPopularPeople : UIView!
    @IBOutlet weak var btnSeeAllNowPlaying : UIView!
    @IBOutlet weak var vOfScrollView: UIView!
    @IBOutlet weak var lbPopularPeople: UILabel!
    @IBOutlet weak var cltViewPopularPeople: UICollectionView!
    @IBOutlet weak var lbNowPlaying: UILabel!
    @IBOutlet weak var cltViewNowPlaying: UICollectionView!
    @IBOutlet weak var cltHotMovie: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else{
            let alert = UIAlertController(title: "No internet connection!", message: "Please connect the internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all

        loadingView()
        // Do any additional setup after loading the view.
        getPopularMovies()
        getNowPlayingMovies()
        getPopularPeople()
        setUpView()
        setUpNavigationBar()
        registerNib()
        setUpButtonSeeAll()
        setUpAutoScrollMovieHeader()
        setScrollDirectionCollectionView()
  
    }

    func setUpView(){
        navigationController?.navigationBar.barTintColor = UIColor.black
        tabBarController?.tabBar.barTintColor = UIColor.black
        
        self.view.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        cltViewPopularMovies.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        cltViewNowPlaying.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        cltViewPopularPeople.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        cltHotMovie.backgroundColor = Color.backgroundColor
        cltHotMovie.isPagingEnabled = true
        
        
        cltViewNowPlaying.delegate = self
        cltViewNowPlaying.dataSource = self
        
        cltViewPopularPeople.delegate = self
        cltViewPopularPeople.dataSource = self
        
        cltHotMovie.delegate = self
        cltHotMovie.dataSource = self
        lbPopularPeople.textColor = .white
        lbNowPlaying.textColor = .white
        vOfScrollView.backgroundColor = Color.backgroundColor
        
        lbpopularFilm.textColor = .white
    }
    func loadingView(){
        let size = CGSize(width: 10 , height: 10)
        let font = UIFont(name: "System", size: 12)
        startAnimating(size, message: "Loading", messageFont: font, type: .ballPulse, color: .white, padding: 20, displayTimeThreshold: 2, minimumDisplayTime: 2, backgroundColor: Color.backgroundColor, textColor: .white, fadeInAnimation: nil)
        //stop
        _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(stopLoading), userInfo: nil, repeats: false)
    }
    @objc func stopLoading(){
        stopAnimating()
    }
    func setUpButtonSeeAll(){
        // btn see all popular movie
        let tapGestureForSeeAllPopularMovie = UITapGestureRecognizer(target: self, action: #selector(btnSeeAllPopularMoviesTapped))
        btnSeeAllPopularMovies.backgroundColor = .clear
        btnSeeAllPopularMovies.addGestureRecognizer(tapGestureForSeeAllPopularMovie)
        btnSeeAllPopularMovies.isUserInteractionEnabled = true
        // btn see all popular poeple
        let tapGestureForSeeAllPopularPeople = UITapGestureRecognizer(target: self, action: #selector(btnSeeAllPopularPeopleTapped))
        btnSeeAllPopularPeople.backgroundColor = .clear
        btnSeeAllPopularPeople.addGestureRecognizer(tapGestureForSeeAllPopularPeople)
        btnSeeAllPopularPeople.isUserInteractionEnabled = true
        // btn see all now playing
        let tapGestureSeeAllNowPlaying = UITapGestureRecognizer(target: self, action: #selector(btnSeeAllNowPlayingTapped))
        btnSeeAllNowPlaying.backgroundColor = .clear
        btnSeeAllNowPlaying.addGestureRecognizer(tapGestureSeeAllNowPlaying)
        btnSeeAllNowPlaying.isUserInteractionEnabled = true
        
    }
    func setScrollDirectionCollectionView(){
        if let layout = cltViewPopularMovies.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        if let layout = cltViewPopularPeople.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        if let layout = cltViewNowPlaying.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        if let layout = cltHotMovie.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
    }
    @objc func btnSeeAllPopularMoviesTapped(){
        let seeAllPopularFilmViewController = SeeAllPopularFilmsViewController(nibName: "SeeAllPopularFilmsViewController", bundle: nil)
        seeAllPopularFilmViewController.getFilms(arrFilms: listPopularMovies, isNowPlaying: false)
        navigationController?.pushViewController(seeAllPopularFilmViewController, animated: true)
    }
    @objc func btnSeeAllPopularPeopleTapped(){
        let seeAllPopularPeopleViewController = SeeAllPopularPeopleViewController(nibName: "SeeAllPopularPeopleViewController", bundle: nil)
        seeAllPopularPeopleViewController.getId(idActor: listPopularPeople)
        
        navigationController?.pushViewController(seeAllPopularPeopleViewController, animated: true)
    }
    @objc func btnSeeAllNowPlayingTapped(){
        let seeAllPopularFilmViewController = SeeAllPopularFilmsViewController(nibName: "SeeAllPopularFilmsViewController", bundle: nil)
        seeAllPopularFilmViewController.getFilms(arrFilms: listNowPlayingMovies, isNowPlaying: true)
        navigationController?.pushViewController(seeAllPopularFilmViewController, animated: true)
    }

    func getPopularMovies(){
        let urlString  = LinkAPI.apiFilm
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
                if response.result.isSuccess{
                    if let responeValue = response.result.value as? [String: Any]{
                        if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                            for dic in listDictFilm {
                                let film = FilmEntity(dictionary: dic)
                                self.listPopularMovies.append(film)
                            }
                        }
                    }
                    self.cltViewPopularMovies.reloadData()
                    self.cltHotMovie.reloadData()
                }else{
                    print("error")
                }
        }
    }

    func getNowPlayingMovies(){
        let urlString  = LinkAPI.apiNowPlaying
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let responeValue = response.result.value as? [String: Any]{
                    if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                        for dic in listDictFilm {
                            let film = FilmEntity(dictionary: dic)
                            self.listNowPlayingMovies.append(film)
                        }
                    }
                }
                self.cltViewNowPlaying.reloadData()
            }else{
                print("error")
            }
        }
    }
    func getPopularPeople(){
        let urlString  = LinkAPI.apiPopularPeople
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let responeValue = response.result.value as? [String: Any]{
                    if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                        for dic in listDictFilm {
                            let actor = ActorEntity(dic: dic)
                            self.listPopularPeople.append(actor)
                        }
                    }
                }
                self.cltViewPopularPeople.reloadData()
                //self.getImageFilmHot()
                //self.stopAnimating()
               
            }else{
                print("error")
            }
        }
    }
    func loadImage(path : String, imageView : UIImageView){
        let linkImg = "https://image.tmdb.org/t/p/original\(path )"
        let url = URL(string: linkImg)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "noImage"))
    }
    func registerNib(){
        let nibCellPopularMovies = UINib(nibName: "CellForFilm", bundle: nil)
        cltViewPopularMovies.register(nibCellPopularMovies, forCellWithReuseIdentifier: "cell")
        
        let nibCellPopularPeople = UINib(nibName: "CellForCast", bundle: nil)
        cltViewPopularPeople.register(nibCellPopularPeople, forCellWithReuseIdentifier: "cellActor")
        
        let nibCellNowPlaying = UINib(nibName: "CellForFilm", bundle: nil)
        cltViewNowPlaying.register(nibCellNowPlaying, forCellWithReuseIdentifier: "cell")
        
        let nibCellHotMovies = UINib(nibName: "CellForHotMovie", bundle: nil)
        cltHotMovie.register(nibCellHotMovies, forCellWithReuseIdentifier: "cellHotFilm")
    }
    func setUpNavigationBar(){

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationItem.title = "Discover"
    }
    func getImageFilmHot(){
        self.cltViewPopularMovies.reloadData()
        // get image hot film
        for i in 0...5{
            if let path = self.listPopularMovies[i].backdrop_path{
                self.listImageFilmHot.append("https://image.tmdb.org/t/p/original\(path)")
            }
        }
        //setUpImageViewSlideShow()
    }
//    func setUpImageViewSlideShow(){
//        slideShow.slideshowInterval = 5
//        slideShow.pageIndicator = nil
//        slideShow.contentScaleMode = .scaleAspectFill
//        //        slideShow.backgroundColor = UIColor.black
//        //        slideShow.activityIndicator = DefaultActivityIndicator()
//        //        slideShow.zoomEnabled = true
//        slideShow.maximumScale = 5
//        //set image
//        slideShow.setImageInputs([
//            SDWebImageSource(urlString: self.listImageFilmHot[0],placeholder: UIImage(named: "noImage"))!,
//            SDWebImageSource(urlString: self.listImageFilmHot[1])!,
//            SDWebImageSource(urlString: self.listImageFilmHot[2])!,
//            SDWebImageSource(urlString: self.listImageFilmHot[3])!,
//            SDWebImageSource(urlString: self.listImageFilmHot[4])!,
//            ])
//    }

    @objc func scrollToNextCell(){
        //get cell size
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height);
        
        //get current content Offset of the Collection view
        let contentOffset = cltHotMovie.contentOffset;
        
        //scroll to next cell
        cltHotMovie.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
       
 
    }
    func setUpAutoScrollMovieHeader() {
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
     
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
extension FeaturedViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return listPopularMovies.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        if collectionView == cltHotMovie{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHotFilm", for: indexPath) as! CellForHotMovie
            if let imgLink = listPopularMovies[indexPath.row].backdrop_path{
                cell.lbName.text = listPopularMovies[indexPath.row].title
                cell.lbName.textColor = .white
                cell.lbName.backgroundColor = Color.backgroundColor
                loadImage(path: imgLink, imageView: cell.imgFilm)
            }
            return cell
        }else if collectionView == cltViewPopularMovies{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellForFilm
            cell.lbName.text = listPopularMovies[indexPath.row].title
            cell.lbDate.text = listPopularMovies[indexPath.row].release_date
            cell.lbName.textColor = .white
            cell.lbDate.textColor = .lightGray
            loadImage(path: listPopularMovies[indexPath.row].poster_path ?? "", imageView: cell.imgFilm)
            return cell
            
        }
        else if collectionView == cltViewNowPlaying{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellForFilm
            cell.lbName.text = listNowPlayingMovies[indexPath.row].title
            cell.lbDate.text = listNowPlayingMovies[indexPath.row].release_date
            cell.lbName.textColor = .white
            cell.lbDate.textColor = .lightGray
            loadImage(path: listNowPlayingMovies[indexPath.row].poster_path ?? "", imageView: cell.imgFilm)
            return cell
        }else if collectionView == cltViewPopularPeople{
            // cltPopularPeople
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellActor", for: indexPath) as! CellForCast
            cell.lbName.text = listPopularPeople[indexPath.row].name
            cell.lbCharacter.isHidden = true
            loadImage(path: listPopularPeople[indexPath.row].profile_path ?? "", imageView: cell.imgProfile)
            return cell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cltViewPopularMovies || collectionView == cltHotMovie{
            let filmDetailController = FilmDetailViewController()
            filmDetailController.getId(idFilm: listPopularMovies[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(filmDetailController, animated: true)
        }else if collectionView == cltViewNowPlaying{
            let filmDetailController = FilmDetailViewController()
            filmDetailController.getId(idFilm: listNowPlayingMovies[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(filmDetailController, animated: true)
        }else{
            let actorDetaiViewlController = ActorDetailViewController()
            actorDetaiViewlController.getId(idActor:  listPopularPeople[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(actorDetaiViewlController, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cltHotMovie{
            let width = (collectionView.frame.width)
            let height = (collectionView.frame.height )
            return CGSize(width: width, height: height)
        }else if collectionView == cltViewPopularPeople{
            let width = 100
            let height = 200
            return CGSize(width: width, height: height)
        }else{
            let width = 110
            let height = 200
            return CGSize(width: width, height: height)
        }
    }
}

