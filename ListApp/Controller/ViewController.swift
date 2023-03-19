//
//  ViewController.swift
//  ListApp
//
//  Created by Ayça Işık on 19.03.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{


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
        let alertController = UIAlertController(title: "yeni eleman ekle", message: nil, preferredStyle: .alert)
        
        let defaultButton = UIAlertAction(title: "ekle", style: .default){_ in
            
            self.data.append("item added")
            self.tableView.reloadData()
            
        }
        
        let cancelButton = UIAlertAction(title: "vazgeç", style: .cancel)
        
        
        alertController.addAction(defaultButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
        
        
     
    }
    

}

