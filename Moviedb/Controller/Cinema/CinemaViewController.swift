//
//  CinemaViewController.swift
//  Moviedb
//
//  Created by Truc Tran on 5/30/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import NVActivityIndicatorView


class CinemaViewController: UIViewController, NVActivityIndicatorViewable{

    @IBOutlet var btnCity : [UIButton]!
    @IBOutlet weak var btnSelectCity : UIButton!
    @IBOutlet weak var tableViewCinema : UITableView!
    @IBOutlet weak var imgDropArrow : UIImageView!
    @IBOutlet weak var lbNoResultsFound : UILabel!
    
    var latitude = 10.741644
    var longtitude = 106.701161
    let locationManager = CLLocationManager()
    var listCinema : [CinemaEntity] = []
    var currentCity = "sg"
    
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
        self.btnCity.forEach { (button) in
            button.isHidden = true
            button.backgroundColor = Color.backgroundColor
        }
        self.view.setNeedsLayout()
        self.view.bringSubviewToFront(imgDropArrow)
        setUpView()
        btnSelectCity.backgroundColor = Color.backgroundColor
        self.view.backgroundColor = Color.backgroundColor
        navigationController?.navigationBar.isHidden = true
        hideButtonCitys()
        setUpTableView()
        
    }
    
    func setUpView(){
        tableViewCinema.isHidden = true
        lbNoResultsFound.isHidden = false
    }
    
    func setUpTableView(){
        // register nib
        let nib = UINib(nibName: "CellForCinema", bundle: nil)
        tableViewCinema.register(nib, forCellReuseIdentifier: "cellForCinema")
        tableViewCinema.delegate = self
        tableViewCinema.dataSource = self
        tableViewCinema.tintColor = Color.backgroundColor
        tableViewCinema.backgroundColor = Color.backgroundColor
    }
    func hideButtonCitys(){
        UIView.animate(withDuration: 0.3) {
            self.btnCity.forEach { (button) in
                button.isHidden = true
                
            }
        }
    }
    
    enum Citys : String{
        case sg = "Hồ Chí Minh"
        case hn = "Hà Nội"
        case ct = "Cần Thơ"
        case danang = "Đà Nẵng"
        case dongnai = "Đồng Nai"
    }
    
    @IBAction func btnSelectCityTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.btnCity.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.imgDropArrow.transform = self.imgDropArrow.transform.rotated(by: CGFloat(Double.pi))
        }
    }
    
    @IBAction func cityTapped(_ sender : UIButton){
        guard let title = sender.currentTitle, let city = Citys(rawValue: title)else{
            return
        }
            switch city {
            case .sg:
                self.currentCity = "sg"
            case .ct:
                self.currentCity = "ct"
            case .hn:
                self.currentCity = "hn"
            case .dongnai:
                self.currentCity = "dongnai"
            default:
                self.currentCity = "danang"
            }
        
        btnSelectCity.titleLabel?.textAlignment = .center
        btnSelectCity.titleLabel?.text = title
        self.hideButtonCitys()
        showLoadingView(value: true)
        UIView.animate(withDuration: 0.3) {
            self.imgDropArrow.transform = self.imgDropArrow.transform.rotated(by: CGFloat(Double.pi))
        }
        //get data
        getCinemaData()
        
    }
    
    func showLoadingView(value : Bool){
        if value{
            self.loadingView.startAnimating()
        }else{
            self.loadingView.stopAnimating()
        }
        tableViewCinema.isHidden = value
        lbNoResultsFound.isHidden = true
    }
    
    func getCinemaData(){
        self.listCinema.removeAll()
        var urlString  = LinkAPI.apiCinema
        urlString = String(format: urlString, "\(self.currentCity)")
        APIManager.getCinema(urlString: urlString) { (cinemas) in
            self.listCinema = cinemas
            if self.listCinema.count != 0{
                self.tableViewCinema.reloadData()
                self.lbNoResultsFound.isHidden = true
                self.showLoadingView(value: false)
            }
        }
    }
    
    func openInMapApp(latitude : Double, longtitude : Double, namePlace : String ){
        let lat : CLLocationDegrees = latitude
        let long : CLLocationDegrees = longtitude
        let dis : CLLocationDistance = 10
        let cordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let placeMark : MKPlacemark = MKPlacemark(coordinate: cordinate)
        let mapItem : MKMapItem = MKMapItem(placemark: placeMark)
        mapItem.name = namePlace
        let reSpan = MKCoordinateRegion(center: cordinate, latitudinalMeters: dis, longitudinalMeters: dis)
        let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate: reSpan.center)]
        mapItem.openInMaps(launchOptions: options)
        
    }

}
extension CinemaViewController : CellForCinemaDelegate {
    func didTapGuideRoad(location: String, name: String) {
        var strArray = location.components(separatedBy: ",")
        let lat = strArray[0]
        let long = strArray[1]

        // open google map app
        let customURL = "comgooglemaps://"
        let urlRoute = "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving"
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL) {
            UIApplication.shared.openURL(NSURL(string: urlRoute)! as URL)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Google maps not installed", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated:true, completion: nil)
        }
    }
}
extension CinemaViewController: UITableViewDelegate,UITableViewDataSource{
    @objc func loadMap(){
        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCinema.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForCinema", for: indexPath) as! CellForCinema
        cell.setData(cinema: listCinema[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

}

