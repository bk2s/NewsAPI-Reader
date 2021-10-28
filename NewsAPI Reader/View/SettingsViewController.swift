//
//  SettingsViewController.swift
//  NewsAPI Reader
//
//  Created by  Stepanok Ivan on 25.10.2021.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    private var mainModel = MainViewModel()
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
        selected.selectedSegmentIndex = Settings.filteringBy
        showAndHide()
        flagImage.image = UIImage(named: SData.countries[Settings.selectedCountry].id)
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SettingsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        NR.generateSources(url: mainModel.urlSources, urlParams: mainModel.urlParams) { success in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    func showAndHide() {
        if selected.selectedSegmentIndex == 0 {
            tableView.isHidden = true
            filterPicker.isHidden = false
        } else {
            Settings.selectedSources = []
            tableView.isHidden = false
            filterPicker.isHidden = true
        }
    }
    
    @IBAction func categorySelected(_ sender: UISegmentedControl) {
        print(selected.selectedSegmentIndex)
        filterPicker.reloadAllComponents()
        switch sender.selectedSegmentIndex {
        case 0 :
            Settings.filteringBy = 0
            UserDefaults.standard.set(0, forKey: "filteringBy")
            tableView.isHidden = true
            filterPicker.isHidden = false
        default :
            Settings.filteringBy = 1
            Settings.selectedSources = []
            NR.generateSources(url: mainModel.urlSources, urlParams: mainModel.urlParams) { success in
                if success {
                    self.tableView.reloadData()
                }
            }
            UserDefaults.standard.set(1, forKey: "filteringBy")
            tableView.isHidden = false
            filterPicker.isHidden = true
        }
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        print("Time to go back!")
        if selectedSource != "" {
            Settings.sources = []
            Settings.sources.append(selectedSource)
            print(Settings.sources)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
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
            Settings.needToUpdateSources = true
            flagImage.image = UIImage(named: SData.countries[row].id)
            Settings.selectedCountry = row
            UserDefaults.standard.set(row, forKey: "selectedCountry")
            print("ВЫБРАНО \(Settings.selectedCountry)")
            Settings.needToLoad = true
            NR.generateSources(url: mainModel.urlSources, urlParams: mainModel.urlParams) { success in
                if success {
                    self.tableView.reloadData()
                }
            }
            print(Settings.selectedCountry)
        } else {
            Settings.selectedCategory = row
            UserDefaults.standard.set(row, forKey: "selectedCategory")
            Settings.needToLoad = true
            print("Selected category \(SData.category[Settings.selectedCategory])")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Settings.sources.isEmpty {
            return 0
        }
        
        return Settings.selectedSources.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if Settings.sources != [] {
            cell.textLabel?.text = Settings.selectedSources[indexPath.row].sourceName
            cell.accessoryType = Settings.selectedSources[indexPath.row].isSelected ?? true ? .checkmark : .none
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Settings.selectedSources[indexPath.row].isSelected == false {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        Settings.selectedSources[indexPath.row].isSelected.toggle()
        mainModel.updateSources()
        Settings.needToLoad = true
    }
    
    
}
