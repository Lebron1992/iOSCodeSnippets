//
//  App.swift
//  iOSCodeSnippets
//
//  Created by 曾文志 on 2020/9/15.
//  Copyright © 2020 Lebron. All rights reserved.
//

import Foundation

public enum App {
    static let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let currentVersionDescription = "\(versionNumber ?? "")(\(buildNumber ?? ""))"
}
