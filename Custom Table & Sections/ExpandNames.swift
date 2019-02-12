//
//  ExpandNames.swift
//  Custom Table & Sections
//
//  Created by Wilmer sinchi on 1/28/19.
//  Copyright © 2019 Wilmer sinchi. All rights reserved.
//

import Foundation
import Contacts

struct ExpandableNames{
    
    var isExpanded: Bool
    //this is an array of the one below
    var name : [FavoritableContact]
    
}

struct FavoritableContact {
    // you can do this way or just use the api which would be easier.
    var contact : CNContact
//    let name : String
//    let phoneNumber : String
//    let address: String
    var hasFavorited : Bool
}
