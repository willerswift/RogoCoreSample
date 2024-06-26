//
//  extRGBLocation.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 10/01/2024.
//

import Foundation
import UIKit

public enum RGUILocationType: String, CaseIterable {
    case None
    case Home
    case Apartment
    case Hotel
    case Motel
    case Homestay
    case Restaurant
    case Office
    case Other
    
    func desc() -> String {
        switch self {
        case .None:
            return "Chưa xác định"
        case .Home:
            return "Nhà riêng"
        case .Apartment:
            return "Chung cư"
        case .Hotel:
            return "Khách sạn"
        case .Motel:
            return "Nhà nghỉ"
        case .Homestay:
            return "Homestay"
        case .Restaurant:
            return "Nhà hàng"
        case .Office:
            return "Văn phòng"
        case .Other:
            return "Khác"
        }
    }
}

