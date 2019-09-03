//
//  Location.swift
//  Favorite Locations
//
//  Created by Mikeias Nascimento on 03/09/19.
//  Copyright © 2019 Critical Techworks. All rights reserved.
//

import RealmSwift
class Location: Object {
    @objc dynamic var locationId = ""
    @objc dynamic var address = ""
    @objc dynamic var postalCode = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
}
