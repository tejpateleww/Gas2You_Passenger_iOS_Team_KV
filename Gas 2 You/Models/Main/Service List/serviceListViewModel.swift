                                                                                                                           //
//  serviceListViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 22/09/21.
//

import Foundation
class ServiceListViewModel{
    weak var serviceList : HomeVC?
    func webserviceofserviceList(){
        WebServiceSubClass.serviceList(completion: { (status, message, response, error) in
            if status{
                if let model = response?.data{
                    self.serviceList?.serviceList = model
                    if model.count != 0{
                        self.serviceList?.txtSelectedService.text = model[0].name
                        self.serviceList?.priceTagLabel.text = CurrencySymbol + (model[0].price ?? "")
                        self.serviceList?.serviceid = model[0].id ?? ""
                        self.serviceList?.SelectIndex = 0
                        if model[0].subServices?.count != 0{
                            self.serviceList?.selectedIndex = 0
                            if model[self.serviceList?.selectedIndex ?? 0].subServices?.count ?? 0 > 2{
                                self.serviceList?.imgSubserviceArrow.isHidden = false
                            }else{
                                self.serviceList?.imgSubserviceArrow.isHidden = true
                            }
                            self.serviceList?.ViewForShowPrice.isHidden = false
                            self.serviceList?.collectionViewSubService.reloadData()
                        }else{
                            self.serviceList?.LblOctane.text = model[0].name
                            self.serviceList?.ViewForShowPrice.isHidden = true
                            self.serviceList?.serviceid = model[0].id ?? ""
                            self.serviceList?.priceTagLabel.text = CurrencySymbol + (model[0].price ?? "")
                        }
                    }else{
                        self.serviceList?.gasServiceView.isHidden = true
                    }
                    if let bodyDic = try? response.asDictionary(){
                        print("res: \(bodyDic)")
                    }
                }
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
            
            self.serviceList?.collectionViewSubService.reloadData()
        })
    }
    
    func webserviceofDateList(bookingdate:String){
        let dateList = DateReqModel()
        dateList.user_id = Singleton.sharedInstance.userId
        dateList.booking_date = bookingdate
        WebServiceSubClass.DateList(reqModel: dateList, completion: { (status, message, response, error) in
            if status{
                if let model = response{
                    self.serviceList?.arrTimeList = model.data ?? []
                    self.serviceList?.availableDate = model.availableDates ?? []
                    self.serviceList?.selectedDate.text = model.availableDates?[0]
                    self.serviceList?.collectionTimeList.reloadData()
                }
                
            }else{
                Utilities.ShowAlert(OfMessage: "No Data Found")
                print(error)
            }
            
            self.serviceList?.collectionViewSubService.reloadData()
        })
    }
    
}
