//
//  RootViewModel.swift
//  BancApp
//
//  Created by Alberto Moral on 5/5/16.
//  Copyright © 2016 Alberto Moral. All rights reserved.
//

import Foundation
import UIKit

protocol RootViewModelDelegate {
    func updateView()
}

class RootViewModel: NSObject {
    
    //  Delegate
    var delegate: RootViewModelDelegate!
    
    // Vars
    
    let maxChars: UInt = 256
    let estimateRowHeight: CGFloat = 85.0
    
    // Override Variables
    var options: NSArray = ["Cuentas", "Cuenta #1", "Cuenta #2"]
    //  Symbol to Detect Autocompletion
    var detectAutocompletion: [String] = ["#"]
    
    var searchResult = NSArray()
    var messages = [BancSabadellModel]()
    
    // Cell Info
    let bancSabadellCellNibName = "BancSabadellCell"
    let bancSabadellCellReuseIdentifier = "bancSabadellCell"
    
    let optionsCellNibName = "OptionCell"
    let optionsCellReuseIdentifier = "AutoCompletionCell"

    
    /// MARK: Methods
    func arrayWithCoincidences(prefix: String, word: String) -> [String]? {
        
        searchResult = [String]()
        
        guard prefix == "#" else {
            return nil
        }
        
        if (prefix == "#") {
            let arrayWithAutocompletion = (word.characters.count > 0) ?
                options.filteredArrayUsingPredicate(NSPredicate(format:"self BEGINSWITH[c] %@", word)) as! [String]
                :
                options as! [String]
            
            searchResult = NSArray(array: arrayWithAutocompletion)
            return arrayWithAutocompletion
        } else {
            return nil
        }
    }
    
    func showAutocompletation() -> Bool {
        return searchResult.count > 0
    }
    
    func detectOptionSelected(prefix: String, range: NSRange, atIndexPath indexPath: NSIndexPath) -> String {
        
        guard let optionName = searchResult[indexPath.row] as? String else { return "" }
        
        if (prefix == "#" && range.location == 0) {
            
            switch optionName {
            case "Cuentas":
                print("Option #1")
                let accountResource: Resource<AccountsModel> = Resource(pathComponent: "\(APIConstants.APIEndPoint()!+APIConstants.APIPathAccounts()!)")
                accountResource.loadAsynchronous(AccountsModel.self) { x in
                    print(x)
                    
                    for account in x.data! {
                        let newAccount = BancSabadellModel()
                        newAccount.balance = account.balance
                        newAccount.descriptionAccount = account.description
                        newAccount.iban = account.iban
                        newAccount.producto = account.producto
                        
                        self.messages.append(newAccount)
                    }
                    
                    self.delegate.updateView()
                }
            case "Cuenta #1":
                print("Option #2")
            case "Cuenta #2":
                print("Option #3")
            default:
                print("No code")
            }
        }
        
        return optionName
    }
}
