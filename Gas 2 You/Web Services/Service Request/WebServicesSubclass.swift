//
//  WebServicesSubclass.swift
//  Gas 2 You Driver
//
//  Created by Tej on 31/08/21.
//

import Foundation
import UIKit

class WebServiceSubClass{
    
    //MARK:- Init
    class func InitApi(completion: @escaping (Bool, String, InitResponseModel?, Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.Init.rawValue + Constants.kAPPVesion, responseModel: InitResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }

    //MARK:- Auth
    class func LoginApi(reqModel: LoginRequestModel, completion: @escaping (Bool,String,LoginResponseModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.login.rawValue, requestModel: reqModel, responseModel: LoginResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }

    class func ChangePasswordApi(reqModel : ChangePasswordReqModel , completion: @escaping (Bool,String,PasswordResponseModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.changePassword.rawValue, requestModel: reqModel, responseModel: PasswordResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }

    class func ForgotPasswordApi(reqModel : ForgotPasswordReqModel , completion: @escaping (Bool,String,PasswordResponseModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.forgotPassword.rawValue, requestModel: reqModel, responseModel: PasswordResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }

    class func SocialLoginApi(reqModel : SocialLoginRequestModel , completion: @escaping (Bool,String,LoginResponseModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.socialLogin.rawValue, requestModel: reqModel, responseModel: LoginResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    class func AppleDetailApi(reqModel : appleDetailReqModel , completion: @escaping (Bool,String,appleLoginResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.appleDetail.rawValue, requestModel: reqModel, responseModel: appleLoginResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    
    class func otpRequestApi(reqModel : OTPRequestModel , completion: @escaping (Bool,String,OTPResponseModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.registerOtp.rawValue, requestModel: reqModel, responseModel: OTPResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }

    class func RegisterApi(reqModel : RegisterRequestModel , completion: @escaping (Bool,String,LoginResponseModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.register.rawValue, requestModel: reqModel, responseModel: LoginResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func UpdateProfileInfo( reqModel : UpdateProfileRequestModel  ,completion: @escaping (Bool,String,LoginResponseModel?,Any) -> () ) {
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.profileUpdate.rawValue, requestModel: reqModel, responseModel: LoginResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func vehicalList(reqModel : vehicalListReqModel , completion: @escaping (Bool,String,vehicalListResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.vehicleList.rawValue, requestModel: reqModel, responseModel: vehicalListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func makeandmodelList(completion: @escaping (Bool, String, menufactureResModel?, Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.MakeAndModelList.rawValue, responseModel: menufactureResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func vehicleColorList(completion: @escaping (Bool, String, vehicleColorListResModel?, Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.vehicleColorList.rawValue, responseModel: vehicleColorListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func AddVehicleApi(reqModel : AddVehicleReqModel , completion: @escaping (Bool,String,AddVehicleResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.addVehicle.rawValue, requestModel: reqModel, responseModel: AddVehicleResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func DeleteVehicleApi(reqModel : deleteVehicleReqModel , completion: @escaping (Bool,String,RemoveVehicleResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.deleteVehicle.rawValue, requestModel: reqModel, responseModel: RemoveVehicleResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func EditVehicleApi(reqModel : EditVehicleReqModel , completion: @escaping (Bool,String,editVehicleResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.editVehicle.rawValue, requestModel: reqModel, responseModel: editVehicleResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func serviceList(completion: @escaping (Bool, String, serviceListResModel?, Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.serviceList.rawValue, responseModel: serviceListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func MemberPlanList(reqModel : memberListReqModel,completion: @escaping (Bool, String, membershipplanResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.bookingDetail.rawValue, requestModel: reqModel, responseModel: membershipplanResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func nonMemberPlanList(completion: @escaping (Bool, String, nonMemberPlanListResModel?, Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.nonMemberPlan.rawValue, responseModel: nonMemberPlanListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func addBooking(reqModel : AddBookingReqModel,completion: @escaping (Bool, String, addBookingResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.AddBooking.rawValue, requestModel: reqModel, responseModel: addBookingResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func BookingList(reqModel : bookingListReqModel , completion: @escaping (Bool,String,BookingListResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.bookingList.rawValue, requestModel: reqModel, responseModel: BookingListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func BookingDetail(reqModel : bookingDetailReqModel , completion: @escaping (Bool,String,bookingDetailResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.bookingDetail.rawValue, requestModel: reqModel, responseModel: bookingDetailResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func rateandreview(reqModel : rateReqModel , completion: @escaping (Bool,String,rateResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.rateAndreview.rawValue, requestModel: reqModel, responseModel: rateResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func cancelOrder(reqModel : CancelOrderReqModel , completion: @escaping (Bool,String,CancelOrderResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.cancelOrder.rawValue, requestModel: reqModel, responseModel: CancelOrderResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func Logout(completion: @escaping (Bool,String,logoutResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.logout.rawValue + Singleton.sharedInstance.userId, responseModel: logoutResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
}

