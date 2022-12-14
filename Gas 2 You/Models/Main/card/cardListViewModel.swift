//
//  cardListViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 25/11/21.
//

import Foundation
class cardListViewModel{
    var cardList : PaymentMethodVC?
    var todaysDate = Date()
    func webserviceCardList() {
        let cardList = cardListReqModel()
        cardList.customer_id = Singleton.sharedInstance.userId
        WebServiceSubClass.CardList(reqModel: cardList, completion: { (status, apiMessage, response, error)  in
            if status{
                // print(response)
                if let userdevice =  response?.data
                {
                    self.cardList?.arrCardList = userdevice
                    self.cardList?.isLoading = false
                    self.cardList?.isReload = true
                    self.cardList?.tblPaymentMethod.reloadData()
                }
            }
        })
    }
    func webserviceDeleteCard(cardId:String){
        let deleteCard = DeleteCardReqModel()
        deleteCard.customer_id = Singleton.sharedInstance.userId
        deleteCard.card_id = cardId
        WebServiceSubClass.DeleteCard(reqModel: deleteCard, completion: { (status, apiMessage, response, error)  in
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: status ? apiMessage : apiMessage, state: status ? .success : .failure){
                if status{
                    self.cardList?.cardListModel.webserviceCardList()
                }
            }
        })
    }
    
    func doAddBooking(customerid: String, serviceid: String, subserviceid: String, parkinglocation: String, lat: String, lng: String, date: String, time: String, vehicleid: String, totalAmount: String, addonid: String,card_id:String,note:String) {
        let reqModel = AddBookingReqModel(customerid: customerid, serviceid: serviceid, subserviceid: subserviceid, parkinglocation: parkinglocation, lat: lat, lng: lng, date: date, time: time, vehicleid: vehicleid, totalAmount: totalAmount, addonid: addonid, card_id: card_id, note: note)
            webserviceAddBooking(reqModel)
    }
    
    func webserviceAddBooking(_ reqModel: AddBookingReqModel){
        Utilities.showHud()
        WebServiceSubClass.addBooking(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state: status ? .success : .failure)
            }
            if status{
                NotificationCenter.default.post(name: .clearAddonArray, object: nil)
                self.cardList?.navigationController?.popToRootViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: .goToUpcomingOrderScreen, object: nil)
                }
            }
        })
    }
    func webserviceMemberPlanPurchase(planID:String,cardId:String){
        let memberPlan = purchaseMemberReqModel()
        memberPlan.customer_id = Singleton.sharedInstance.userId
        memberPlan.plan_id = planID
        memberPlan.card_id = cardId
        Utilities.showHud()
        WebServiceSubClass.purchaseMemberPlan(reqModel: memberPlan, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state: status ? .success : .failure)
            }
                if status{
                    NotificationCenter.default.post(name: .clearAddonArray, object: nil)
                    userDefault.setValue(response?.data?.isMembershipUser, forKey: UserDefaultsKey.MemberPlan.rawValue)
                    Singleton.sharedInstance.userProfilData?.type = self.cardList?.memberDataModel?.type
                    Singleton.sharedInstance.userProfilData?.amount = self.cardList?.memberDataModel?.amount
                    Singleton.sharedInstance.userProfilData?.expiry_date = response?.data?.expiryDate
                    Singleton.sharedInstance.userProfilData?.is_membership_user = true
                    userDefault.setUserData()//memberplanvc?.memberPlanList[self.memberplanvc?.selectedIndex ?? 0].price ?? ""
                    NotificationCenter.default.post(name: notifRefreshHomeScreen, object: nil)
                    if self.cardList?.isfromMember == true{
                        self.popToMyProfile()
                    }else{
                        self.cardList?.navigationController?.popViewController(animated: true)
                    }
                }
        })
    }
    
    private func popToMyProfile() {
        guard let navVC = self.cardList?.navigationController,
              let profileVC = navVC.viewControllers.first(where: {$0.isKind(of: MyProfileVC.self)}) as? MyProfileVC else {
            return
        }
        profileVC.setData()
        navVC.popToViewController(profileVC, animated: true)
        
    }
}
