//
//  UserDefault+Extension.swift
//  Gas 2 You Driver
//
//  Created by Gaurang on 03/09/21.
//

import Foundation
extension UserDefaults{
    func set<T: Codable>(object: T, forKey: String) throws {

        let jsonData = try JSONEncoder().encode(object)

        set(jsonData, forKey: forKey)
    }


    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {

        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }

        return try JSONDecoder().decode(objectType, from: result)
    }

    func setUserData() {
        try? UserDefaults.standard.set(object:  Singleton.sharedInstance.userProfilData, forKey: UserDefaultsKey.userProfile.rawValue)
    }

    func getUserData() -> ProfileModel? {
        let objResponse = try? UserDefaults.standard.get(objectType: ProfileModel.self, forKey:  UserDefaultsKey.userProfile.rawValue)
        Singleton.sharedInstance.userProfilData = objResponse
        Singleton.sharedInstance.userId = objResponse?.id ?? ""
        return objResponse ?? nil
    }

}
