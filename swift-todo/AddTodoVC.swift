//
//  AddTodoVC.swift
//  swift-todo
//
//  Created by Risetime on 13.12.2022.
//

import UIKit
import CoreData

class AddTodoVC: UIViewController{

    @IBOutlet weak var todoField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func save(_ sender: Any) {
        print("clicked")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newTodo = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context)
        
        newTodo.setValue(todoField.text, forKey: "todo")
        newTodo.setValue(false, forKey: "isCompleted")
        newTodo.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
        } catch {
            createAlert(title: "Error", message: "Something went wrong")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func createAlert(title:String ,message: String){
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                (UIAlertAction) in
                    print("OK clicked")
                
            }
           alert.addAction(okButton)
           self.present(alert, animated: true, completion: nil)
       }

}
