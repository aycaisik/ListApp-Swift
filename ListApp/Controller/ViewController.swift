//
//  ViewController.swift
//  ListApp
//
//  Created by Ayça Işık on 19.03.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var alertController = UIAlertController()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "defaultcell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    
    @IBAction func didAddBarButtonItemTapped(_ sender:UIBarButtonItem){
        
        presentAddAlert()
    }
    
    
    func presentAddAlert(){
        
        /* let alertController = UIAlertController(title: "yeni eleman ekle", message: nil, preferredStyle: .alert)
         
         let defaultButton = UIAlertAction(title: "ekle", style: .default){_ in
         
         let text = alertController.textFields?.first?.text
         if text != ""{
         self.data.append((text)!)
         self.tableView.reloadData()
         }else{
         self.presentWarningAlert()
         
         }
         
         
         }
         
         let cancelButton = UIAlertAction(title: "vazgeç", style: .cancel)
         
         alertController.addTextField()
         
         alertController.addAction(defaultButton)
         alertController.addAction(cancelButton)
         
         present(alertController, animated: true)*/
        
        presentAlert(title: "yeni eleman ekle",
                     message: nil,
                     defaultButtonTitle: "ekle",
                     defaultButtonHandler: { _ in
            let text = self.alertController.textFields?.first?.text
            if text != ""{
                self.data.append((text)!)
                self.tableView.reloadData()
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
    
}

