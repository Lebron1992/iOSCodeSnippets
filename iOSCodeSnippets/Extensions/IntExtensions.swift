//
//  IntExtensions.swift
//  iOSCodeSnippets
//
//  Created by 曾文志 on 2020/9/30.
//  Copyright © 2020 Lebron. All rights reserved.
//

import Foundation

public extension Int {
    // Reference: https://gist.github.com/gbitaudeau/daa4d6dc46517b450965e9c7e13706a3
    private typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)

    func abbrevation() -> String? {
        let abbreviations: [Abbrevation] = [
            (0, 1, ""),
            (1000.0, 1000.0, "K"),
            (100_000.0, 1_000_000.0, "M"),
            (100_000_000.0, 1_000_000_000.0, "B")
        ]
        
        guard let abbreviation = abbreviations.last(where: { Double(abs(self)) >= $0.threshold }) else {
            return nil
        }
        
        let numFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.positiveSuffix = abbreviation.suffix
            formatter.negativeSuffix = abbreviation.suffix
            formatter.allowsFloats = true
            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 1
            return formatter
        }()
        
        let value = Double(self) / abbreviation.divisor
        return numFormatter.string(from: .init(value: value))
    }
}
