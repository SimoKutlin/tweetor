//
//  SavedPlacesViewController.swift
//  tweetor
//
//  Created by simo.kutlin on 03.05.17.
//  Copyright © 2017 simo.kutlin All rights reserved.
//

import CoreData
import CoreLocation
import UIKit

class SavedPlacesViewController: UITableViewController {
    
    var favPlaces: [NSManagedObject] = []
    
    // needed to pass back search location to search controller
    weak var delegate: SearchLocationDelegate? = nil
    
    
    // MARK: - UI preparation
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetch saved places from core data
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

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPlaceCell", for: indexPath)
        
        if let cell = cell as? SavedPlaceViewCell, let favPlace = favPlaces[indexPath.row] as? Location {
            cell.locationData = favPlace
        }
        
        return cell
    }
    
    // set search location in search controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = self.favPlaces[indexPath.row]
        let customLocation = CLLocationCoordinate2D(latitude: place.value(forKey: "latitude") as! CLLocationDegrees, longitude: place.value(forKey: "longitude") as! CLLocationDegrees)
        delegate?.search(withLocation: customLocation, locationType: "saved")
        _  = navigationController?.popViewController(animated: true)
        
    }
    
    // make table view editable and user be able to delete saved places
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
        
    // other stuff xcode gave me
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
