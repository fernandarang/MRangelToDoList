//
//  Tareas.swift
//  MRangelToDoList
//
//  Created by MacBookMBA5 on 17/03/23.
//

import Foundation

var eventsList = [Tareas]()

struct Tareas {
    
    var IdTarea : Int
    var Nombre : String
    var date : String
    var Categoria : Categorias
    
    init(IdTarea: Int, Nombre: String, Categoria: Categorias, date : String) {
        self.IdTarea = IdTarea
        self.Nombre = Nombre
        self.Categoria = Categoria
        self.date = date
    }
    init(){
        self.IdTarea = 0
        self.Nombre = ""
        self.date = ""
        self.Categoria = MRangelToDoList.Categorias(IdCategoria: 0, Nombre: "")
    }
    /*
    func eventsForDate(date: Date) -> [Tareas]
        {
            var daysEvents = [Tareas]()
            for event in eventsList
            {
                if(Calendar.current.isDate(event.date, inSameDayAs:date))
                {
                    daysEvents.append(event)
                }
            }
            return daysEvents
        }
     */
}
