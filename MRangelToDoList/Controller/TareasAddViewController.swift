//
//  TareasAddViewController.swift
//  MRangelToDoList
//
//  Created by MacBookMBA5 on 17/03/23.
//

import UIKit
import iOSDropDown

class TareasAddViewController: UIViewController {
    
    
    @IBOutlet weak var NombreField: UITextField!
    @IBOutlet weak var CategoriaField: DropDown!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var GuardarBtn: UIButton!
    
    var tareasModel :Tareas? = nil
    var taresViewModel = TareasViewModel()
    var selectedDate = Date()
    var categoriasViewModel = CategoriaViewModel()
    var idCategoria: Int? = nil
    var idTarea: Int? = nil
    var categorias = Categorias()
    
    override func viewDidLoad() {
        let db = DB.init()
        super.viewDidLoad()
        //datePicker.date = selectedDate
        CategoriaField.optionArray = [String]()
        CategoriaField.optionIds = [Int]()
        
        CategoriaField.didSelect { selectedText, index, id in
           
            self.idCategoria = id
                }
        
        LoadCategorias()
        validar()
    }
    func LoadCategorias(){
        let result = categoriasViewModel.GetAll()
        if result.Correct{
            for categorias in result.Objects as! [Categorias]{
                CategoriaField.optionArray.append(categorias.Nombre)
                CategoriaField.optionIds?.append(categorias.IdCategoria)
                CategoriaField.selectedRowColor = UIColor(named: "indigo")!
                CategoriaField.arrowSize = 10
                CategoriaField.arrowColor = UIColor(named: "Color")!
            }
        }
    }
    
    func validar(){
        if idTarea == nil{
            GuardarBtn.setTitle("Save", for: .normal)
        }else{
            GuardarBtn.setTitle("Update", for: .normal)// Mostar buton que inque Actualizar
            let result = taresViewModel.GetById(IdTarea: idTarea!)//Uso del GetById
            if result.Correct{
                let tarea = result.Object as! Tareas //Mostar el formulario precargado
                NombreField.text = tarea.Nombre
                CategoriaField.text = String(tarea.Categoria.Nombre)
                //datePicker.date = tarea.date
            }
        }
    }
    
    @IBAction func GuardarBtn(_ sender: UIButton) {
        
        if GuardarBtn.currentTitle == "Save"{
            
            guard let Nombre = NombreField.text, Nombre != "" else {
                NombreField.placeholder = "Ingresa el nombre"
                return
            }
            guard let IdCategoria = CategoriaField.text, IdCategoria != "" else {
                CategoriaField.placeholder = "Select a category"
                return
            }
            let datePicker = datePicker.date
            let fecha = CalendarHelper().dates(date: datePicker)
            
            tareasModel = Tareas(IdTarea: 0, Nombre: Nombre, Categoria: Categorias(IdCategoria: Int(idCategoria!), Nombre: ""), date: fecha)
            
            let result = taresViewModel.Add(tarea: tareasModel!)
            
            if result.Correct{
                let alert = UIAlertController(title: "Confirmación", message: "Tarea agregada correctamente", preferredStyle: .alert)
                //let ok = UIAlertAction(title: "OK", style: .default)
                let Aceptar = UIAlertAction(title: "Aceptar", style: .default,handler:
                                                { action in
                    self.NombreField.text = ""
                    self.CategoriaField.text = ""
                    self.datePicker.date = self.selectedDate
                })
                //alert.addAction(ok)
                alert.addAction(Aceptar)
                self.present(alert, animated: false)
                eventsList.append(Tareas())
            }else{
                
                let alertError = UIAlertController(title: "Error", message: "La tarea no se pudo agregar "+result.ErrorMessage, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alertError.addAction(ok)
                self.present(alertError, animated: false)
            }
        }
        
        if GuardarBtn.currentTitle == "Update"{
            guard let Nombre = NombreField.text, Nombre != "" else {
                NombreField.placeholder = "Ingresa el nombre"
                return
            }
            guard let IdCategoria = CategoriaField.text, IdCategoria != "" else {
                CategoriaField.placeholder = "Selecciona una categoria"
                return
            }
            let datePicker = datePicker.date
            let fecha = CalendarHelper().dates(date: datePicker)
            
            tareasModel = Tareas(IdTarea: Int(idTarea!), Nombre: Nombre, Categoria: Categorias(IdCategoria: Int(idCategoria!), Nombre: ""), date: fecha)
            
            let result = taresViewModel.Update(tarea: tareasModel!, IdTarea: idTarea!)
            
            if result.Correct{
                let alert = UIAlertController(title: "Confirmación", message: "Tarea actualizada correctamente", preferredStyle: .alert)
                //let ok = UIAlertAction(title: "OK", style: .default)
                let Aceptar = UIAlertAction(title: "Aceptar", style: .default,handler:
                                                { action in
                    self.NombreField.text = ""
                    self.CategoriaField.text = ""
                    self.datePicker.date = self.selectedDate
                })
                //alert.addAction(ok)
                alert.addAction(Aceptar)
                self.present(alert, animated: false)
                eventsList.append(Tareas())
            }else{
                
                let alertError = UIAlertController(title: "Error", message: "La tarea no se pudo actualizar "+result.ErrorMessage, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alertError.addAction(ok)
                self.present(alertError, animated: false)
            }
            
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
