//
//  ViewController.swift
//  BancApp
//
//  Created by Alberto Moral on 5/5/16.
//  Copyright © 2016 Alberto Moral. All rights reserved.
//

import UIKit

class ViewController: RootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAccounts()
    }
    
    func getAccounts() {
        let accountResource: Resource<AccountsModel> = Resource(pathComponent: "\(APIConstants.APIEndPoint()!+APIConstants.APIPathAccounts()!)")
        
        accountResource.loadAsynchronous(AccountsModel.self) { x in
            print(x)
            guard let value = x.data else {
                return
            }
            print("Value \(value)")
        }
    }
}
