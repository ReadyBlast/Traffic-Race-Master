//
//  UIImage+extension.swift
//  Traffic Race Master
//
//  Created by XE on 23.03.2024.
//

import Foundation
import UIKit

extension UIImage {
    static func loadImageFromFileManager(by name: String) -> UIImage? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let url = directory.appendingPathComponent(name)
        
        return UIImage(contentsOfFile: url.path)
    }
}
