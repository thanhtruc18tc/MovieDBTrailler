//
//  CellForSeeAllPopularFilmsTableViewCell.swift
//  Moviedb
//
//  Created by Truc Tran on 5/25/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit

import  Cosmos
import  TinyConstraints
class CellForSeeAllPopularFilmsTableViewCell: UITableViewCell {
    @IBOutlet weak var imgFilm : UIImageView!
    @IBOutlet weak var lbTile : UILabel!
    @IBOutlet weak var lbDate : UILabel!
    @IBOutlet weak var lbVote : UILabel!
    @IBOutlet weak var starRateBar : CosmosView!
    @IBOutlet weak var vBackground : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
