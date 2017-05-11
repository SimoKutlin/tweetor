//
//  SavedPlacesViewController.swift
//  tweetor
//
//  Created by admin on 11.05.17.
//  Copyright © 2017 spp. All rights reserved.
//

import CoreData
import CoreLocation
import UIKit

class SavedPlacesViewController: UITableViewController {
    
    var favPlaces: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        do {
            favPlaces = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            let alert = UIAlertController(title: "Error", message: "Could not fetch saved places. \(error)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = editButtonItem
    }

    // Tableview datasource stuff
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPlaceCell", for: indexPath)
        
        if let cell = cell as? SavedPlaceViewController, let favPlace = favPlaces[indexPath.row] as? Location {
            cell.locationData = favPlace
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            do {
                managedContext.delete(favPlaces[indexPath.row])
                try managedContext.save()
                // Delete the row from the data source
                favPlaces.remove(at: indexPath.row)
                tableView.reloadData()
            } catch let error as NSError {
                let alert = UIAlertController(title: "Error", message: "Could not delete saved place. \(error)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // seguing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SetLocation":
                if let cell = sender as? SavedPlaceViewController,
                    let locationData = cell.locationData,
                    let seguedToMVC = segue.destination as? SearchViewController {
                    seguedToMVC.searchLocation = CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
                }
                
            default: break
            }
        }
    }
    
    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}