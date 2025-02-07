//
//  Extensions.swift
//  MovieClip
//
//  Created by 권정근 on 2/7/25.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
