//
//  TareasViewController.swift
//  MRangelToDoList
//
//  Created by MacBookMBA5 on 17/03/23.
//

import Foundation
import SQLite3

class TareasViewModel {
    let tareasModel : Tareas? = nil
    
    func Add(tarea : Tareas) -> Result{
                
        var result = Result()
        let context = DB.init()
        let query = "INSERT INTO Tareas (Nombre,IdCategoria,date) VALUES (?,?,?)"
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, (tarea.Nombre as NSString).utf8String, -1, nil)
                sqlite3_bind_int(statement, 2, Int32(tarea.Categoria.IdCategoria))
                sqlite3_bind_text(statement, 3, (tarea.date as NSString).utf8String,-1,nil)
                //sqlite3_bind_text(statement, 3, (tarea.date.formatted(date: .long, time: .omitted)as NSString).utf8String,-1,nil)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    result.Correct = true
                }else{
                    result.Correct = false
                }
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
    
    func Update(tarea : Tareas, IdTarea : Int) -> Result{
            var result = Result()
            let context = DB.init()
            let query = "UPDATE Tareas SET Nombre =?, IdCategoria=?, date=? WHERE IdArea = \(IdTarea)"
            
            var statement : OpaquePointer? = nil
            do{
                if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK {
                    //sqlite3_bind_int(statement, 0, Int32(tarea.IdArea))
                    sqlite3_bind_text(statement, 1, (tarea.Nombre as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(statement, 2, Int32(tarea.Categoria.IdCategoria))
                    sqlite3_bind_text(statement, 3, (tarea.date as NSString).utf8String, -1, nil)
                    
                    if sqlite3_step(statement) == SQLITE_DONE {
                        result.Correct = true
                    }else{
                        result.Correct = false
                    }
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
    
    func Delete(IdTarea : Int) -> Result{
        var result = Result()
        let context = DB.init()
        let query = "DELETE FROM Tareas WHERE IdArea = \(IdTarea)"
        
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(statement, 1, Int32(exactly: IdTarea)!)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    result.Correct = true
                }else{
                    result.Correct = false
                }
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
    
    func GetAll() -> Result{
        
        var result = Result()
        let context = DB.init()
        let query = "SELECT IdArea,Nombre,IdCategoria,date FROM Tareas"
        //let query = "SELECT IdArea,Nombre,IdCategoria,strftime('%Y-%m-%d', date) as date FROM Tareas"
        
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = []
                while sqlite3_step(statement) == SQLITE_ROW{
                    var tareas = Tareas()
                    tareas.IdTarea = Int(sqlite3_column_int(statement, 0))
                    tareas.Nombre =  String(cString: sqlite3_column_text(statement, 1))
                    tareas.Categoria.IdCategoria = Int(sqlite3_column_double(statement, 2))
                    tareas.date = String(cString: sqlite3_column_text(statement,3))
                    //tareas.date = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(statement, 3))
                    //tareas.date = Date(timeIntervalSinceNow: TimeInterval())
//                    let df = DateFormatter()
//                    df.dateStyle = .short
//                    let fecha = df.string(from: tareas.date)
//                    print(fecha)
                    
                    result.Objects?.append(tareas)
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
    
    func GetById(IdTarea : Int) -> Result{
        
        var result = Result()
        let context = DB.init()
        let query = "SELECT IdArea,Nombre,IdCategoria,date FROM Tareas WHERE IdArea = \(IdTarea)"
        
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Object = []
                while sqlite3_step(statement) == SQLITE_ROW{
                    var tarea = Tareas()
                    tarea.IdTarea = Int(sqlite3_column_int(statement, 0))
                    tarea.Nombre =  String(cString: sqlite3_column_text(statement, 1))
                    tarea.Categoria.IdCategoria = Int(sqlite3_column_int(statement, 2))
                    
                    result.Object = tarea
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
    
    func GetByDate(date : String) -> Result{
        
        var result = Result()
        let context = DB.init()
        let query = "SELECT IdArea,Nombre,IdCategoria,date FROM Tareas WHERE date ='\(date)'"
        //let query = "SELECT IdArea,Nombre,IdCategoria,date FROM Tareas WHERE date = '1992-03-24'"
        
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = []
                while sqlite3_step(statement) == SQLITE_ROW{
                    var tarea = Tareas()
                    tarea.IdTarea = Int(sqlite3_column_int(statement, 0))
                    tarea.Nombre =  String(cString: sqlite3_column_text(statement, 1))
                    tarea.Categoria.IdCategoria = Int(sqlite3_column_int(statement, 2))
                    tarea.date = String(cString: sqlite3_column_text(statement, 3))
                    
                    result.Objects?.append(tarea)
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
