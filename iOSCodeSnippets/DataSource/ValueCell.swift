//
//  ValueCell.swift
//  Daily Pickem
//
//  Created by 曾文志 on 2019/7/19.
//  Copyright © 2019 Lebron. All rights reserved.
//

import UIKit

protocol ValueCell: class {
    associatedtype Value
    static var defaultReusableId: String { get }
    func configureWith(value: Value)
}
