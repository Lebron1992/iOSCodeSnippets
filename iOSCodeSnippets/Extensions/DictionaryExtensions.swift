//
//  DictionaryExtensions.swift
//  iOSCodeSnippets
//
//  Created by 曾文志 on 2020/9/29.
//  Copyright © 2020 Lebron. All rights reserved.
//

import Foundation

extension Dictionary {
    func withAllValuesFrom(_ other: Dictionary) -> Dictionary {
        var result = self
        other.forEach { result[$0] = $1 }
        return result
    }
}
