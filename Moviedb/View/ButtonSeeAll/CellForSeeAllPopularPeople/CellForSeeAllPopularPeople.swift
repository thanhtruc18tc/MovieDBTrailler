//
//  CellForSeeAllPopularPeople.swift
//  Moviedb
//
//  Created by Truc Tran on 5/28/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit

class CellForSeeAllPopularPeople: UITableViewCell {

    @IBOutlet weak var lbName :UILabel!
    @IBOutlet weak var imgPeople : UIImageView!
    @IBOutlet weak var vBackgrounnd : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
