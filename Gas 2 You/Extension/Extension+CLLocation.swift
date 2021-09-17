//
//  Extension+CLLocation.swift
//  Danfo_Driver
//
//  Created by Sj's iMac on 08/04/21.
//

import Foundation
import CoreLocation
import GoogleMaps

extension CLLocationCoordinate2D {
    func getGMSCameraPosition(zoom: Float = 10) -> GMSCameraPosition {
        GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: zoom)
    }
}

//extension CLLocation {
//    func fetchCityAndCountry(completion: @escaping (_ address:  String?, _ error: Error?) -> ()) {
//
//        GMSGeocoder().reverseGeocodeCoordinate(coordinate) { (response, error) in
//            if let address = response?.results() {
//                guard error == nil else {
//                    completion("",error)
//                    return
//                }
//                if let addressNew = address.first?.lines {
//                    completion(self.makeAddressString(inArr: addressNew), nil)
//                }
//            }
//        }
//    }
//
//    func makeAddressString(inArr:[String]) -> String {
//        var fVal:String = ""
//        for val in inArr {
//            fVal =  fVal + val + " "
//        }
//        return fVal
//    }
//}
//
//
