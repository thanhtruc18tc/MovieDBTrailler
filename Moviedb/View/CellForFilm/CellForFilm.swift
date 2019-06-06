//
//  CellForFilm.swift
//  Moviedb
//
//  Created by Truc Tran on 5/22/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit

class CellForFilm: UICollectionViewCell {
   

    @IBOutlet weak var imgFilm: UIImageView!
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
