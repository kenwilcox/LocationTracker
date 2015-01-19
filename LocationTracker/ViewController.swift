//
//  ViewController.swift
//  LocationTracker
//
//  Created by Kenneth Wilcox on 1/18/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

  @IBOutlet weak var theMap: MKMapView!
  @IBOutlet weak var theLabel: UILabel!
  
  var manager: CLLocationManager!
  var locations: [CLLocation] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup Location Manager
    manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
    manager.pausesLocationUpdatesAutomatically = true
    manager.activityType = CLActivityType.Fitness
    
    // Setup Map View
    theMap.delegate = self
    theMap.mapType = .Standard
    theMap.showsUserLocation = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    theLabel.text = "\(locations[0])"
    self.locations.append(locations[0] as CLLocation)
    
    let spanX = 0.007
    let spanY = 0.007
    var newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
    theMap.setRegion(newRegion, animated: true)
    
    if (self.locations.count > 1) {
      var sourceIndex = self.locations.count - 1
      var destinationIndex = self.locations.count - 2
      
      let c1 = self.locations[sourceIndex].coordinate
      let c2 = self.locations[destinationIndex].coordinate
      var a = [c1, c2]
      var polyline = MKPolyline(coordinates: &a, count: a.count)
      theMap.addOverlay(polyline)
    }
  }

  func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
    if overlay is MKPolyline {
      var renderer = MKPolylineRenderer(overlay: overlay)
      renderer.strokeColor = .blueColor()
      renderer.lineWidth = 4
      return renderer
    }
    return nil
  }
  
  func startSignificantChangeUpdates() {
    self.manager.startMonitoringSignificantLocationChanges()

  }
  
}

