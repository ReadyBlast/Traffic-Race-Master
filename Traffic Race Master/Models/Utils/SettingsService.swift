//
//  Settings.swift
//  Traffic Race Master
//
//  Created by XE on 20.03.2024.
//

import Foundation
import UIKit

private extension String {
    static let name: String = "Anonymous"
    static let userImageName: String = "pug"
    static let carImageName: String = "car"
    static let obstacleImageName: String = "car"
}

enum Difficulty: Double {
    case hard = 1
    case normal = 2
    case easy = 2.5
}

extension String {
    static func saveImageToFileManager(_ image: UIImage?) throws -> String?{
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = image?.jpegData(compressionQuality: CGFloat(NumericConstants.one)) else { return nil }
        let name  = UUID().uuidString
        let url = directory.appendingPathComponent(name)
        
        try data.write(to: url)
        
        return name
    }
}

final class SettingsService: Codable {
    var name: String = "Anonymous"
    var userImageName: String = "pug"
    var carImageName: String = "car"
    var obstacleImageName: String = "car"
    var difficulty: Double = Double(NumericConstants.one)
    
    func save(from settings: SettingsService) {
        let data = try? JSONEncoder().encode(settings)
        
        UserDefaults.standard.set(data, forKey: .settingsKey)
    }
    //
    func load() -> SettingsService? {
        guard let data = UserDefaults.standard.value(forKey: .settingsKey) as? Data else {
            return nil
        }
        let settings = try? JSONDecoder().decode(SettingsService.self, from: data)
        return settings
    }
}
