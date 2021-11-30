//
//  cardListViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 25/11/21.
//

import Foundation
class cardListViewModel{
    var cardList : PaymentMethodVC?
    func webserviceCardList() {
        let cardList = cardListReqModel()
        cardList.customer_id = Singleton.sharedInstance.userId
        WebServiceSubClass.CardList(reqModel: cardList, completion: { (status, apiMessage, response, error)  in
            if status{
                // print(response)
                if let userdevice =  response?.data
                {
                    self.cardList?.arrCardList = userdevice
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
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: status ? apiMessage : apiMessage, state: status ? .success : .failure){
                if status{
                    self.cardList?.cardListModel.webserviceCardList()
                }
            }
        })
    }
    func doAddBooking(customerid: String, serviceid: String, subserviceid: String, parkinglocation: String, lat: String, lng: String, date: String, time: String, vehicleid: String, totalAmount: String, addonid: String,card_id:String) {
        let reqModel = AddBookingReqModel(customerid: customerid, serviceid: serviceid, subserviceid: subserviceid, parkinglocation: parkinglocation, lat: lat, lng: lng, date: date, time: time, vehicleid: vehicleid, totalAmount: totalAmount, addonid: addonid, card_id: card_id)
            webserviceAddBooking(reqModel)
    }
    func webserviceAddBooking(_ reqModel: AddBookingReqModel){
        
        WebServiceSubClass.addBooking(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
           
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: status ? "Your service has been booked successfully" : apiMessage, state: status ? .success : .failure){
                if status{
                    let myOrdersVC: MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
                    myOrdersVC.isFromPayment = true
                    self.cardList?.navigationController?.pushViewController(myOrdersVC, animated: true)
                }
            }
        })
    }
    func webserviceMemberPlanPurchase(planID:String,cardId:String){
        let memberPlan = purchaseMemberReqModel()
        memberPlan.customer_id = Singleton.sharedInstance.userId
        memberPlan.plan_id = planID
        memberPlan.card_id = cardId
        WebServiceSubClass.purchaseMemberPlan(reqModel: memberPlan, completion: { (status, apiMessage, response, error) in
                if status{
                    Singleton.sharedInstance.userProfilData?.type = self.cardList?.memberDataModel?.type
                    Singleton.sharedInstance.userProfilData?.amount = self.cardList?.memberDataModel?.amount//memberplanvc?.memberPlanList[self.memberplanvc?.selectedIndex ?? 0].price ?? ""
                    Singleton.sharedInstance.userProfilData?.expiry_date = response?.data?.expiryDate
                    Singleton.sharedInstance.userProfilData?.is_membership_user = true
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
