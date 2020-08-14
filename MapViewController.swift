//
//  MapViewController.swift
//  
//
//  Created by Kulyash Konyrova on 5/20/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        var location = StopViewController.BusLocation.location
        let span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        
        DrawBus()
    }
    
    func DrawBus() {
        let point = MKCircle(center: location, radius: 5 as CLLocationDistance)
        map.addOverlay(point)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        var circle = MKCircleRenderer(overlay: overlay)
//        circle.strokeColor = UIColor.red
//        circle.fillColor = UIColor.red
//        circle.lineWidth = 1
//        return circle

    }
    
    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
