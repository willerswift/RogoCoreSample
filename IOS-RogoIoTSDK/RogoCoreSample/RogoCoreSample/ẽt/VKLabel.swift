//
//  VKLabel.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/01/2024.
//

import UIKit

/// Input item which is use in main container.
public class VKLabel: UILabel {

    private var _style: EntryViewStyle?
    
    /// Enable or disable selection animation for active input item. Default value is true.
    public var animateWhileSelected = true
    
    /// Enable or disable selection for displaying active state.
    public var isSelected = false {
        
        didSet { if oldValue != isSelected { updateSelectedState() } }
    }
    
    /// Enable or disable selection for displaying error state.
    public var isError = false {
        
        didSet {  updateErrorState() }
    }
    
    // MARK: - Initializers

    /// Prefered initializer if you don't use storyboards or nib files.
    public init(_ style: EntryViewStyle?) {

        super.init(frame: CGRect.zero)
        setStyle(style)
    }

    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Overrides
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        _style?.onLayoutSubviews(self)
    }
    
    // MARK: - Public methods

    /// Set appearence style.
    public func setStyle(_ style: EntryViewStyle?) {

        _style = style
        _style?.onSetStyle(self)
    }

    
    // MARK: - Private methods
    
    private func updateSelectedState() {

        _style?.onUpdateSelectedState(self)
    }
    
    private func updateErrorState() {

        _style?.onUpdateErrorState(self)
    }
}
