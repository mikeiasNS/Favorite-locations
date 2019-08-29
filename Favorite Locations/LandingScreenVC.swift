//
//  ViewController.swift
//  Favorite Locations
//
//  Created by Mikeias Nascimento on 29/08/19.
//  Copyright © 2019 Critical Techworks. All rights reserved.
//

import UIKit
import Alamofire

class LandingScreenVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}
