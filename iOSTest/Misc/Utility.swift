//
//  Utility.swift
//  iOSTest
//
//  Created by Lui on 15/02/22.
//

import Foundation
import UIKit

enum CellType: String, Comparable {
    
    case Camera = "Cámara"
    case Photo = "Foto"
    case Name = "Nombre completo"
    case Phone = "Número telefónico"
    case Birth = "Fecha de nacimiento"
    case Gender = "Sexo"
    case Color = "Color favorito"
    //extending the enum with new specific cases for cell generation
    case Male = "Masculino"
    case Female = "Femenino"
    
    private var sortOrder: Int {
        switch self {
        case .Camera:
            return 0
        case .Photo:
            return 1
        case .Name:
            return 2
        case .Phone:
            return 3
        case .Birth:
            return 4
        case .Gender:
            return 5
        case .Color:
            return 6
        case .Male:
            return 55
        case .Female:
            return 54
        }
    }
    
    static func < (lhs: CellType, rhs: CellType) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
    
    static func == (lhs: CellType, rhs: CellType) -> Bool {
        return lhs.sortOrder == rhs.sortOrder
    }
    
}

protocol CustomCellDelegate {
    var selectedCells: [CellType] {get set}
    func switchTrackingOf(cellType: CellType)
}

protocol GenderCellDelegate {
    func switchGenderActive(to gender: CellType)
}

enum CellColors: String {
    case Green = "Verde"
    case Yellow = "Amarillo"
    case Orange = "Naranja"
    case Red = "Rojo"
    case Purple = "Morado"
    case Blue = "Azul"
    
}

struct SectionStruct {
    var section: Int
    var cellType: CellType
}
