//
//  EntryViewStyle.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/01/2024.
//

import Foundation
import UIKit

/// Describes of an appearence lifecycle for a label.
public protocol EntryViewStyle {

    func onSetStyle(_ label: VKLabel)

    func onUpdateSelectedState(_ label: VKLabel)

    func onUpdateErrorState(_ label: VKLabel)

    func onLayoutSubviews(_ label: VKLabel)
}

public extension EntryViewStyle {

    func animateSelection(keyPath: String, values: [Any]) -> CAKeyframeAnimation {

        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.duration = 1.0
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.values = values
        return animation
    }
}
