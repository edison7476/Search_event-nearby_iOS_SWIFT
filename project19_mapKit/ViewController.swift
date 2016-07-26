//
//  ViewController.swift
//  project19_mapKit
//
//  Created by Jia Wang on 7/24/16.
//  Copyright © 2016 Jia Wang. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    let locationManager = CLLocationManager()
    var currentLatitude: CLLocationDegrees?
    var currentLogitude: CLLocationDegrees?
    var selectedDate: String?
    var selectedCategory: String?

    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBAction func distanceSlider(sender: UISlider) {
        let sliderValue = lroundf(sender.value)
        distanceLabel.text = "\(sliderValue)"
    }
    @IBOutlet weak var myPicker: UIPickerView!
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last // grab the most current location
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        //print(center)
        currentLatitude = location!.coordinate.latitude
        currentLogitude = location!.coordinate.longitude
    }
    
    @IBAction func annotation(sender: AnyObject) {
        //mapView.addAnnotations([sf])
        eventModel.getEvent(String(currentLatitude!), lng: String(currentLogitude!),distance: distanceLabel.text!,  eventDate: selectedDate!, eventCategory: selectedCategory!){
            data, response, error in
            //print("Seraching events withini \(self.distanceLabel.text!) miles")
            print ("Obtained the following data")
            //print(data)
            do{
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    print(" ### jsonResults ###")
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    if let results = jsonResult["events"]!["event"]{
                        print(results)
                        let resultsArray = results as! NSArray!
                        
                        //print(resultsArray)
                     
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                for i in 0..<resultsArray.count{
                                    
                                    let pinTitle = String(resultsArray[i]["title"]!!)
                                    let pinSubtitle = String(resultsArray[i]["url"]!!)
                                    let pinDescription = String(resultsArray[i]["description"]!!)
                                    let pinLat =   Double(String(resultsArray[i]["latitude"]!!))
                                    let pinLng = Double(String(resultsArray[i]["longitude"]!!))
                                    let startTime = String(resultsArray[i]["start_time"]!!)
                                    let venueName = String(resultsArray[i]["venue_name"]!!)
                                    let venuewAddress = String(resultsArray[i]["venue_address"]!!)
                                    let cityName = String(resultsArray[i]["city_name"]!!)
                                    
                                    print(pinTitle)
                                    print(pinSubtitle)
                                    print(pinLat)
                                    print(pinLng)
                                    let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(pinLat!), CLLocationDegrees( pinLng!))
                                    
                                    //let objectAnnotation = MKPointAnnotation()
                                    //
                                    //                           objectAnnotation.coordinate = pinLocation
                                    //                            objectAnnotation.title = pinTitle
                                    //                            objectAnnotation.subtitle = pinSubtitle
                                    
                                    let objectAnnotation = Capital(title: pinTitle, subtitle: "", coordinate: pinLocation, info: [startTime, venueName, venuewAddress, cityName, pinDescription])
                                self.mapView.addAnnotation(objectAnnotation)}
                                //self.mapView.reloadInputViews()
                            })
                        
                    }
                }
            }
            catch {
                print("\(error)")
            }
            
        }// end of task = session.dataTaskWithURL
}

    @IBOutlet weak var mapView: MKMapView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization() // SET USER authorization to be alway allowed
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation() // this turns on location service
        self.mapView.showsUserLocation = true
        
        myPicker.delegate = self
        myPicker.dataSource = self
        myPicker.selectRow(1, inComponent: PickerComponent.date.rawValue, animated: false)
        myPicker.selectRow(1, inComponent: PickerComponent.category.rawValue, animated: false)
        updateLabel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        let identifier = "Capital"
        if annotation is Capital {
        
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func eventSaver (){
        print("save this event")
        // save the selected event in core data
    
    }
    
func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let capital = view.annotation as! Capital
    let placeName = capital.title
    let placeInfo = capital.info
    //print(placeInfo)
    
    
    let ac = UIAlertController(title: placeName, message: "Strat Time: \(placeInfo[0])\n Venue: \(placeInfo[1])\n Address: \(placeInfo[2]), \(placeInfo[3]) \n Description: \(placeInfo[4])", preferredStyle: .ActionSheet)
   
    ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil ))
    ac.addAction(UIAlertAction(title: "Save", style: .Default, handler: {(alert: UIAlertAction!) in self.eventSaver() }))
    
    let height:NSLayoutConstraint = NSLayoutConstraint(item: ac.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
    ac.view.addConstraint(height);
    
    presentViewController(ac, animated: true, completion: nil)
    }
    
//###############################################################################################
//###   Picker View
//###############################################################################################
    
    
    let pickerData = [["Today", "This Week", "This Weekend", "This Month"],
                      ["Music","Music Festivals","Comedy","Family","Performing Arts","Museums","Sports","Science", "Exhibits"]]
    
    enum PickerComponent:Int{
        case date = 0
        case category = 1
    }
    
    func updateLabel(){
        
        let dateComponent = PickerComponent.date.rawValue
        var categoryComponent = PickerComponent.category.rawValue
        
        let date = pickerData[dateComponent][myPicker.selectedRowInComponent(dateComponent)] //String type
        let category = pickerData[categoryComponent][myPicker.selectedRowInComponent(categoryComponent)] //String Type
        
        
        selectedDate = date
        selectedCategory = category
    }
    
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        return 1
//    }
    //MARK -Delgates and DataSource
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    
//    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 15.0
//    }
//    
    

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(pickerData.count)
//            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = pickerData[component][row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 12.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
       pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        
        return pickerLabel
    }
}















