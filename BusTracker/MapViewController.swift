//
//  MapViewController.swift
//  BusTracker
//
//  Created by Kulyash Konyrova on 5/20/20.
//  Copyright © 2020 Kulyash Konyrova. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var location = CLLocationCoordinate2D()
    let vc = StopViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        map.delegate = self
        print(location)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        
        DrawBus()
    }
    
    func DrawBus() {
        let point = MKCircle(center: location, radius: 4 as CLLocationDistance)
        map.addOverlay(point)
    }
        
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.red
        circle.fillColor = UIColor.red
        circle.lineWidth = 1
        return circle
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
