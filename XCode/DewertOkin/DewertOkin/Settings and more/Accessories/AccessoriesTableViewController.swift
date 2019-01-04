//
//  AccessoriesTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 20.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import SafariServices

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

class AccessoriesTableViewController: UITableViewController, Themeable {
    
    //Empty AccessorieJSON Objects, to get filled with the data
    var productsJSON: [Accessorie.AccessorieJSON] = []
    var productsOtherCustomersBoughtJSON: [Accessorie.AccessorieJSON] = []
    
    // JSON Dummy Data for recommended Products
    //JSON data is structured as follows: object 1: title: COMPANYNAME imageURL: URL to CompanyLogo  and targetURL: URl to the website
    // all following objects are the actual Accessories, with the properties [ title: String , description: String, imageURL: URL, targetURL: URL
    // title defines name of the Accessorie. description gives the Item a description. ImageURL should link to a image of the Item. targetURL should lead to the discrete webshop-link of the item.
    var productsDummy: [Accessorie.AccessorieJSON] = [
    Accessorie.AccessorieJSON(title: "DewertOkin", description: "Companyname", imageURL: URL(string: "https://www.dewertokin.com/fileadmin/template/website/img/logo-dewert-okin.png")!, targetURL: URL(string: "https://www.dewertokin.com")!),
    Accessorie.AccessorieJSON(title: "LED Lichtleiste", description: "This will definitely lighten up your life!", imageURL: URL(string: "https://www.dewertokin.com/fileadmin/template/website/img/zubehoer/LED-LICHTLEISTE.jpg")!, targetURL: URL(string: "https://www.dewertokin.com/de/produkte/bedding/zubehoer/led-lichtleiste/")!),
    Accessorie.AccessorieJSON(title: "AKKU POWER PACK 1300", description: "For all the mobile power you'll ever need!", imageURL: URL(string: "https://www.dewertokin.com/fileadmin/template/website/img/zubehoer/POWER-PACK-1300.jpg")!, targetURL: URL(string: "https://www.dewertokin.com/de/produkte/bedding/zubehoer/akku-power-pack-1300/")!)
    ]
    // JSON Dummy data for "otherCustomersBought" Section
    var productsOtherCustomersboughtDummy: [Accessorie.AccessorieJSON] = [
        Accessorie.AccessorieJSON(title: "Topline Remote", description: "Have Control Over Everything!", imageURL: URL(string: "https://www.dewertokin.com/fileadmin/template/website/img/handschalter/topline/Topline-RF-11-Tasten-beleuchtet.png")!, targetURL: URL(string: "https://www.dewertokin.com/de/produkte/bedding/handschalter/topline/")!),
        Accessorie.AccessorieJSON(title: "Baseline Remote", description: "Simple Remote!", imageURL: URL(string: "https://www.dewertokin.com/fileadmin/template/website/img/handschalter/BASELINE_Bedding.jpg")!, targetURL: URL(string: "https://www.dewertokin.com/de/produkte/bedding/handschalter/baseline/")!),
        Accessorie.AccessorieJSON(title: "WALL PLUG SMPS ECO", description: "Power Overwhelming!", imageURL: URL(string: "https://www.dewertokin.com/fileadmin/template/website/img/zubehoer/WALL-PLUG-SMPS-eco.jpg")!, targetURL: URL(string: "https://www.dewertokin.com/de/produkte/bedding/zubehoer/wall-plug-smps-eco/")!)
    ]
    
    private func checkForCompanyOfConnectedDevice(listreply :String) ->String{
        // integrate some sort of check here, to know which companies Device is connected right now.
        let company = "None"
        if listreply == "standard" {
            // Here should be listed the link to the "Products"-JSON data of all companies
        switch company {
            case "Test":
                    let jsonUrlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
                    return jsonUrlString
            case "None":
                    let jsonUrlString = "None"
                    return jsonUrlString
            case "DewertOkin":
                    let jsonUrlString = "https://dewertokin.com"
                    return jsonUrlString
            default:
                    let jsonUrlString = "https://dewertokin.com"
                    return jsonUrlString
        }
        }
            if listreply == "other" {
            // here should be listed the link to the "otherCustomersBought"-JSON data of all companies
            switch company {
            case "Test":
                let jsonUrlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
                return jsonUrlString
            case "None":
                let jsonUrlString = "None"
                return jsonUrlString
            case "DewertOkin":
                let jsonUrlString = "https://dewertokin.com"
                return jsonUrlString
            default:
                let jsonUrlString = "https://dewertokin.com"
                return jsonUrlString
                }
        }
        return "None"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        Themes.setupTheming(for: self)
        
        // --- json data web catch function for productsJSON ---
        // first, it has to get the relevant company link , then it gets handled with the JSONDecoder and the data gets integrated into the productsJSON object
        let jsonUrlString = checkForCompanyOfConnectedDevice(listreply: "standard")
        let jsonUrlStringOther = checkForCompanyOfConnectedDevice(listreply: "other")
        
        if jsonUrlString != "None" {
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            // now, here the data is handled
            guard let data = data else { return }
            
            do {
                let accessorieJSON = try
                    JSONDecoder().decode([Accessorie.AccessorieJSON].self, from: data)
                 print(accessorieJSON)
                 self.productsJSON += accessorieJSON
                
            }
            catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
        } else {
            
            self.productsJSON += productsDummy
        }
        
        if jsonUrlStringOther != "None" {
        guard let urlOther = URL(string: jsonUrlStringOther) else { return }
        URLSession.shared.dataTask(with: urlOther) { (data, response, err) in
            // now, here the data is handled
            guard let data = data else { return }
            
            do {
                let accessorieJSON = try
                    JSONDecoder().decode([Accessorie.AccessorieJSON].self, from: data)
                print(accessorieJSON)
             self.productsOtherCustomersBoughtJSON += accessorieJSON
            }
            catch let jsonErr {
                print("Error serializing json-other:", jsonErr)
                
            }
        }.resume()
        }
        else {
            self.productsOtherCustomersBoughtJSON += productsOtherCustomersboughtDummy
        }
        
        

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Accessories"
        //navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func darkModeEnabled(_ notification: Notification) {
        setDarkTheme()
    }
    
    func darkModeDisabled(_ notification: Notification) {
        setDefaultTheme()
    }
    
    func setDarkTheme() {
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.tabBarController?.tabBar.barStyle = UIBarStyle.black
        //self.navigationController?.tabBarController?.tabBar.unselectedItemTintColor = .white
    }
    
    func setDefaultTheme() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = nil
        self.navigationController?.navigationBar.titleTextAttributes = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.tabBarController?.tabBar.barStyle = UIBarStyle.default
        //self.navigationController?.tabBarController?.tabBar.unselectedItemTintColor = nil
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = productsJSON.count + productsOtherCustomersBoughtJSON.count + 1
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
    case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            
//              cell.productImage.image = UIImage(url: productsJSON[indexPath.row].imageURL)
            return cell
    case 1...productsJSON.count-1:
    
    
                let cell = tableView.dequeueReusableCell(withIdentifier: "AccessorieCell", for: indexPath) as! AccessorieTableViewCell
                cell.titleLabel.text = productsJSON[indexPath.row].title
                cell.descriptionLabel.text = productsJSON[indexPath.row].description
                cell.productImage.image = UIImage(url: productsJSON[indexPath.row].imageURL)
                // cell.productImage.image = UIImage(named: "lichtleiste")
                // productsJSON[n].imageURL
                cell.productImage.contentMode = .scaleAspectFit
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessorieTapped)))
                return cell
                
        case productsJSON.count :
            
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionTableViewCell
                cell.sectionTitleLabel.text = "Other customers bought"
                return cell
        case productsJSON.count+1 ... productsOtherCustomersBoughtJSON.count+productsJSON.count+1 :
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "AccessorieCell", for: indexPath) as! AccessorieTableViewCell
                cell.titleLabel.text = productsOtherCustomersBoughtJSON[indexPath.row-1-productsJSON.count].title
                cell.descriptionLabel.text = productsOtherCustomersBoughtJSON[indexPath.row-1-productsJSON.count].description
                cell.productImage.image = UIImage(url: productsOtherCustomersBoughtJSON[indexPath.row-1-productsJSON.count].imageURL)
                // cell.productImage.image = UIImage(named: "lichtleiste")
                // products[n].imageURL
                cell.productImage.contentMode = .scaleAspectFit
               cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessorieTapped)))
                return cell
        default:
            
            
                        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
                        return cell
            
        }
    }
// old code // method, not dynamic but works
//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
//            return cell
//
//        case products.count+1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionTableViewCell
//                       cell.sectionTitleLabel.text = "Other customers bought"
//                       return cell

//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AccessorieCell", for: indexPath) as! AccessorieTableViewCell
//            cell.titleLabel.text = products[0].title
//            cell.descriptionLabel.text = products[0].description
//            cell.productImage.image = UIImage(named: "lichtleiste")
//            cell.productImage.contentMode = .scaleAspectFit
//            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessorieTapped)))
//
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AccessorieCell", for: indexPath) as! AccessorieTableViewCell
//            cell.titleLabel.text = products[1].title
//            cell.descriptionLabel.text = products[1].description
//            cell.productImage.image = UIImage(named: "remote")
//            cell.productImage.contentMode = .scaleAspectFit
//            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessorieTapped)))
//
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionTableViewCell
//            cell.sectionTitleLabel.text = "Other customers bought"
//            return cell
//        case 4:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AccessorieCell", for: indexPath) as! AccessorieTableViewCell
//            cell.titleLabel.text = productsOtherCustomersbought[0].title
//            cell.descriptionLabel.text = productsOtherCustomersbought[0].description
//            cell.productImage.image = UIImage(named: "lichtleiste")
//            cell.productImage.contentMode = .scaleAspectFit
//            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessorieTapped)))
//
//            return cell
//        case 5:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AccessorieCell", for: indexPath) as! AccessorieTableViewCell
//            cell.titleLabel.text = productsOtherCustomersbought[1].title
//            cell.descriptionLabel.text = productsOtherCustomersbought[1].description
//            cell.productImage.image = UIImage(named: "remote")
//            cell.productImage.contentMode = .scaleAspectFit
//            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessorieTapped)))
//
//            return cell
//        default:
//
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
//            return cell
//        }
//  }
        
    @objc
    private func accessorieTapped() {
        let url = URL(string: "https://www.dewertokin.com/")!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }
    

}
