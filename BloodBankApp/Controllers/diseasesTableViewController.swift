//
//  diseasesTableViewController.swift
//  BloodBankApp
//
//  Created by Apple on 2/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class diseasesTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var diseasesTableView: UITableView!
    
    var disease = [Diseases]()
    var searchDiseases = [Diseases]()
    var selectArr = [Diseases]()
    var searchingDieases = false

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        downloadJson(){
            print("successfull")
            self.diseasesTableView.reloadData()
        }
     
        self.diseasesTableView.reloadData()
        diseasesTableView.delegate = self
        diseasesTableView.dataSource = self
        searchBar.delegate = self
        diseasesTableView.isEditing = true
        diseasesTableView.allowsMultipleSelectionDuringEditing = true
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingDieases {
                   return searchDiseases.count
               } else {
                   return disease.count
               }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = diseasesTableView.dequeueReusableCell(withIdentifier: "DiseaseTableViewCell") as! diseasesTableViewCell

      let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = disease[indexPath.row].disease.capitalized
        if searchingDieases {
            cell.textLabel?.text = searchDiseases[indexPath.row].disease
                 
             } else {

            cell.textLabel?.text = disease[indexPath.row].disease
                 
             }
             

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectDeSelectCell(tableView: diseasesTableView, indexPath: indexPath)
        print(selectArr)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectDeSelectCell(tableView: diseasesTableView, indexPath: indexPath)
        print(selectArr)

    }
    
    func selectDeSelectCell(tableView:UITableView,indexPath:IndexPath){
        
        self.selectArr.removeAll()
        if let arr = diseasesTableView.indexPathsForSelectedRows{
            
            for index in arr {
                
                selectArr.append(disease[index.row])
            }
        }
        print(selectArr)
        
    }
    
    func downloadJson(completed:@escaping ()->()){
        
        let url = URL(string: "https://raw.githubusercontent.com/Shivanshu-Gupta/web-scrapers/master/medical_ner/medicinenet-diseases.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                self.disease = try JSONDecoder().decode([Diseases].self , from: data!)
                   
                    DispatchQueue.main.async {
                     
                        completed()
                    }
                }catch{
                    print("JSON ERROR")
                }
            }
        }.resume()
        
    }
    
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         // alphabetically search Disease
         searchDiseases = disease.filter({$0.disease.lowercased().prefix(searchText.count) == searchText.lowercased()})
         searchingDieases = true
         diseasesTableView.reloadData()
     }
     
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchingDieases = false
         searchBar.text = ""
         diseasesTableView.reloadData()
     }
}



    
  
    

