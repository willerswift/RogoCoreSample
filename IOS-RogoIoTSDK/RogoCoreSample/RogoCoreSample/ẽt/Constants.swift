//
//  Constants.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
var SAFE_AREA_HEIGHT: CGFloat {
    if let safeViewFrame = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame {
        return safeViewFrame.height
    }
    return SCREEN_HEIGHT
}
