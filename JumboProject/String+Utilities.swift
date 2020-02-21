//
//  String+Utilities.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/20/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import Foundation

/// We need to parse JSON String to Dic
extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}


