//
//  extUIView.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit
import SwiftEntryKit

extension UIView {
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(type(of: self).className, owner: self, options: nil)?.first as? T else {
            return nil
        }
        addSubview(contentView)
        contentView.fillSuperview()
        return contentView
    }
    
    //load nib which is the same as view name
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    func cornerRadiusBottom(_ radius: CGFloat, color: UIColor) {
        self.backgroundColor = color
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func cornerRadiusTop(_ radius: CGFloat, color: UIColor) {
        self.backgroundColor = color
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func cornerRadiusTopleftBottomRight(_ radius: CGFloat, color: UIColor) {
        self.backgroundColor = color
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func cornerRadiusTopleft(_ radius: CGFloat, color: UIColor = .clear) {
        self.backgroundColor = color
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    // get parent controller
    var parentViewController: UIViewController? {
        
        var parentResponder: UIResponder? = self
        while (parentResponder != nil) {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

enum VerticalLocation: String {
    case bottom
    case top
}
extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, radius: CGFloat = 0.5, opacity: Float = 0.5) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, radius: radius, opacity: opacity)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, radius: radius, opacity: opacity)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
        //add
        layer.cornerRadius = radius
    }
    
    func addOpacityView() {
        let view = UIView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        self.bringSubviewToFront(view)
    }
}

@IBDesignable
public class GradientView: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
}

extension UIView {
    func addDashedBorder() {
        if let _ = self.layer.sublayers?.first(where: {$0.name == "dashedBorderLayer"}) {
            return
        }
        
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.name = "dashedBorderLayer"
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func removeDashBorder() {
        if let layers = self.layer.sublayers?.filter({$0.name == "dashedBorderLayer"}) {
            layers.forEach { layer in
                layer.removeFromSuperlayer()
            }
        }
    }
}

extension UIView {
    
    enum ViewSide: String {
            case Left = "Left", Right = "Right", Top = "Top", Bottom = "Bottom"
        }
        
        func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
            
            let border = CALayer()
            border.borderColor = color
            border.name = side.rawValue
            switch side {
            case .Left: border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            case .Right: border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            case .Top: border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            case .Bottom: border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            }
            
            border.borderWidth = thickness
            
            layer.addSublayer(border)
        }
        
        func removeBorder(toSide side: ViewSide) {
            guard let sublayers = self.layer.sublayers else { return }
            var layerForRemove: CALayer?
            for layer in sublayers {
                if layer.name == side.rawValue {
                    layerForRemove = layer
                }
            }
            if let layer = layerForRemove {
                layer.removeFromSuperlayer()
            }
        }
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
//  class var className: String {
//    return String(describing: self.self)
//  }
}

extension String {
    //get class name from object
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    
}
