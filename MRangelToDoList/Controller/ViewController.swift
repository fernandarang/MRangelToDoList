//
//  ViewController.swift
//  MRangelToDoList
//
//  Created by MacBookMBA5 on 15/03/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fechaLbl: UILabel!
    @IBOutlet weak var DIasCollectionView: UICollectionView!
    @IBOutlet weak var TareasTableView: UITableView!
    
    var calendar = [Date]()
    var selectedDate = Date()
    //var selectDate2 = CalendarHelper().dates(date: selectedDate)
    var tareasViewModel = TareasViewModel()
    var tarea = Tareas()
    var tareas = [Tareas]()
    var idTarea : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = DB.init()
        // Do any additional setup after loading the view.
        DIasCollectionView.delegate = self
        DIasCollectionView.dataSource = self
        TareasTableView.delegate = self
        TareasTableView.dataSource = self
        
        DIasCollectionView.register(UINib(nibName: "diasCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiasCell")
        
        TareasTableView.register(UINib(nibName: "tareasTableViewCell", bundle: nil), forCellReuseIdentifier: "TareasCell")
        setWeekView()
        fechaLbl.text = CalendarHelper().datesString(date: Date.now).capitalized
        loadDataDate()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataDate()
    }
    
    
    func setWeekView()
        {
            calendar.removeAll()
            
            var current = CalendarHelper().sundayForDate(date: selectedDate)
            let nextSunday = CalendarHelper().addDays(date: current, days: 7)
            
            while (current < nextSunday)
            {
                calendar.append(current)
                current = CalendarHelper().addDays(date: current, days: 1)
            }
            
            //monthLabel.text = CalendarHelper().monthString(date: selectedDate)
              //  + " " + CalendarHelper().yearString(date: selectedDate)
            DIasCollectionView.reloadData()
            TareasTableView.reloadData()
        }
    
    
    @IBAction func previousWeek(_ sender: UIButton) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
                setWeekView()
    }
    
    @IBAction func nextWeek(_ sender: UIButton) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
                setWeekView()
    }
    
    func loadData(){
        let result = tareasViewModel.GetAll()
        if result.Correct{
            tareas = result.Objects! as! [Tareas]
            TareasTableView.reloadData()
        }
        else{
            //ALERT
            let alertError = UIAlertController(title: "Error", message: "Error al mostrar las tareas "+result.ErrorMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alertError.addAction(ok)
            self.present(alertError, animated: false)
        }
    }
    
    func loadDataDate(){
        let fecha = CalendarHelper().dates(date: selectedDate)
        let result = tareasViewModel.GetByDate(date: fecha) //Uso del GetById
        if result.Correct{
            tareas = result.Objects! as! [Tareas]
            TareasTableView.reloadData()
        }
        else{
            //ALERT
            let alertError = UIAlertController(title: "Error", message: "Error al mostrar las tareas "+result.ErrorMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alertError.addAction(ok)
            self.present(alertError, animated: false)
        }
    }
}

extension ViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiasCell", for: indexPath) as! diasCollectionViewCell
        
        let date = calendar[indexPath.item]
        cell.numLbl.text = String(CalendarHelper().dayOfMonth(date: date))
        cell.diaLbl.text = String(CalendarHelper().dayString(date: date)).uppercased()
        
                if(date == selectedDate)
                {
                    cell.ViewColor.backgroundColor = UIColor(named: "Color")
                    cell.numLbl.textColor = .white
                    cell.diaLbl.textColor = .white
                }
                else
                {
                    cell.ViewColor.backgroundColor = UIColor(named: "indigo")
                    cell.numLbl.textColor = UIColor(named: "Color")
                    cell.diaLbl.textColor = UIColor(named: "Color")
                }
         
        cell.layer.cornerRadius = 40
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? diasCollectionViewCell {
            cell.ViewColor.backgroundColor = UIColor(named: "Color")
            cell.diaLbl.textColor = .white
            cell.numLbl.textColor = .white
        }
        selectedDate = calendar[indexPath.item]
        //print(selectedDate)
        
        loadDataDate()
        /*
         let result = tareasViewModel.GetByDate(date: selectedDate) //Uso del GetById
         if result.Correct{
         tareas = result.Objects! as! [Tareas]
         TareasTableView.reloadData()
         */
        //}
        
        DIasCollectionView.reloadData()
        TareasTableView.reloadData()
    }
    }


extension ViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tareas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TareasCell", for: indexPath) as! tareasTableViewCell
    
        cell.NombreLbl.text = tareas[indexPath.row].Nombre
        
        if tareas[indexPath.row].Categoria.IdCategoria == 1 {
            cell.ImageCategoria.image = UIImage(named: "trabajo")
        }
        if tareas[indexPath.row].Categoria.IdCategoria == 2 {
            cell.ImageCategoria.image = UIImage(named: "hobbies")
        }
        if tareas[indexPath.row].Categoria.IdCategoria == 3 {
            cell.ImageCategoria.image = UIImage(named: "comida")
        }
        if tareas[indexPath.row].Categoria.IdCategoria == 4 {
            cell.ImageCategoria.image = UIImage(named: "estudio")
        }
        if tareas[indexPath.row].Categoria.IdCategoria == 5 {
            cell.ImageCategoria.image = UIImage(named: "compras")
        }
        if tareas[indexPath.row].Categoria.IdCategoria == 6 {
            cell.ImageCategoria.image = UIImage(named: "paseo")
        }
        cell.checkImage.isHidden = true
        //+ " " + CalendarHelper().timeString(date: event.date)
        
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if let cell = tableView.cellForRow(at: indexPath) as? tareasTableViewCell {
        if TareasTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
                TareasTableView.cellForRow(at: indexPath)?.accessoryType = .none
            }else{
                TareasTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        //}
    }
    */
    /*
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? tareasTableViewCell {
            cell.checkImage.isHidden = true
        }
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateTareaSegue"{
            let tareasController = segue.destination as! TareasAddViewController
                           tareasController.idTarea = self.idTarea
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Delete") {
            (action,view,completion) in
            self.idTarea = self.tareas[indexPath.row].IdTarea
            let result = self.tareasViewModel.Delete(IdTarea: self.idTarea!)
                                if result.Correct{
                                    
                                }else{
                                   
                                }
                                self.loadData()
                completion(true)
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action1 = UIContextualAction(style: .normal, title: "Update") {
            (action,view,completion) in
                self.idTarea = self.tareas[indexPath.row].IdTarea
            self.performSegue(withIdentifier: "UpdateTareaSegue", sender: self)
                completion(true)
        }
        action1.image = UIImage(systemName: "eraser.line.dashed")
        action1.backgroundColor = .cyan
        
        return UISwipeActionsConfiguration(actions: [action1])
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
        {
            super.viewDidAppear(animated)
            TareasTableView.reloadData()
        }
}

