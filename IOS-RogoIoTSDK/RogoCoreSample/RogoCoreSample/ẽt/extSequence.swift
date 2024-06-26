//
//  extSequence.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 18/03/2024.
//

import Foundation
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
