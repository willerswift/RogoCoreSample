//
//  extRGBGroup.swift
//  RogoCoreSample
//
//  Created by Willer Swift on 18/01/2024.
//

import Foundation
import RogoCore

extension RGBGroup {
    var roomType: RGUIRoomType {
        get {
            return RGUIRoomType(rawValue: self.desc ?? "") ?? .All
        }
        set {
            
        }
    }
}

enum RGUIRoomType: String, CaseIterable {
    case All
    case LivingRoom
    case Relax
    case BedRoom
    case Kitchen
    case BathRoom
    case DinningRoom
    case FamilyRoom
    case Wc
    case Garage
    case StoreHouse
    case Office
    case Basement
    case HallWay
    case Entryway
    case Attic
    case BackYard
    case FrontYard
    case Other
    
    var title: String {
        switch self {
        case .All: return "Không cụ thể"
        case .LivingRoom: return "Phòng khách"
        case .Relax: return "Phòng giải trí"
        case .BedRoom: return "Phòng ngủ"
        case .Kitchen: return "Phòng bếp"
        case .BathRoom: return "Phòng tắm"
        case .DinningRoom: return "Phòng ăn"
        case .FamilyRoom: return "Phòng sinh hoạt chung"
        case .Wc: return "WC"
        case .Garage: return "Nhà để xe"
        case .StoreHouse: return "Phòng kho"
        case .Office : return "Văn phòng"
        case .Basement : return "Tầng hầm"
        case .HallWay : return "Hành lang"
        case .Entryway : return "Lối vào"
        case .Attic : return "Gác xép"
        case .BackYard : return "Sân sau"
        case .FrontYard : return "Sân trước"
        case .Other : return "Nhóm khác"
        }
    }
}
