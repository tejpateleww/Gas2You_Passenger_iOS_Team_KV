                                                                                                                           //
//  serviceListViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 22/09/21.
//

import Foundation
class ServiceListViewModel{
    weak var serviceList : HomeVC?
    var todaysDate = NSDate()
    
    func webserviceofserviceList(){
        WebServiceSubClass.serviceList(completion: { (status, message, response, error) in
            if status{
                if let model = response?.data{
                    self.serviceList?.serviceList = model
                    if model.count != 0{
                        self.serviceList?.txtSelectedService.text = model[0].name
                        self.serviceList?.priceTagLabel.text = CurrencySymbol + (model[0].price ?? "")
                        self.serviceList?.serviceid = model[0].id ?? ""
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
    
    func webserviceofDateList(booking_date:String , isFromToday : Bool){
        let dateList = DateReqModel()
        dateList.user_id = Singleton.sharedInstance.userId
        dateList.booking_date = booking_date
        WebServiceSubClass.DateList(reqModel: dateList, completion: { (status, message, response, error) in
            if status{
                if let model = response{
                    
                    if model.availableDates?.count != 0{
                        self.serviceList?.availableDate = model.availableDates ?? []
                        if isFromToday == true {
                            if model.currentDate == ""{
                                let today = Date()
                                let strDate = self.serviceList?.dateFormatter.string(from: today)
                                self.serviceList?.txtDateSelected.text = strDate
                            }else{
                                self.serviceList?.txtDateSelected.text =  self.serviceList?.convertDateFormat(inputDate: Singleton.sharedInstance.appInitModel?.currentDate ?? "")//Singleton.sharedInstance.appInitModel?.currentDate//model.currentDate
                            }
                            //self.serviceList?.dateFormatter.string(from: today)
                        }
                    }else{
                        self.serviceList?.availableDate =  model.availableDates ?? []
                        if model.currentDate == ""{
                            let today = Date()
                            let strDate = self.serviceList?.dateFormatter.string(from: today)
                            self.serviceList?.availableDate.append(strDate ?? "")
                            self.serviceList?.txtDateSelected.text = strDate
                        }else{
                            self.serviceList?.txtDateSelected.text = self.serviceList?.convertDateFormat(inputDate: Singleton.sharedInstance.appInitModel?.currentDate ?? "")//Singleton.sharedInstance.appInitModel?.currentDate//self.serviceList?.convertDateFormat(inputDate: model.currentDate ?? "")
                        }//self.serviceList?.convertDateFormat(inputDate: strDate ?? "")
                    }
                    if model.data?.count == 0{
                        Toast.show(title: UrlConstant.ResponseMessage, message: "No time slot available", state: .info)
                        self.serviceList?.collectionTimeList.isHidden = true
                    }else{
                        self.serviceList?.arrTimeList = model.data ?? []
                        self.serviceList?.collectionTimeList.isHidden = false
                    }
                    
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
