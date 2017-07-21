//
//  String+Extensions.swift
//  Personal-Compass
//
//  Created by Philip Dow on 6/12/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation

extension String {
    var isEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
