//
//  CellForCinema.swift
//  Moviedb
//
//  Created by Truc Tran on 5/30/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import Cosmos

protocol CellForCinemaDelegate {
    func didTapGuideRoad(location : String, name : String)
}
class CellForCinema: UITableViewCell {

    @IBOutlet weak var imgCinema: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var starRate: CosmosView!
    @IBOutlet weak var btnGuideRoad: UIButton!
    
    var delegate : CellForCinemaDelegate?
    var cinema : CinemaEntity!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpView()
    }
    @IBAction func guideRoadTapped(){
        if let position = cinema.cine_position, let name = cinema.cinema_name {
            delegate?.didTapGuideRoad(location: position, name: name)
        }
//        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
    }
    func setData(cinema : CinemaEntity){
        self.cinema = cinema
        if let name = cinema.cinema_name{
            lbName.text = name
            let time = getTimeOpening(nameCinema: name)
            lbTime.text = time
        }
        if let address = cinema.cinema_address{
            lbAddress.text = "Address: " + address
        }
        if let phone = cinema.cinema_phone{
            lbPhone.text = "Phone: " + phone
        }
        starRate.rating = cinema.cinema_rate ?? 0

    }
    func getTimeOpening(nameCinema: String) -> String {
        if nameCinema.contains("CGV"){
            return "7 AM - 11h30 PM"
        }
        else if nameCinema.contains("LOTTE"){
            return "8 AM - 11h PM"
        }
        else{
            return "9 AM - 10h30 PM"
        }
    }
    func setUpView(){
        contentView.backgroundColor = Color.backgroundColor
        lbName.textColor = .white
        lbTime.textColor = .white
        lbPhone.textColor = .white
        lbAddress.textColor = .white
        starRate.backgroundColor = .clear
        imgCinema.layer.cornerRadius = 50
        starRate.settings.starSize = 14
        starRate.settings.starMargin = 3
        starRate.settings.fillMode = .precise
//        btnGuideRoad.isUserInteractionEnabled = true
    }

}
