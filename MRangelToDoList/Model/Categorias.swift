//
//  Categorias.swift
//  MRangelToDoList
//
//  Created by MacBookMBA5 on 17/03/23.
//

import Foundation
struct Categorias{
    var IdCategoria : Int
    var Nombre : String
    
    init(IdCategoria: Int, Nombre: String) {
        self.IdCategoria = IdCategoria
        self.Nombre = Nombre
    }
    
    init(){
        self.IdCategoria = 0
        self.Nombre = ""
    }
}
