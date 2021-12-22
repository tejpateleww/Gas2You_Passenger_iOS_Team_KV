//
//  SocialSignInManager.swift
//  ClothesLyne
//
//  Created by Apple on 09/05/21.
//

import Foundation
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit
import UIKit

class SocialUser: Codable{
    var userId : String?
    var token : String?
    var firstName : String?
    var lastName : String?
    var email : String?
    var profile : String?
    var socialType : String?
}

enum LoginResult {
    case success((SocialUser, String))
    case failure(String)
}

enum SocialType: String {
    case Apple = "apple"
    case Google = "google"
    case FaceBook = "facebook"
}

protocol SocialSignInDelegate{
    func FetchUser(socialType: SocialType, success: Bool, user: SocialUser?, error: String?)
}

class FacebookLoginProvider {
    private let loginManager: LoginManager = LoginManager()
    private let viewController: UIViewController
    var delegate : SocialSignInDelegate? = nil

    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func fetchToken(from viewController: UIViewController) {
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: viewController) { result in
            switch result {
            case .cancelled:
                self.delegate?.FetchUser(socialType: .FaceBook, success: false, user: nil, error: "Cancelled")
            case .failed(let error):
                self.delegate?.FetchUser(socialType: .FaceBook, success: false, user: nil, error: error.localizedDescription)
            case .success(_, _, let authToken):
                self.getFBUserDetail(VC: viewController, token: authToken?.tokenString ?? "") { (user, error) in
                    self.delegate?.FetchUser(socialType: .FaceBook, success: error == nil, user: user, error: error)
                }
            }
        }
    }
    
    func getFBUserDetail(VC: UIViewController, token: String, completion: @escaping (_ user: SocialUser?, _ error: String?)-> Void){
        let parameters = ["fields" : "email, name, first_name, last_name, picture.type(large)"]
        GraphRequest(graphPath: "me", parameters: parameters).start { (connection, conresult, error) in
            if let Err = error{
                completion(nil, Err.localizedDescription)
            }else{
                if let result = conresult, let dataDic = result as? [String: Any]{
                    let obj = SocialUser()
                    obj.socialType = SocialType.FaceBook.rawValue
                    obj.userId = dataDic["id"] as? String ?? ""
                    obj.token = token
                    obj.firstName = dataDic["first_name"] as? String ?? ""
                    obj.lastName = dataDic["last_name"] as? String ?? ""
                    obj.email = dataDic["email"] as? String ?? ""
                    if let profileDic = dataDic["picture"] as? [String: Any], let dataDic = profileDic["data"] as? [String: Any], let profileUrl = dataDic["url"] as? String{
                        obj.profile = profileUrl
                    }
                    completion(obj, nil)
                }
            }
        }
    }
}

//class GoogleLoginProvider: NSObject {
//
//    var delegate : SocialSignInDelegate? = nil
//
//    init(_ viewController: UIViewController) {
//        super.init()
//        GIDSignIn.sharedInstance()?.presentingViewController = viewController
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance()?.signIn()
//    }
//}
//
//extension GoogleLoginProvider: GIDSignInDelegate {
//     @objc func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        guard error == nil else {
//            let errorCode = (error as NSError).code
//            if let signInError = GIDSignInErrorCode(rawValue: errorCode) {
//                if case .canceled = signInError {
//                    self.delegate?.FetchUser(socialType: .Google, success: false, user: nil, error: "Cancelled")
//                    return
//                }
//            }
//
//            self.delegate?.FetchUser(socialType: .Google, success: false, user: nil, error: error.localizedDescription)
//            return
//        }
//
//        let obj = SocialUser()
//        obj.socialType = SocialType.Google.rawValue
//        obj.userId = user.userID
//        obj.token = user.authentication.idToken
//        obj.email = user.profile.email
//        obj.firstName = user.profile.givenName ?? ""
//        obj.lastName = user.profile.familyName ?? ""
//        obj.profile = user.profile.imageURL(withDimension: 200)?.absoluteString ?? ""
//
//        self.delegate?.FetchUser(socialType: .Google, success: true, user: obj, error: nil)
//    }
//}

class GoogleLoginProvider: NSObject {
    
    var delegate : SocialSignInDelegate? = nil
    
    init(_ viewController: UIViewController) {
        super.init()
        
        GIDSignIn.sharedInstance.signIn(with: AppDel.signInConfig, presenting: viewController) { user, error in
            if let err = error {
                self.delegate?.FetchUser(socialType: .Google, success: false, user: nil, error: err.localizedDescription)
                return
            }else if let userObj = user{
                let obj = SocialUser()
                obj.socialType = SocialType.Google.rawValue
                obj.userId = userObj.userID
                obj.token = userObj.authentication.idToken
                obj.email = userObj.profile?.email
                obj.firstName = userObj.profile?.givenName
                obj.lastName = userObj.profile?.familyName
                obj.profile = userObj.profile?.imageURL(withDimension: 200)?.absoluteString
                
                self.delegate?.FetchUser(socialType: .Google, success: true, user: obj, error: nil)
            }else{
                self.delegate?.FetchUser(socialType: .Google, success: false, user: nil, error: UrlConstant.SomethingWentWrong)
                return
            }
        }
    }
}


class AppleSignInProvider: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
   
    var delegate : SocialSignInDelegate? = nil

    override init() {
        super.init()
        if #available(iOS 13.0, *) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        }
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }
    
    // ASAuthorizationControllerDelegate function for authorization failed
  @available(iOS 13.0, *)
     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
         print(error.localizedDescription)
        delegate?.FetchUser(socialType: .Apple, success: false, user: nil, error: error.localizedDescription)
     }
     
     @available(iOS 13.0, *)
     // ASAuthorizationControllerDelegate function for successful authorization
     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
         print(#function)
         if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
             let appleId = appleIDCredential.user
             let appleUserFirstName = appleIDCredential.fullName?.givenName
             let appleUserLastName = appleIDCredential.fullName?.familyName
             let appleUserEmail = appleIDCredential.email
             print(appleId, appleUserFirstName ?? "", appleUserLastName ?? "", appleUserEmail ?? "")
            
            let socialUser = SocialUser()
            socialUser.firstName = appleUserFirstName ?? ""
            socialUser.lastName = appleUserLastName ?? ""
            socialUser.email = appleUserEmail
            socialUser.userId = appleId
            socialUser.socialType = SocialType.Apple.rawValue
            delegate?.FetchUser(socialType: .Apple, success: true, user: socialUser, error: nil)
         }
         else if let passwordCredential = authorization.credential as? ASPasswordCredential {
             let appleUsername = passwordCredential.user
             let applePassword = passwordCredential.password
             print(appleUsername, applePassword)
         }else{
            print("Can not get apple credentials")
            print("Error: \("Can not get apple credentials")")
        }
     }
    
    
}
