//
//  CategoriaViewModel.swift
//  MRangelToDoList
//
//  Created by MacBookMBA5 on 21/03/23.
//

import Foundation
import SQLite3

class CategoriaViewModel {
    
    func GetAll() -> Result{
        
        let categoriasModel : Categorias? = nil
        
        var result = Result()
        let context = DB.init()
        let query = "SELECT IdCategoria,Nombre FROM Categoria"
        
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = []
                while sqlite3_step(statement) == SQLITE_ROW{
                    var categorias = Categorias()
                    categorias.IdCategoria = Int(sqlite3_column_int(statement, 0))
                    categorias.Nombre =  String(cString: sqlite3_column_text(statement, 1))
                    
                    result.Objects?.append(categorias)
                }
                result.Correct = true
            }
        }catch let error{
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(context.db)
        return result
    }
}
