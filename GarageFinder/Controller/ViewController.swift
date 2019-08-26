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
        view.backgroundColor = .blue
        
        //let post = MockPost(userId: 1, title: "foo", body: "bar")
        let comment = MockComment(name: "comentario")
        let service: GarageService = .postComment(comment: comment)
        let session = URLSessionProvider()
        session.request(type: MockComment.self, service: service) { (result) in
            switch result {
            case .success(let response):
                print("response \(response)")
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }

}
