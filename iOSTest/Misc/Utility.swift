//
//  Utility.swift
//  iOSTest
//
//  Created by Lui on 15/02/22.
//

import Foundation

enum CellType: String {
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
}

protocol CustomCellDelegate {
    var selectedCells: [CellType] {get set}
    func switchTrackingOf(cellType: CellType)
}

protocol GenderCellDelegate {
    func switchGenderActive(to gender: CellType)
}
