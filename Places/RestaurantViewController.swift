//
//  RestaurantViewController.swift
//  Places
//
//  Created by Aren Vogel on 11/28/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {

    var arViewController: ARViewController!
    //var RatingInt = Double()
    var PriceInt = Int()
    var NameString = ""
    var NumberString = ""
  
  
  
  
    //@IBOutlet weak var Rating: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Number: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Rating.text = String(RatingInt)
        var price = String(PriceInt)
      
     
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
        //Website.text = WebsiteString
        
      
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


