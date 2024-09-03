//
//  String.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/4.
//

import Foundation

extension String {
    /// Trims whitespace and newline characters from the beginning and end of the string.
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Returns `true` if the string is not empty after trimming whitespace and newline characters.
    var isNotEmptyAfterTrimming: Bool {
        !self.trimmed().isEmpty
    }
}

