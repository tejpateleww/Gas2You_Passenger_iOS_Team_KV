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
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.Init.rawValue + Constants.kAPPVesion + "/" + Singleton.sharedInstance.userId , responseModel: InitResponseModel.self) { (status, message, response, error) in
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
    class func vehicleColorList(completion: @escaping (Bool, String, yearcolorstateListResModel?, Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.vehicleColorList.rawValue, responseModel: yearcolorstateListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func AddVehicleApi(reqModel : AddNewVehicleReqModel , completion: @escaping (Bool,String,AddVehicleResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.addVehicle.rawValue, requestModel: reqModel, responseModel: AddVehicleResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func DeleteVehicleApi(reqModel : deleteVehicleReqModel , completion: @escaping (Bool,String,RemoveVehicleResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.deleteVehicle.rawValue, requestModel: reqModel, responseModel: RemoveVehicleResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func EditVehicleApi(reqModel : EditNewVehicleReqModel , completion: @escaping (Bool,String,editVehicleResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.editVehicle.rawValue, requestModel: reqModel, responseModel: editVehicleResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func serviceList(completion: @escaping (Bool, String, serviceListResModel?, Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.serviceList.rawValue, responseModel: serviceListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func DateList(reqModel : DateReqModel,completion: @escaping (Bool, String, DateResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.dateList.rawValue, requestModel: reqModel, responseModel: DateResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func MemberPlanList(reqModel : memberListReqModel,completion: @escaping (Bool, String, membershipplanResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.memberPlan.rawValue, requestModel: reqModel, responseModel: membershipplanResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func CancelMemberPlan(reqModel : cancelMemberPlanReqModel,completion: @escaping (Bool, String, CancelMemberPlanResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.cancelPurchasePlan.rawValue, requestModel: reqModel, responseModel: CancelMemberPlanResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func purchaseMemberPlan(reqModel : purchaseMemberReqModel,completion: @escaping (Bool, String, purchaseMemberPlanResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.purchasePlan.rawValue, requestModel: reqModel, responseModel: purchaseMemberPlanResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func nonMemberPlanList(reqModel : nonMemberPlanListReqModel,completion: @escaping (Bool, String, nonMemberPlanListResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.nonMemberPlan.rawValue, requestModel: reqModel, responseModel: nonMemberPlanListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func checkTime(reqModel : CheckTimeReqModel,completion: @escaping (Bool, String, checktimeResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.checkbookingtime.rawValue, requestModel: reqModel, responseModel: checktimeResModel.self) { (status, message, response, error) in
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
    class func BookingDetail(reqModel : bookingDetailReqModel , completion: @escaping (Bool,String,BookingDetailResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.bookingDetail.rawValue, requestModel: reqModel, responseModel: BookingDetailResModel.self) { (status, message, response, error) in
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
    class func ChatList(completion: @escaping (Bool, String, chatListResModel?, Any) -> ()){
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.messageList.rawValue + Singleton.sharedInstance.userId, responseModel: chatListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func getChatHistoryApi(BookingId:String, completion: @escaping (Bool,String,chatHistoryResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.chatHistory.rawValue + BookingId, responseModel: chatHistoryResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func sendMsgAPI(reqModel : SendMsgReqModel , completion: @escaping (Bool,String,sendMessageResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.sendMesssage.rawValue, requestModel: reqModel, responseModel: sendMessageResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func CardList(reqModel : cardListReqModel , completion: @escaping (Bool,String,cardListResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.cardList.rawValue, requestModel: reqModel, responseModel: cardListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func DeleteCard(reqModel : DeleteCardReqModel , completion: @escaping (Bool,String,DeleteCardResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.deleteCardList.rawValue, requestModel: reqModel, responseModel: DeleteCardResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func AddCard(reqModel : AddCardReqModel , completion: @escaping (Bool,String,addCardResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.addCard.rawValue, requestModel: reqModel, responseModel: addCardResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func getNotificationListApi(reqModel : NotificationReqModel , completion: @escaping (Bool,String,notificationListResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.notificationList.rawValue, requestModel: reqModel, responseModel: notificationListResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func changeNotificationStatusApi(reqModel : NotificationStatusReqModel , completion: @escaping (Bool,String,LoginResponseModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.changeNotification.rawValue, requestModel: reqModel, responseModel: LoginResponseModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func addLocation(reqModel : AddLocationReqModel,completion: @escaping (Bool, String, AddLocationResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.addLocation.rawValue, requestModel: reqModel, responseModel: AddLocationResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func LocationList(reqModel : LocationListReqModel,completion: @escaping (Bool, String, AddLocationResModel?, Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.LocationList.rawValue, requestModel: reqModel, responseModel: AddLocationResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func Logout(completion: @escaping (Bool,String,logoutResModel?,Any) -> ()) {
        URLSessionRequestManager.makeGetRequest(urlString: ApiKey.logout.rawValue + Singleton.sharedInstance.userId, responseModel: logoutResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
    class func ConfirmCancemMemberShip(reqModel : cancelMembershipConfirmReqModel , completion: @escaping (Bool,String,CancelMemberConfirmResModel?,Any) -> ()){
        URLSessionRequestManager.makePostRequest(urlString: ApiKey.cancelMembershipConfirmation.rawValue, requestModel: reqModel, responseModel: CancelMemberConfirmResModel.self) { (status, message, response, error) in
            completion(status, message, response, error)
        }
    }
}

