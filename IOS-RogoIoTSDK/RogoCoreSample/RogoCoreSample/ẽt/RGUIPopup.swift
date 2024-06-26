//
//  RGUIPopup.swift
//  ThinkEdge
//
//  Created by Willer Swift on 03/07/2023.
//

import Foundation
import SwiftEntryKit

enum RGUIPopupAttributes {
    case top
    case center
    case bottom
    
    fileprivate func attributes(contentViewRect: CGRect? = nil,
                                screenInteraction: EKAttributes.UserInteraction = .dismiss) -> EKAttributes {
        var attributes = EKAttributes()
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(
            gradient: .init(
                colors: [EKColor(rgb: 0xffffff), EKColor(rgb: 0xfffff9)],
                startPoint: .zero,
                endPoint: CGPoint(x: 1, y: 1)
            )
        )
        attributes.screenBackground = .color(color: EKColor(light: UIColor(white: 50.0/255.0, alpha: 0.5),
        dark: UIColor(white: 0, alpha: 0.5)))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        attributes.screenInteraction = screenInteraction
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
//            .enabled(
//            swipeable: true,
//            pullbackAnimation: .jolt
//        )
        attributes.entryBackground = .clear
        attributes.roundCorners = .all(radius: 8)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 0.8, initialVelocity: 0)
            ),
            scale: .init(
                from: 0.7,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.35)
            )
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.minEdge),
            height: .intrinsic
        )
        attributes.positionConstraints.size = .init(
            width: .offset(value: 10),
            height: (contentViewRect != nil) ? .constant(value: contentViewRect!.size.height) : .intrinsic
        )
        attributes.windowLevel = .statusBar
        attributes.statusBar = .dark
        
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        
        switch self {
        case .top:
            attributes.position = .top
        case .bottom:
            attributes.position = .bottom
        case .center:
            attributes.position = .center
        }
        return attributes
    }
}

class RGUIPopup {
    // Show popup with custom view
    static func showPopupWith(contentView: UIView,
                              contentHeight: CGFloat? = nil,
                              popsition: RGUIPopupAttributes = .bottom,
                              screenInteraction: EKAttributes.UserInteraction = .dismiss) {
        var contentFrame = contentView.frame
        contentFrame.size.height = (contentHeight != nil)
            ? min(contentHeight!, SAFE_AREA_HEIGHT)
            : min(contentFrame.size.height, SAFE_AREA_HEIGHT)
        SwiftEntryKit.display(entry: contentView,
                              using: popsition.attributes(contentViewRect: contentFrame,
                                                          screenInteraction: screenInteraction))
    }
    
    // Show controller
    static func showPopupWith(customViewController: UIViewController, popsition: RGUIPopupAttributes) {
        SwiftEntryKit.display(entry: customViewController, using: popsition.attributes())
    }
    
    // Hide popup
    static func hide() {
        SwiftEntryKit.dismiss()
    }
    
    static func hideAll(completion: (() -> ())? = nil) {
        SwiftEntryKit.dismiss(.all) {
            completion?()
        }
    }
}


extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
