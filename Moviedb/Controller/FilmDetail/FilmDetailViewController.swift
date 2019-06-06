//
//  FilmDetailViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 5/23/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import  Alamofire
import YouTubePlayer
import Cosmos
import TinyConstraints
import NVActivityIndicatorView
class FilmDetailViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var lbTitle : UILabel!
    @IBOutlet weak var lbDate : UILabel!
    @IBOutlet weak var lbLink : UILabel!
    @IBOutlet weak var lbGenre : UILabel!
    @IBOutlet weak var imgFilm : UIImageView!
    @IBOutlet weak var lbReleaseDate : UILabel!
    @IBOutlet weak var lbRuntime : UILabel!
    @IBOutlet weak var lbBudget : UILabel!
    @IBOutlet weak var lbRevenue : UILabel!
    @IBOutlet weak var tvSummary : UITextView!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var lbTrailer: UILabel!
    @IBOutlet weak var lbMovieFact: UILabel!
    @IBOutlet weak var viewOfScrollView: UIView!
    
    @IBOutlet weak var collectionViewTrailers: UICollectionView!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var rateStarBar : CosmosView!
    @IBOutlet weak var lbCast: UILabel!
    @IBOutlet weak var imgbackdrop : UIImageView!
    var starButton : UIButton!
    var filmDetails : FilmDetails!
    var listActor : [CastEntity] = []
    var listVideo : [VideoEntity] = []
    var idVideo : [String] = []
    var linkShare = "https://www.youtube.com/watch?v="
    var id = 0
    func  getId(idFilm : Int) {
        self.id = idFilm
    }
    override func viewWillAppear(_ animated: Bool) {
        if Database.shared.checkExist(idMovie: String(id)) == true{
            starButton.setImage(#imageLiteral(resourceName: "starFill"), for: .normal)
        }else{
            starButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        }
//        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        UIApplication.shared.isStatusBarHidden = false
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
//
//    }
    func loadingView(){
        let size = CGSize(width: 10 , height: 10)
        let font = UIFont(name: "System", size: 12)
        startAnimating(size, message: "Loading", messageFont: font, type: .ballPulse, color: .white, padding: 20, displayTimeThreshold: 2, minimumDisplayTime: 2, backgroundColor: Color.backgroundColor, textColor: .white, fadeInAnimation: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
        
        loadingView()
        
        collectionViewActors.delegate = self
        collectionViewActors.dataSource = self
        
        getDetailFilmFromAPI()
        getVideoFromAPI()
        getPeopleFromAPI()
       
        registerNib()
        setUpView()
        setUpNavigationBar()
        setUpCollectionView()
        
        
    }
    
    func setUpNavigationBar(){
       
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        flexSpace.width = 25
        
        let  shareButton = UIButton(type: .system)
        shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItems = [flexSpace,UIBarButtonItem(customView: shareButton),UIBarButtonItem(customView: starButton)]
        
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    @objc func starButtonTapped(){
        if Database.shared.checkExist(idMovie: String(id)) == false {
            starButton.setImage(#imageLiteral(resourceName: "starFill"), for: .normal)
            Database.shared.saveMovieData(id: String(self.id) , title: self.filmDetails.title ?? "", date: filmDetails.release_date ?? "", imgLink: filmDetails.poster_path ?? "", voteAverage: filmDetails.vote_average ?? 0)
        }else{
            starButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            Database.shared.deleteMovieDataByID(idMovie: self.id)
        }
    }
    @objc func shareButtonTapped(){
        self.linkShare = self.linkShare + self.listVideo[0].key!
        print(self.linkShare)
        let activityController = UIActivityViewController(activityItems: [self.linkShare], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    func setUpView(){
        // lb link homepage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        lbLink.isUserInteractionEnabled = true
        lbLink.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        viewOfScrollView.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        lbTitle.textColor = .white
        lbDate.textColor = .white
        lbGenre.textColor =  .white
        lbSummary.textColor = .white
        lbTrailer.textColor = .white
        lbMovieFact.textColor = .white
        tvSummary.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        tvSummary.textColor = .white
        lbReleaseDate.textColor = . white
        lbRuntime.textColor = . white
        lbBudget.textColor = . white
        lbRevenue.textColor = . white
        lbCast.textColor = .white
        rateStarBar.backgroundColor = Color.backgroundColor
    }
    func registerNib(){
        let nibCellTrailer = UINib(nibName: "CellForTrailer", bundle: nil)
        collectionViewTrailers.register(nibCellTrailer, forCellWithReuseIdentifier: "cellTrailer")
        
        let nibCellCast = UINib(nibName: "CellForCast", bundle: nil)
        collectionViewActors.register(nibCellCast, forCellWithReuseIdentifier: "cellActor")
    }
    func setUpCollectionView(){
        collectionViewTrailers.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        collectionViewTrailers.reloadData()
        collectionViewActors.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)

        if let layout = collectionViewTrailers.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        if let layout = collectionViewActors.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    func displayRateBar(){
        rateStarBar.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        rateStarBar.settings.totalStars = 10
        rateStarBar.settings.starSize = 12
        rateStarBar.settings.starMargin = 1
        rateStarBar.settings.fillMode = .precise
        
        rateStarBar.settings.textColor = .orange
        if let rating = filmDetails.vote_average{
            rateStarBar.rating = rating
            rateStarBar.text = "\(rating)"
        }
    }
    func loadImageForActor(path : String, imageView : UIImageView){
        let linkImg = "https://image.tmdb.org/t/p/original\(path )"
        let url = URL(string: linkImg)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "noImage"))
    }
    func getPeopleFromAPI(){
//        let urlString = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=c9238e9fff997ddc12fc76e3904e2618"
        var urlString = LinkAPI.apiFilmDetails
        urlString = String(format: urlString, "\(id)")
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: Any]{
                    if let cast = dic["cast"] as? [[String : Any]]{
                        for element in cast{
                            let actor = CastEntity(dic: element)
                            self.listActor.append(actor)
                        }
                    }
                
                }
                self.collectionViewActors.reloadData()
                
            }else{
                print("error")
            }
        }
    }
    func getVideoFromAPI(){
//        let urlString = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US"
        var urlString = LinkAPI.apiTrailers
        urlString = String(format: urlString,"\(id)")
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: Any]{
                    if let results = dic["results"] as? [[String : Any]]{
                        for video in results{
                            let video = VideoEntity(dic: video)
                            self.listVideo.append(video)
                        }
                    }
                }
                self.collectionViewTrailers.reloadData()
                
            }else{
                print("error")
            }
        }
        
    }
    func getDetailFilmFromAPI(){
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US"
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: Any]{
                    let film = FilmDetails(dic: dic)
                    self.filmDetails = film
                }
                self.displayData()
            }else{
                print("error")
            }
        }
    }
    func displayData(){
        lbTitle.text = self.filmDetails.title
        if let date = self.filmDetails.release_date{
            lbDate.text = String(date.prefix(4))
        }
        
        lbLink.text = self.filmDetails.homepage
        // genre
        if let genre = self.filmDetails.genres?.name{
            lbGenre.text = genre
        }
        // set image
        let linkImg = "https://image.tmdb.org/t/p/original\(self.filmDetails.poster_path ?? "" )"
        let url = URL(string: linkImg)
        imgFilm.sd_setImage(with: url)
        
        let linkImg2 = "https://image.tmdb.org/t/p/original\(self.filmDetails.backdrop_path ?? "" )"
        let url2 = URL(string: linkImg2)
        imgbackdrop.sd_setImage(with: url2)
        
        lbReleaseDate.text = "Release Date: \(self.filmDetails.release_date ?? "none")"
        //label link
        lbLink.textColor = .orange
        let attributedString = NSAttributedString(string: self.filmDetails.homepage ?? "No Homepage")
        let textRange = NSMakeRange(0, attributedString.length)
        let underlinedMessage = NSMutableAttributedString(attributedString: attributedString)
        underlinedMessage.addAttribute(NSAttributedString.Key.underlineStyle,
                                       value:NSUnderlineStyle.single.rawValue,
                                       range: textRange)
        self.lbLink.attributedText = underlinedMessage
        
        tvSummary.text = self.filmDetails.overview
        if let runtime = self.filmDetails.runtime{
            let runtime = secondsToHoursMinutesSeconds(minutes: runtime)
            lbRuntime.text = "Run time: " + runtime
            lbDate.text = lbDate.text! + " - " + runtime
        }
        if let budget = self.filmDetails.budget{
            lbBudget.text = "Budget: " + convertToCurrency(number: budget)
        }
        if let revenue = self.filmDetails.revenue{
            lbRevenue.text = "Revenue: " + convertToCurrency(number: revenue)
        }
        displayRateBar()
        stopAnimating()
        
    }
    @objc func linkTapped(){
        guard let link = URL(string: self.filmDetails.homepage!) else { return }
        UIApplication.shared.open(link)
    }
    
    func secondsToHoursMinutesSeconds (minutes : Int) -> String {
        let seconds = minutes * 60
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
       
        let runtime = String(hours) + " hrs " + String(minutes) + " mins"
        return runtime
        
    }
    func convertToCurrency(number: Int) -> String{
        let myDouble = number
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        
        let priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
//        print(priceString) // Displays $9,999.99 in the US locale
        return priceString
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
extension FilmDetailViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewTrailers{
            return listVideo.count
        }else{
            return listActor.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewActors {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellActor", for: indexPath) as! CellForCast
            if listActor.count != 0 {
                cell.lbName.text = listActor[indexPath.row].name
                cell.lbCharacter.text = listActor[indexPath.row].character
                loadImageForActor(path: listActor[indexPath.row].profile_path ?? "", imageView: cell.imgProfile)
                
            }
            return cell
            
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTrailer", for: indexPath) as! CellForTrailer
            if listVideo.count != 0{
                if let keyVideo = listVideo[indexPath.row].key{
                    cell.videoPlayer.loadVideoID(keyVideo)
                    cell.lbName.text = listVideo[indexPath.row].name
                }
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewTrailers{
            return CGSize(width: 150, height: 130)
            
        }else{
            return CGSize(width: 70, height: 151
                
            )
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewActors{
            let actorDetaiViewlController = ActorDetailViewController()
            actorDetaiViewlController.getId(idActor:  listActor[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(actorDetaiViewlController, animated: true)
        }
        
    }
    
    
}
