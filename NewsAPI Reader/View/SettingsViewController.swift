//
//  SettingsViewController.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 25.10.2021.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    

    private var mainModel = MainViewModel()
    private var mainView = MainTableViewController()
    private var selectedSource = ""

    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var selected: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        countryPicker.delegate = self
        countryPicker.dataSource = self
        filterPicker.delegate = self
        filterPicker.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        countryPicker.selectRow(Settings.selectedCountry, inComponent: 0, animated: true)
        filterPicker.selectRow(Settings.selectedCategory, inComponent: 0, animated: true)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SettingsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
    }
    
    @IBAction func categorySelected(_ sender: UISegmentedControl) {
        print(selected.selectedSegmentIndex)
        filterPicker.reloadAllComponents()
        switch sender.selectedSegmentIndex {
        case 0 :
            tableView.isHidden = true
            filterPicker.isHidden = false
        default :
            
            NR.generateSources(url: mainModel.urlSources, urlParams: mainModel.urlParams) { success in
                if success {
                    self.tableView.reloadData()

                }
            }
            
            tableView.isHidden = false
            filterPicker.isHidden = true
        }
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        print("Время рамсить!")
            
        if selectedSource != "" {
        Settings.sources = []
            Settings.sources.append(selectedSource)
            print(Settings.sources)
        }
            _ = navigationController?.popViewController(animated: true)
        }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if pickerView == countryPicker {
        count = SData.countries.count
        } else {
            if selected.selectedSegmentIndex == 0 {
                count = SData.category.count
            } else if selected.selectedSegmentIndex == 1 {
                count = Settings.sources.count
            }
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var data: String = ""
        if pickerView == countryPicker {
        data = SData.countries[row].countryName
        } else {
                data = SData.category[row]
            
            }
        
        return data
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == countryPicker {
            self.filterPicker.reloadAllComponents()

        flagImage.image = UIImage(named: SData.countries[row].id)
        Settings.selectedCountry = row
        Settings.needToLoad = true

                //self.mainModel.getSourses()
            
            NR.generateSources(url: mainModel.urlSources, urlParams: mainModel.urlParams) { success in
                if success {
                    self.tableView.reloadData()
                    

                }
            }
            
       
                
                
            
            
            
            
        print(Settings.selectedCountry)
        } else {
                Settings.selectedCategory = row
                Settings.needToLoad = true
                print("Выбрана другая категория")
                //selectedSource = Settings.sources[row]
                //print(selectedSource)
            }
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Settings.sources.isEmpty {
            return 1
        }
        
        return Settings.sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if Settings.sources != [] {
        
        cell.textLabel?.text = Settings.sources[indexPath.row]
        }
//        if Settings.sources.count > 1 {
//            data = Settings.sources[row]
//            } else {
//                data = ""
//            }
        
        
        return cell
    }
    
    
}
