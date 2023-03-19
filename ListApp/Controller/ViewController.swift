//
//  ViewController.swift
//  ListApp
//
//  Created by Ayça Işık on 19.03.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    var alertController = UIAlertController()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var data = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetch()
        
       
        
        
    }
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender: UIBarButtonItem){
        presentAlert(title: "UYARI!",
                     message: "listedeki bütün öğeleri silmek istediğinize emin misiniz?",
                     defaultButtonTitle: "evet",
                     defaultButtonHandler: {_  in
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            for item in self.data {
                managedObjectContext?.delete(item)
            }
            try? managedObjectContext?.save()
            self.fetch()
            
            
            //self.data.removeAll()
            //self.tableView.reloadData()
        },
                     cancelButtonTitle: "vazgeç")
        
    }
    @IBAction func didAddBarButtonItemTapped(_ sender:UIBarButtonItem){
        
        presentAddAlert()
    }
    
    
    func presentAddAlert(){
        
        presentAlert(title: "yeni eleman ekle",
                     message: nil,
                     defaultButtonTitle: "ekle",
                     defaultButtonHandler: { _ in
            let text = self.alertController.textFields?.first?.text
            if text != ""{
                //self.data.append((text)!)
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                //bu ikisi altlı üstlü fix
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext!)
                
                let listItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                
                listItem.setValue(text, forKey: "title")
                
                try? managedObjectContext?.save()
                
                //self.tableView.reloadData()
                self.fetch()
            }else{
                self.presentWarningAlert()
                
            }
        },
                     cancelButtonTitle: "vazgeç",isTextFieldAvailable: true)
        
        
    }
    func presentWarningAlert(){
        
        
        presentAlert(title: "UYARI!",
                     message: "liste elemanı boş olamaz",
                     cancelButtonTitle: "tamam")
        
    }
    
    func presentAlert(title:String?,
                      message:String?,
                      prefferedStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle: String? = nil,
                      defaultButtonHandler: ((UIAlertAction)->Void)? = nil,
                      cancelButtonTitle:String?,
                      isTextFieldAvailable: Bool = false
                      
    ){
        
        alertController = UIAlertController(title: title, message: message, preferredStyle:prefferedStyle
        )
        let cancelButton = UIAlertAction(title:cancelButtonTitle, style: .cancel)
        
        if isTextFieldAvailable{
            alertController.addTextField()
        }
        if defaultButtonTitle != nil{
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default,
                                              handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
            
        }
        
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
        
    }
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managaedObjectContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        
        data = try! managaedObjectContext!.fetch(fetchRequest)
        
        tableView.reloadData()
    }
    
}
extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultcell", for: indexPath)
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "sil") { _, _, _ in
            
           // self.data.remove(at: indexPath.row)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            managedObjectContext?.delete(self.data[indexPath.row])

            try? managedObjectContext?.save()
            
            self.fetch()
            
            //tableView.reloadData()
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "düzenle"){_,_,_ in
            
            
            self.presentAlert(title: "elemanı düzenle",
                         message: nil,
                         defaultButtonTitle: "düzenle",
                         defaultButtonHandler: { _ in
                let text = self.alertController.textFields?.first?.text
                if text != ""{
                   // self.data[indexPath.row]=text!
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    
                    self.data[indexPath.row].setValue(text, forKey: "title")
                    
                    if managedObjectContext!.hasChanges{
                       try?  managedObjectContext?.save()
                    }

                    //burada fetch işlemine gerek yok zaten veri tabanına editledikten sonra yazdık.
                    self.tableView.reloadData()
                }else{
                    self.presentWarningAlert()
                    
                }
            },
                         cancelButtonTitle: "vazgeç",isTextFieldAvailable: true)

            
            
            
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        
        return config
    }
    
}

