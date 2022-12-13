//
//  ViewController.swift
//  swift-todo
//
//  Created by Risetime on 13.12.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var todos = [TodoModel]()
    var results : [Todo]?
    
    override func viewDidLoad() {
        getData()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonClicked))
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        
        let uncheckedImage = UIImage(systemName: "circle")
        let checkedImage = UIImage(systemName: "checkmark.circle")
        
        if todos[indexPath.row].isCompleted {
            content.image = checkedImage
        } else {
            content.image = uncheckedImage
        }
        content.text = todos[indexPath.row].todo
        
        cell.contentConfiguration = content
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
           NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let updatedTodo = results![indexPath.row]
        updatedTodo.isCompleted = !updatedTodo.isCompleted
        do {
            try
                context.save()
                print("success")
            
        } catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        tableView.reloadData()
        
            
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if(editingStyle == UITableViewCell.EditingStyle.delete){
                deleteData(uuid: todos[indexPath.row].id)
                todos.remove(at: indexPath.row)
               
                self.tableView.reloadData()
           
            }
        }
    
    @objc func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        fetchRequest.returnsObjectsAsFaults = false
        do {
                  results =  try context.fetch(fetchRequest) as? [Todo]
            todos.removeAll(keepingCapacity: false)
            for result in results!{
                      if let todo = result.value(forKey: "todo") as? String, let id = result.value(forKey: "id") as? UUID, let isCompleted = result.value(forKey:"isCompleted") as? Bool {
                          self.todos.append(TodoModel(id: id, todo: todo, isCompleted: isCompleted))
                      }
                      
                      self.tableView.reloadData()
                  }
                  
              } catch {
                  print("Error")
              }
    }
    
    func deleteData(uuid: UUID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let uuidString = uuid.uuidString
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    let data = try context.fetch(fetchRequest)
                    if data.count > 0  {
                        for item in data as! [NSManagedObject] {
                            if let id = item.value(forKey: "id") as? UUID{
                                if(id.uuidString == uuidString) {
                                    print("entered for delete")
                                    context.delete(item)
                               
                                    
                                    do {try context.save()} catch{print("error")}
                                }
                            }
                        }
                       
                    }
                    
                } catch{
                    print("ERROR")
                }
    }
    
    @objc func onAddButtonClicked() {
        performSegue(withIdentifier: "toAddTodoVC", sender: nil)
    }
}

