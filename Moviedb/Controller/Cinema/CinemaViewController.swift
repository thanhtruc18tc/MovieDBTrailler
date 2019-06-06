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
//    @IBOutlet weak var btnSelectCity : UIButton!
//    @IBOutlet weak var btnHCM : UIButton!
//    @IBOutlet weak var btnHNoi : UIButton!
//    @IBOutlet weak var btnDNang : UIButton!
//    @IBOutlet weak var btnDNai : UIButton!
//    @IBOutlet weak var btnCTho : UIButton!
//
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.followX.constant = self.view.frame.width/2 + follow.frame.width/2
//        self.view.layoutIfNeeded()
//        
//        self.followX.constant = 0
        self.btnCity.forEach { (button) in
//            button.translatesAutoresizingMaskIntoConstraints = false
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

        //        AIzaSyBvrL-a-BfYONkzLV9KmlzNaEcp2bc0iC4
        
    }
    
    func setUpView(){
        tableViewCinema.isHidden = true
        lbNoResultsFound.isHidden = false
    }
    func loadingView(){
        let size = CGSize(width: 10 , height: 10)
        let font = UIFont(name: "System", size: 12)
        //start
        startAnimating(size, message: "Loading", messageFont: font, type: .ballPulse, color: .white, padding: 20, displayTimeThreshold: 2, minimumDisplayTime: 2, backgroundColor: Color.backgroundColor, textColor: .white, fadeInAnimation: nil)
        //stop
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(stopLoading), userInfo: nil, repeats: false)
    }
    @objc func stopLoading(){
        stopAnimating()
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
//                button.translatesAutoresizingMaskIntoConstraints = false
                button.isHidden = true
//                button.backgroundColor = Color.backgroundColor
                
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
        //
        UIView.animate(withDuration: 0.3) {
            self.btnCity.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.imgDropArrow.transform = self.imgDropArrow.transform.rotated(by: CGFloat(Double.pi))
        }
        //
//        self.btnCity.forEach { (button) in
//            UIView.animate(withDuration: 0.3, animations: {
//                button.isHidden = !button.isHidden
//                self.view.layoutIfNeeded()
//            })
//        }
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
        UIView.animate(withDuration: 0.3) {
            self.imgDropArrow.transform = self.imgDropArrow.transform.rotated(by: CGFloat(Double.pi))
        }
        tableViewCinema.isHidden = false
        lbNoResultsFound.isHidden = true    
        
        // get data
        getCinemaData()
    }
    func getCinemaData(){
        self.listCinema.removeAll()
        var urlString  = LinkAPI.apiCinema
        urlString = String(format: urlString, "\(self.currentCity)")
        
        print(urlString)
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: Any]{
                    if let results = dic["data"] as? [[String : Any]]{
                        for result in results{
                            let cinema = CinemaEntity(dictionary: result)
                            self.listCinema.append(cinema)
                        }
                    }
                    
                }
//                self.loadingView()
                print(self.listCinema.count)
                self.tableViewCinema.reloadData()
//                self.stopAnimating()
            }else if response.result.isFailure{
                print("error")
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
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CinemaViewController : CellForCinemaDelegate {
    func didTapGuideRoad(location: String, name: String) {
        var strArray = location.components(separatedBy: ",")
        let lat = strArray[0]
        let long = strArray[1]
//        if let lat = Double(lat), let long = Double(long){
//            self.openInMapApp(latitude: lat, longtitude: long, namePlace: name)
//        }
//        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
//        mapViewController.getLocation(location: location, place: name)
//        navigationController?.pushViewController(mapViewController, animated: true)
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

//        cell.btnGuideRoad.addTarget(self, action: #selector(loadMap), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

}

