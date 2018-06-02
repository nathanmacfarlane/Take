//
//  User.swift
//  Take
//
//  Created by Family on 5/23/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation
import UIKit

class User {
    var name                : String
    var membershipDate      : Date
    var location            : String
    var profileImage        : UIImage?
    var favorites           : [Route]
    var todos               : [Route]
    var ticks               : [Tick]
    
    init(name : String, location : String, profileImage : UIImage?) {
        self.name           = name
        self.membershipDate = Date()
        self.location       = location
        self.profileImage   = profileImage
        self.favorites      = []
        self.todos          = []
        self.ticks          = []
    }
    
}
