//
//  String+Extension.swift
//  MovieList
//
//  Created by Toygun Çil on 11.08.2022.
//

import Foundation

//MARK: - Extensions
extension String {
    func localized() -> String {
        return NSLocalizedString(self,tableName: "Localizable",bundle: .main,value: self,comment: self)
    }
}
