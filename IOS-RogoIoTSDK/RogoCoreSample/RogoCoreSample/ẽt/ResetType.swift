//
//  ResetType.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 29/01/2024.
//

import Foundation

public enum ResetType {

    case none, onUserInteraction, afterError(_ delay: TimeInterval)
    
}
