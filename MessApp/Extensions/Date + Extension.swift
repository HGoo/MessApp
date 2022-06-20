//
//  Date + Extension.swift
//  MessApp
//
//  Created by Николай Петров on 17.06.2022.
//

import UIKit

extension Date {
    func getFormattedDate() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateformat.string(from: self)
    }
}
