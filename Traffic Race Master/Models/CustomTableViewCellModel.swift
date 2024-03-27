//
//  CustomTableViewCellModel.swift
//  Traffic Race Master
//
//  Created by XE on 20.03.2024.
//

import Foundation
import UIKit


struct CustomTableViewCellModel: Codable {
    var userName: String
    var userImageName: String
    var score: Int
    var date: String
    
    init(userName: String, userImageName: String, score: Int, date: String) {
        self.userName = userName
        self.userImageName = userImageName
        self.score = score
        self.date = date
    }
}

struct PersistenceManager {
    func save(from array: [CustomTableViewCellModel]) {
        let data = try? JSONEncoder().encode(array)
        
        UserDefaults.standard.set(data, forKey: .userInfoKey)
    }
    //
    func load() -> [CustomTableViewCellModel]? {
        guard let data = UserDefaults.standard.value(forKey: .userInfoKey) as? Data else {
            return nil
        }
        let array = try? JSONDecoder().decode([CustomTableViewCellModel].self, from: data)
        return array
    }
}
