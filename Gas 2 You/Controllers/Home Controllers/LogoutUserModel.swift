//
//  LogoutUserModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 23/09/21.
//

import Foundation
import UIKit

class LogoutUserModel{
    
    weak var menuViewController : LeftViewController?
    
    func webserviceForLogout(){
        Utilities.showHud()
        WebServiceSubClass.Logout { (status, message, response, error) in
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: message, state: status ? .success : .failure){
                Utilities.hideHud()
                if status{
                    self.menuViewController?.DoLogoutFinal()
                }
            }
        }
    }
}
