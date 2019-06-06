//
//  CellForTrailer.swift
//  Moviedb
//
//  Created by Truc Tran on 5/23/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import  YouTubePlayer
class CellForTrailer: UICollectionViewCell {
    @IBOutlet weak var videoPlayer : YouTubePlayerView!
    @IBOutlet weak var lbName : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    

}
