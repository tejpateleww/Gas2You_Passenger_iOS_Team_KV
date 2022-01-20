//
//  addCardViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 26/11/21.
//

import Foundation
class addCardViewModel{
    var addCard : AddCardViewController?
    func webservieAddCard(number:String,name:String,expDate:String,cvv:String){
        let addcardData = AddCardReqModel()
        addcardData.customer_id = Singleton.sharedInstance.userId
        addcardData.card_number = number
        addcardData.name_on_card = name
        addcardData.expiry_date = expDate
        addcardData.cvv = cvv
        self.addCard?.btnAddCart.showLoading()
        WebServiceSubClass.AddCard(reqModel: addcardData, completion: { (status, apiMessage, response, error) in
            self.addCard?.btnAddCart.hideLoading()
            if !status{
                Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state: status ? .success : .failure){
                }
            }else{
                self.addCard?.navigationController?.popViewController(animated: true)
                
                self.addCard?.delegateAddcard.refreshCardListScreen()
                self.addCard?.clearAllTextFieldsAndSetDefaults()
            }
        })
    }
}
