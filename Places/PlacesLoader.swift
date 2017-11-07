/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import CoreLocation
//              let temp = restaurantInformation(name: String, price: NSNumber, rating: NSNumber, address: String, open: Bool)


struct restaurantInformation {
  var name: String
  var price: Int
  var rating: Double
  var address: String
  var open: Bool
}

struct PlacesLoader {
  let apiURL = "https://maps.googleapis.com/maps/api/place/"
  let apiKey = "AIzaSyDgt9HpXXLMLEUe5sOWPIXpEHmqgHCEyaw"
  
  func loadPOIS(location: CLLocation, radius: Int = 30, handler: @escaping (NSDictionary?, NSError?) -> Void) {
    print("Load pois")
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    
    let uri = apiURL + "nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&sensor=true&types=restaurant&key=\(apiKey)"
    
    let url = URL(string: uri)!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let dataTask = session.dataTask(with: url) { data, response, error in
      if let error = error {
        print(error)
      } else if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          print(data!)
          
          do {
            let responseObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            guard let responseDict = responseObject as? NSDictionary else {
              return
            }
            
            
            //////////WHERE THE START OF THE API LOOKING STARTS/////////////////
            guard let placesArray = responseDict.object(forKey: "results") as? [NSDictionary]  else { return }
            print (placesArray)
            for placeDict in placesArray {
             // print(placeDict.allKeys)
//              var name = ""
//              var price = ""
//              var rating = ""
//              var address = ""
//              var hours = ""
              print (placeDict)
              print ("")
              if let name = placeDict["name"] as! String?{
                print (name)
                if let price = placeDict["price_level"] as! Int?{
                  print (price)
                  if let address = placeDict["vicinity"] as! String?{
                    print (address)
                    if let rating = placeDict["rating"] as! Double?{
                      print (rating)
                      if let openingHours = placeDict["opening_hours"] as! NSDictionary?{
                        if let open = openingHours["open_now"] as! Bool? {
                          print (open)
                          let temp = restaurantInformation(name: name, price: price, rating: rating, address: address, open: open)
                          print (temp)
                        }
                      }
                    }
                  }
                }
              }              
            }
          //////////////// END OF RETRIEVING STUFF FROM THE API////////////////////
            
            handler(responseDict, nil)
      
          } catch let error as NSError {
            handler(nil, error)
          }
        }
      }
    }
    
    dataTask.resume()
  }
  
  func loadDetailInformation(forPlace: Place, handler: @escaping (NSDictionary?, NSError?) -> Void) {
    
    let uri = apiURL + "details/json?reference=\(forPlace.reference)&sensor=true&key=\(apiKey)"
    
    let url = URL(string: uri)!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let dataTask = session.dataTask(with: url) { data, response, error in
      if let error = error {
        print(error)
      } else if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          print(data!)
          
          do {
            let responseObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            guard let responseDict = responseObject as? NSDictionary else {
              return
            }
            
            handler(responseDict, nil)
            
          } catch let error as NSError {
            handler(nil, error)
          }
        }
      }
    }
    
    dataTask.resume()

  }
}
