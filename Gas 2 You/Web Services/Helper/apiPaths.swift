//
//  apiPaths.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 04/06/21.
//

import Foundation

typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())
enum APIEnvironment : String {
 
//Development URL : Pick A Ride Customer
    case AssetsUrl = "http://65.1.154.172/"
    case Development = "https://gas2youcenla.com/api/customer_api/"
    case Profilebu = "http://65.1.154.172/api/"
    case Live = "not provided"
     
    static var baseURL: String{
        return APIEnvironment.environment.rawValue
    }
    
    static var environment: APIEnvironment{
        return .Development
    }
    
    static var headers : [String:String]{
        if Constants.userDefaults.object(forKey: UserDefaultsKey.isUserLogin.rawValue) != nil {
            
            if Constants.userDefaults.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == true {
                
                if Constants.userDefaults.object(forKey:  UserDefaultsKey.userProfile.rawValue) != nil {
                    do {
                        if UserDefaults.standard.value(forKey: UserDefaultsKey.X_API_KEY.rawValue) != nil, UserDefaults.standard.value(forKey:  UserDefaultsKey.isUserLogin.rawValue) as? Bool ?? Bool(){
                            return [UrlConstant.HeaderKey : UrlConstant.AppHostKey, UrlConstant.XApiKey : Singleton.sharedInstance.userProfilData?.xAPIKey ?? ""]
                        }else{
                            return [UrlConstant.HeaderKey : UrlConstant.AppHostKey]
                        }
                    }
                }
            }
        }
        return [UrlConstant.HeaderKey : UrlConstant.AppHostKey]
    }
}

enum ApiKey: String {
    case Init               = "init/ios_customer/"
    case login              = "login"
    case register           = "register"
    case socialLogin        = "social_login"
    case appleDetail        = "apple_details"
    case changePassword     = "change_password"
    case forgotPassword     = "forgot_password"
    case registerOtp        = "register_otp"
    case profileUpdate      = "profile_update"
    case vehicleList        = "vehicle_list"
    case yearlist           = "year_list"
    case MakeAndModelList   = "vehicle_manufacturer_list"
    case vehicleColorList   = "vehicle_color_list"
    case addVehicle         = "add_vehicle"
    case deleteVehicle      = "remove_vehicle"
    case editVehicle        = "edit_vehicle"
    case serviceList        = "service_type_list"
    case dateList           = "get_time_slot"
    case memberPlan         = "membership_plan_list"
    case nonMemberPlan      = "non_membership_plan_list"
    case AddBooking         = "add_booking"
    case bookingList        = "booking_list"
    case bookingDetail      = "get_order_detail"
    case cancelOrder        = "cancel_order"
    case rateAndreview      = "add_booking_review"
    case messageList        = "message_list/"
    case chatHistory        = "chat_history/"
    case sendMesssage       = "send_message"
    case logout             = "logout/"
}

 

enum SocketKeys: String {
    
    case KHostUrl           = "http://50.18.114.231:8080/"
    case ConnectUser        = "connect_user"
    case channelCommunation = "communication"
    case SendMessage        = "send_message"
    case ReceiverMessage    = "receiver_message"
    
}
