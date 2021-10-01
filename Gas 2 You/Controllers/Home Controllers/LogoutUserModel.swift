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
        WebServiceSubClass.Logout { (status, message, response, error) in
            if status{
                self.menuViewController?.DoLogoutFinal()
            }else{
                Toast.show(title: UrlConstant.Failed, message: message, state: .failure)
            }
        }
    }
}
