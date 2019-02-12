//
//  ContactCell.swift
//  Custom Table & Sections
//
//  Created by Wilmer sinchi on 1/28/19.
//  Copyright © 2019 Wilmer sinchi. All rights reserved.
//

import Foundation
import UIKit

class ContactCell: UITableViewCell {
    var link : ViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        //setting up the image from the local storage
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "star1.png"), for: .normal)
        //changing the color of the start
        starButton.tintColor = .red
        starButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        
        starButton.addTarget(self, action: #selector(handleStarFavorite), for: .touchUpInside)
        accessoryView = starButton
        
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func handleStarFavorite() {
//        let indexPath = IndexPath()
        link?.someTestingMethod(cell: self)
        print("testing star favorite")
//        print(indexPath.row)
        
        
    }
    
}
