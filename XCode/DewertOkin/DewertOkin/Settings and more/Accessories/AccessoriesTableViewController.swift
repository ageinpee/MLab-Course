//
//  AccessoriesTableViewController.swift
//  DewertOkin
//
//  Created by Jan Robert on 20.11.18.
//  Copyright © 2018 Team DewertOkin. All rights reserved.
//

import UIKit
import SafariServices

class AccessoriesTableViewController: UITableViewController, Themeable {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        Themes.setupTheming(for: self)

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
    
    var products: [Accessorie] = [
        Accessorie(title: "New Under-Bed-Lighting", description: "This will definitely lighten up your life!", imageURL: URL(string: "http://www.google.de")!, targetURL: URL(string: "http://dewertokin.de")!),
        Accessorie(title: "RGB light strip", description: "For all the colours you need!", imageURL: URL(string: "http://www.google.de")!, targetURL: URL(string: "http://dewertokin.de")!)
    ]
    var productsOtherCustomersbought: [Accessorie] = [
        Accessorie(title: "New Under-Bed-Lighting", description: "This will definitely lighten up your life!", imageURL: URL(string: "http://www.google.de")!, targetURL: URL(string: "http://dewertokin.de")!),
        Accessorie(title: "RGB light strip", description: "For all the colours you need!", imageURL: URL(string: "http://www.google.de")!, targetURL: URL(string: "http://dewertokin.de")!),
        Accessorie(title: "RGB dance light show", description: "all the colours!", imageURL: URL(string: "http://www.google.de")!, targetURL: URL(string: "http://dewertokin.de")!)
    ]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = products.count + productsOtherCustomersbought.count + 2
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
    case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            return cell
    case 1...products.count:
    
    
                let cell = tableView.dequeueReusableCell(withIdentifier: "AccessorieCell", for: indexPath) as! AccessorieTableViewCell
                cell.titleLabel.text = products[indexPath.row-1].title
                cell.descriptionLabel.text = products[indexPath.row-1].description
                cell.productImage.image = UIImage(named: "lichtleiste")
                // products[n].imageURL
                cell.productImage.contentMode = .scaleAspectFit
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accessorieTapped)))
                return cell
                
        case products.count+1 :
            
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionTableViewCell
                cell.sectionTitleLabel.text = "Other customers bought"
                return cell
        case products.count+2 ... productsOtherCustomersbought.count+products.count+2 :
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "AccessorieCell", for: indexPath) as! AccessorieTableViewCell
                cell.titleLabel.text = productsOtherCustomersbought[indexPath.row-2-products.count].title
                cell.descriptionLabel.text = productsOtherCustomersbought[indexPath.row-2-products.count].description
                cell.productImage.image = UIImage(named: "lichtleiste")
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
