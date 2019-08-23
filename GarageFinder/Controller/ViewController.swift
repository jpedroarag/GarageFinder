//
//  ViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 19/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = MockPost(id: 1, title: "foo", body: "bar")
        let service: GarageService = .comment(id: 3)
        let session = URLSessionProvider()
        session.request(type: MockComment.self, service: service) { (result) in
            switch result {
            case .success(let response):
                print("response \(response)")
            case .failure(let error):
                print(error)
            }
        }
    }

}
