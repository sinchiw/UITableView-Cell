//
//  ViewController.swift
//  Custom Table & Sections
//
//  Created by Wilmer sinchi on 1/17/19.
//  Copyright © 2019 Wilmer sinchi. All rights reserved.
//

import UIKit
import Contacts


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //set up the pararmeter
    func someTestingMethod (cell: UITableViewCell) {
        
        print("something abiut testing a method called from other viewController")
        
        //cell is from the paremter in this func, indexPathTap check what cell you tap into
        guard let indexPathTap =  tableView.indexPath(for: cell) else { return }
//        print(indexPathTap)
        // this give the actual element or name of cell that you tap
        let contact = twoDimensionalArray[indexPathTap.section].name[indexPathTap.row]
        print(contact)
        let hasFavorited = contact.hasFavorited
        twoDimensionalArray[indexPathTap.section].name[indexPathTap.row].hasFavorited = !hasFavorited
        //MARK: this is another way of doing this
//        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : UIColor.red
        
        tableView.reloadRows(at: [indexPathTap], with: .fade)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var showIndexPath = false
    //this is an array of names
    let names = [
        "Alex", "Steve", "Meow", "Rob"
    ]
    
    
    
    let anotherListOfName = [
        "Cristina", "Carol","Chris", "Carmela"
    ]
    //array inside an array , it was a temp usage but since we need to close and open row =, we would have to use dataStructure(isExpanded)
    //this varibal is empty according to the empty parenthesis
    var twoDimensionalArray = [ExpandableNames]()
//    since the datastructure was change we would have to use a different one for the api
    /*var twoDimensionalArray = [
//the .map will loop through the whole array and set this up
        ExpandableNames(isExpanded: true, name: [ "Alex", "Steve", "Meow", "Rob"].map{FavoritableContact(name: $0, hasFavorited: false)}),
        ExpandableNames(isExpanded: true, name: ["Cristina", "Carol","Chris", "Carmela"].map{FavoritableContact(name: $0, hasFavorited: false)}),
        ExpandableNames(isExpanded: true, name: ["Mike", "Steve", "Raplh"].map{FavoritableContact(name: $0, hasFavorited: false)}),
        // dataStructure
        ExpandableNames(isExpanded: true, name: [FavoritableContact(name: "Bojack", hasFavorited: false)]),
        
       
        
        
    ]
    */
    private func fetchContact()
    {
        print("Attempting to fetch contact todya")
        let store  = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err{
                print("failed to request access", err)
                
                return
            }
            if granted {
                print("Access granted")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    //this variable is an array
                    var favoritabelContacts = [FavoritableContact]()
                    try  store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        // if you want get the other , you would have to specify in the keys variabal.
                        print (contact.givenName)
                        print (contact.familyName)
                        // remmber waht the ?? operator does which is a nil cloasing
                        print (contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        favoritabelContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
//                        favoritabelContacts.append(FavoritableContact(name: contact.givenName + "" + contact.familyName, hasFavorited:false ))
                    })
                    
                    // so you are getting all the contact from your phone and putting in the array
                    //using this varibal to add more contact name
                    let names = ExpandableNames(isExpanded: true, name: favoritabelContacts)
                    // storing the varibal in the contact array using the two dimmensional array.
                    self.twoDimensionalArray = [names]
                } catch let err {
                    print("Failed to Enumerate Contacts:", err)
                }
                
                
            } else {
                print("Access Denied!")
            }
        }
        
        //
        
        
    }
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let view = UIView()
        let button = UIButton(type:.system)
//        button.
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont(name: "Maker Felt", size: 30)
        
        // figure this out later
//        button.frame.origin.x = 50
//        button.addSubview(button)
        
//
//        let label = UILabel()
        // counting how many rows in twoDinemesinoArray per sections
//        let sectionCount = twoDimensionalArray[section].count
//        let sectionCount2 = twoDimensionalArray.count
//        label.text = "Header"
////        label.text = String(sectionCount2)
//
//        label.font = UIFont(name: "Marker Felt", size: 35)
//        label.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        // setting the button number based on the sections
        button.tag = section
        return button
        
        
    }
    //specifying what are you clicking on
    @objc func handleOpenClose(button: UIButton){
        print("tryin to see if it expand or close")
        // we tested to see if the tag correspond to the section number
        print(button.tag)
        ///it will crash at first becuase the row will be deleted as it it runs its something to be in the row(1)
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in twoDimensionalArray[section].name.indices{
            
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpanded = twoDimensionalArray[section].isExpanded
        //the other way of chaning the title ///////////////////////////////////////////////////////
//        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        //this would reverse the boolean, saying that it is not expanded(false) when you click the button and, so when you are in the numberofRowsinSections it would retunr zero rows in the section since it is not expanded.
        twoDimensionalArray[section].isExpanded = !isExpanded
        //remember to add this code to avoid the crash in the previos(1)
        
        if isExpanded {
            button.setTitle("Open", for: .normal)
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            button.setTitle("Close", for: .normal)
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        // re
//        twoDimensionalArray[section].removeAll() this remove the rows but its not practical in twodimisionarray
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDimensionalArray[section].isExpanded{
            return 0
        }
        // you can control number of rows in a sections
//        if section == 0 {
//            return names.count
//        }
//        return anotherListOfName.count
        //
        return twoDimensionalArray[section].name.count
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCell
        let cell = ContactCell(style: .subtitle, reuseIdentifier: "cell")
        
        // need this code to test other function from the cell class
//        cell.favoriteStar.image = UIImage(named: "star1")
        //        cell.textLabel?.text = name[indexPath.row]
        //easier way of putting more sections
        let sectionsNames = twoDimensionalArray[indexPath.section].name[indexPath.row]
//        if indexPath.section == 0{
//            names[indexPath.row]
        
        cell.link = self
//            cell.textLabel?.text = "\(names[indexPath.row]) Sections:\(indexPath.section) Row:\(indexPath.row)"
        cell.accessoryView?.tintColor = sectionsNames.hasFavorited ? UIColor.red : .gray
//        } else  { anotherListOfName[indexPath.row]
//            cell.textLabel?.text = "\(anotherListOfName[indexPath.row]) Sections:\(indexPath.section) Row:\(indexPath.row)"
//
//        }
        if showIndexPath{
        
        cell.textLabel?.text = "\(sectionsNames.contact.givenName) Sections:\(indexPath.section) Row:\(indexPath.row)"
        } else {
            cell.textLabel?.text = sectionsNames.contact.givenName + " " + sectionsNames.contact.familyName
            //to add the detail label
            cell.detailTextLabel?.text = sectionsNames.contact.phoneNumbers.first?.value.stringValue
            //this wont work if you change the style of the cell
        }
        
        
        
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "cell")
        fetchContact()
        // Do any additional setup after loading the view, typically from a nib.
        //making the bar into large title
        navigationBar.prefersLargeTitles = true
//        navigationBar =
//        navigationBar.setItems(÷, animated: <#T##Bool#>)
//        navigationBar.setItems(UIBarButtonItem, animated: <#T##Bool#>)
//       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        //make the class into uitableview
        
    }
    @IBAction func HandleShowIndexPath(_ sender: Any) {
        //Build all the indexPath we want to Reload () is the empty list
        var indexPathReload = [IndexPath]()
        
//        let isExpanded = twoDimensionalArray.isExpanded
        /*//this how we reload row for a specific section /////////
        //indixes prints out all the index in the array of the first element of the array or sections in this case
        for index in twoDimensionalArray[0].indices{
//            print(index);
             let indexPath = IndexPath(row: index, section: 0)
            //usigng this instead od Indepath(row: 0 , sections :0)
            // adding the indexpath(row :index... intos the var
            indexPathReload.append(indexPath)\
         
            
         }
       
         
        */
       

        //this is how we realod all of the row in different sections
        for sections in twoDimensionalArray.indices{
            print(sections)
            
            let isExpanded = twoDimensionalArray[sections].isExpanded
            
            for rows in twoDimensionalArray[sections].name
                .indices {
            let indexPath = IndexPath(row: rows, section: sections)
                    if isExpanded  {
                print(sections, rows)
                indexPathReload.append(indexPath)
                    }
            }
        }
        
        showIndexPath = !showIndexPath
        let animationStyle = showIndexPath ? UITableView.RowAnimation.right : .left

        //use the var of indexPathReload and
//        //reloading
//        tableView.reloadSections(section, with: .left)
//        let indexSet  = IndexSet(names.indices)
         tableView.reloadRows(at: indexPathReload, with: animationStyle)
        // this how the animate will show left and right
        
        
        
//        if let animationPath = showIndexPath{
//            UITableView.RowAnimation.right {
//            }else
//            { UITableView.RowAnimation.left
//
//            }
//        let animationStyle = showIndexPath ? UITableView.RowAnimation.right : .left
        
        
//         tableView.reloadSections(indexSet, with: .left)
        
        // this below is how you would reload the section view
//        let  indexSet2 = IndexSet(twoDimensionalArray.indices)
//
//        tableView.reloadSections(indexSet2, with: animationStyle)
    
//
//        let indexPath = IndexPath(row: 0, section: 0)
//        //if you jump to the definition on the .left than you can see other types of animations
//        tableView.reloadRows(at: [indexPath], with: .left)
//        print("reloading IndexPath")
    }
    
}

