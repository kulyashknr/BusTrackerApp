//
//  StopViewController.swift
//  BusTracker
//
//  Created by Kulyash Konyrova on 4/22/20.
//  Copyright © 2020 Kulyash Konyrova. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class StopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var firstStopSearch: UISearchBar!
    @IBOutlet weak var secondStopSearch: UISearchBar!
    @IBOutlet weak var firstStopList: UITableView!
    @IBOutlet weak var secondStopList: UITableView!
    @IBOutlet weak var tableViewFirstHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewSecongHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var BusList: UITableView!
    @IBOutlet weak var FindButton: UIButton!
    
    var allStops = [Stop]()
    var buses = [Bus]()
    var searchStop = [String]()
    
    var searchingFirst = false
    var searchingSecond = false
    var pressed = false
    
    var firstStopId = 0
    var secondStopId = 0
    var req_id = 0
    
    let myarray = ["item1", "item2", "item3"]
    
    var BusLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "allStops", withExtension: "json")!)
            allStops = try JSONDecoder().decode([Stop].self, from: data)
            
                 firstStopList.delegate = self
                 firstStopList.dataSource = self
                 firstStopList.reloadData()
                 firstStopList.register(UITableViewCell.self, forCellReuseIdentifier: "FirstStopCell")
                     
                 secondStopList.delegate = self
                 secondStopList.dataSource = self
                 secondStopList.reloadData()
                 secondStopList.register(UITableViewCell.self, forCellReuseIdentifier: "SecondStopCell")
                     
                 BusList.delegate = self
                 BusList.dataSource = self
                 BusList.reloadData()
                 BusList.isHidden = true
        } catch { print(error) }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.BusList {
            return buses.count
        }
        else {
            if searchingFirst || searchingSecond {
                if searchingFirst {
                    firstStopList.isHidden = false
                    secondStopList.isHidden = true
                }
                else {
                    secondStopList.isHidden = false
                    firstStopList.isHidden = true
                }
                if searchStop.count < 4 {
                    tableViewFirstHeightConstraint.constant = CGFloat(searchStop.count*44)
                    tableViewSecongHeightConstraint.constant = CGFloat(searchStop.count*44)
                }
                else {
                    tableViewFirstHeightConstraint.constant = 132
                    tableViewSecongHeightConstraint.constant = 132
                }
                return searchStop.count
            }
            else {
                firstStopList.isHidden = true
                secondStopList.isHidden = true
                return 1
            }
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        //var BusName : UILabel!
        
        if tableView == BusList {
            let BusCell = BusList.dequeueReusableCell(withIdentifier: "BusCell") as! BusTableViewCell
            BusCell.BusName.text = "№"+buses[indexPath.row].name
            BusCell.BusNumber.text = buses[indexPath.row].number
            if (buses[indexPath.row].distance > 2) {
            BusCell.BusTime.text = String(buses[indexPath.row].distance)+" min"
            }
            else {
                BusCell.BusTime.text = "прибывает"
            }
            return BusCell
        }
        
        if searchingFirst {
            cell = firstStopList.dequeueReusableCell(withIdentifier: "FirstStopCell")!
            cell.textLabel!.text = searchStop[indexPath.row]
            
            return cell
        }
        if searchingSecond {
            cell = secondStopList.dequeueReusableCell(withIdentifier: "SecondStopCell")!
            cell.textLabel!.text = searchStop[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)!
        if tableView == BusList {
            BusLocation = CLLocationCoordinate2D(latitude: Double(buses[indexPath.row].buslt)!, longitude: Double(buses[indexPath.row].busln)!)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(identifier: "MapViewController") as? MapViewController else { return }
            vc.location = BusLocation
            
            show(vc, sender: nil)
        }
        if searchingFirst {
            firstStopSearch.text = currentCell.textLabel!.text
            for stop in allStops {
                if stop.Name == firstStopSearch.text {
                    firstStopId = stop.Id
                }
            }
            searchingFirst = false
        } else if searchingSecond {
            secondStopSearch.text = currentCell.textLabel!.text
            for stop in allStops {
                if stop.Name == secondStopSearch.text {
                    secondStopId = stop.Id
                }
            }
            searchingSecond = false
        }
        firstStopList.reloadData()
        secondStopList.reloadData()
    }
    
    func searchBar( _ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            firstStopList.isHidden = true
            secondStopList.isHidden = true
        }
        if searchBar == firstStopSearch {
            searchStop.removeAll()
            searchingFirst = true
        }
        
        if searchBar == secondStopSearch {
            searchStop.removeAll()
            searchingSecond = true
        }
        
        for stop in allStops {
            if stop.Name.lowercased().contains(searchBar.text!.lowercased()) {
                searchStop.append(stop.Name)
            }
        }
        
        firstStopList.reloadData()
        secondStopList.reloadData()
    }
    
    
/*  search by enter
     
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchStop.removeAll()

        for stop in allStops {
            if stop.Name.lowercased().contains(searchBar.text!.lowercased()) {
                searchStop.append(stop.Name)
            }
        }

        firstStopList.reloadData()
        secondStopList.reloadData()
    }
*/
    
    @IBAction func findAction(_ sender: UIButton) {
        pressed = true
        BusList.isHidden = false
        print(firstStopId, secondStopId)
        
        Alamofire.request("http://127.0.0.1:8000/route/", method: .post, parameters: ["start_station": firstStopId, "end_station": secondStopId]).validate().responseJSON { responseJSON in

            switch responseJSON.result {
            case .success(let value):
                let post_req = value as! Dictionary<String,Any>
                self.req_id = post_req["id"]! as! Int
                print("success! new request: ",  "http://127.0.0.1:8000/route/"+String(self.req_id)+"/")
                self.getRequest(req_id: self.req_id)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getRequest(req_id : Int) {
        Alamofire.request("http://127.0.0.1:8000/route/"+String(req_id)+"/", method: .get).responseJSON { response in
            guard let value = response.result.value else {
                print("Error: did not receive data")
                return
            }

            guard response.result.error == nil else {
                print("error calling GET on /posts/1")
                print(response.result.error!)
                return
            }

            do {
                let busesDict = value as! Array<Dictionary<String,Any>>
                self.convertToBus(busesDict: busesDict)
            } catch let error as NSError {
                print(error)
            }
        }
        }
    
    func convertToBus(busesDict : Array<Dictionary<String,Any>>) {
        buses.removeAll()
        for bus in busesDict {
            buses.append(Bus(distance: bus["distance"] as! Float, name: bus["name"] as! String, number: bus["number"] as! String, buslt: bus["lat"] as! String, busln: bus["lon"] as! String))
        }
        buses = buses.sorted() {
            $0.distance < $1.distance
        }
        print(buses)
        BusList.reloadData()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.identifier == "mapSegue" {
//            if segue.destination is MapViewController
//            {
//                let vc = segue.destination as! MapViewController
//                vc.location = BusLocation
//                print("STOPVC:", BusLocation)
//            }
//        }
//    }
    
    struct Stop: Decodable {
        var Id: Int
        var Name: String
    }

    struct Bus: Decodable {
        var distance: Float
        var name: String
        var number: String
        var buslt : String
        var busln : String
    }

}


