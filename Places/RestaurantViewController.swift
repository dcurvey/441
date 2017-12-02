//
//  RestaurantViewController.swift
//  Places
//
//  Created by Aren Vogel on 11/28/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

import CoreLocation
import MapKit

class RestaurantViewController: UIViewController {
  fileprivate var places = [Place]()
  @IBOutlet weak var mapView: MKMapView!
  fileprivate let locationManager = CLLocationManager()
  
  var arViewController: ARViewController!
  var startedLoadingPOIs = false
    //var RatingInt = Double()
  var PriceInt = Int()
  var NameString = ""
  var NumberString = ""
  var RatingDouble = Double()
  var Address = ""
  var photoRef = ""
  var photoWid = Int()
  
  
  
  @IBAction func LaunchAr(_ sender: Any) {
    arViewController = ARViewController()
    arViewController.dataSource = self
    arViewController.maxDistance = 0
    arViewController.maxVisibleAnnotations = 30
    arViewController.maxVerticalLevel = 5
    arViewController.headingSmoothingFactor = 0.05
    
    arViewController.trackingManager.userDistanceFilter = 25
    arViewController.trackingManager.reloadDistanceFilter = 75
    arViewController.setAnnotations(places)
    arViewController.uiOptions.debugEnabled = false
    arViewController.uiOptions.closeButtonEnabled = true
    
    self.present(arViewController, animated: true, completion: nil)
  }
  
    //@IBOutlet weak var Rating: UILabel!
  @IBOutlet weak var AddressLabel2: UILabel!
  @IBOutlet weak var Price: UILabel!
  @IBOutlet weak var Name: UILabel!
  @IBOutlet weak var Number: UILabel!
  @IBOutlet weak var Rating: UILabel!
  @IBOutlet weak var AddressLabel: UILabel!
  @IBOutlet weak var Photo: UIImageView!
  override func viewDidLoad() {
    super.viewDidLoad()
        //Rating.text = String(RatingInt)
    let price = String(PriceInt)
    
    let loader = PlacesLoader()
    loader.loadImg(photoRef: photoRef, photoWid: photoWid){ responseImg, error in
      if let img = responseImg {
        print(img)
      }
    }
    //var photoURL
    //var photoImg = UIImage(named: photoURL)
    
    //Photo.image = photoImg
    
      switch price
      {
      case "1":
        Price.text = " $"
      case "2":
        Price.text = " $$"
      case "3":
        Price.text = " $$$"
      case "4":
        Price.text = " $$$$"
      case "5":
        Price.text = " $$$$$"
      default:
        Price.text = " N/A"
      }
        Name.text = NameString
        Number.text = NumberString
        Rating.text = "Rating: " + String(RatingDouble)
    
    
        var x = Address.components(separatedBy: ",")
      AddressLabel.text = x[0] + ","
      AddressLabel2.text = x[1]
        //Website.text = WebsiteString
        
      
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func showInfoView(forPlace place: Place) {
    //let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantViewController")
    
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let myVC = storyBoard.instantiateViewController(withIdentifier: "RestaurantViewController") as! RestaurantViewController
    
    myVC.NameString = place.placeName
    myVC.PriceInt = place.placePrice
    myVC.photoRef = place.photoRef!
    myVC.photoWid = place.photoWidth!
    //myVC.RatingInt = place.placeRate
    
    if let x = place.phoneNumber{
      myVC.NumberString = x
    }
    
    //    DispatchQueue.main.async{
    //      let vc = self.view?.window?.rootViewController
    //      vc?.present(myVC, animated: true, completion: nil)
    //
    //    }
    
    DispatchQueue.main.async {
      let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
      appDelegate.window?.rootViewController = myVC
    }
    
    
    //    DispatchQueue.main.async {
    //      self.present(myVC, animated: false, completion: nil)
    //    }
    //self.navigationController?.pushViewController(myVC, animated: true)
    
    
    
    //    let alert = UIAlertController(title: place.placeName , message: place.infoText, preferredStyle: UIAlertControllerStyle.alert)
    //    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    //
    //    arViewController.present(alert, animated: true, completion: nil)
  }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


extension RestaurantViewController: CLLocationManagerDelegate {
  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if locations.count > 0 {
      let location = locations.last!
      if location.horizontalAccuracy < 100 {
        manager.stopUpdatingLocation()
        let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.region = region
        
        if !startedLoadingPOIs {
          startedLoadingPOIs = true
          let loader = PlacesLoader()
          loader.loadPOIS(location: location, radius: 1000) { placesDict, error in
            if let dict = placesDict {
              guard let placesArray = dict.object(forKey: "results") as? [NSDictionary]  else { return }
              
              for placeDict in placesArray {
                let latitude = placeDict.value(forKeyPath: "geometry.location.lat") as! CLLocationDegrees
                let longitude = placeDict.value(forKeyPath: "geometry.location.lng") as! CLLocationDegrees
                let reference = placeDict.object(forKey: "reference") as! String
                let name = placeDict.object(forKey: "name") as! String
                let address = placeDict.object(forKey: "vicinity") as! String
                let rating = placeDict.object(forKey: "rating") as! Double
                var price = 0
                if((placeDict.object(forKey: "price_level")) != nil)
                {
                  price =
                    placeDict.object(forKey: "price_level") as! Int
                }
                
                
                let photoDict = placeDict["photos"] as? NSArray
                let photoDictSub = photoDict?[0] as? NSDictionary
                let photoRef = photoDictSub?["photo_reference"] as! String
                let photoWidth = photoDictSub?["width"] as! Int
                let openingHours = placeDict["opening_hours"] as! NSDictionary?
                let open = openingHours?["open_now"] as! Bool
                
                
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let place = Place(location: location, reference: reference, name: name, address: address, rating: rating, price: price, photoRefe: photoRef, photoWid: photoWidth, open: open)
                
                self.places.append(place)
                let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.placeName)
                DispatchQueue.main.async {
                  self.mapView.addAnnotation(annotation)
                }
              }
            }
          }
        }
      }
    }
  }
}
extension RestaurantViewController: ARDataSource {
  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
    let annotationView = AnnotationView()
    annotationView.annotation = viewForAnnotation
    annotationView.delegate = self
    annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
    
    return annotationView
  }
}

extension RestaurantViewController: AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView) {
    if let annotation = annotationView.annotation as? Place {
      let placesLoader = PlacesLoader()
      placesLoader.loadDetailInformation(forPlace: annotation) { resultDict, error in
        
        if let infoDict = resultDict?.object(forKey: "result") as? NSDictionary {
          annotation.phoneNumber = infoDict.object(forKey: "formatted_phone_number") as? String
          annotation.website = infoDict.object(forKey: "website") as? String
          
          self.showInfoView(forPlace: annotation)
          
        }
      }
      
    }
  }
}


