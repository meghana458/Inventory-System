//
//  FeaturedViewController.swift
//  Inventory System
//
//  Created by Kotte,Manoj Kumar on 10/13/16.
//  Copyright © 2016 Kotte,Manoj Kumar. All rights reserved.
//

import UIKit
import Parse
import Bolts

class FeaturedViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var announcementTV: UITableView!
    
    var detailedDescription:String = String()
    
    var numProducts:Int = Int()
    
    var products:[Announcements] = []
    //var pr:[String] = ["a","b"]
    
    //var pImage:UIImage = UIImage()
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
       // self.announcementTV.register(UINib(nibName: announcementTV, bundle: nil), forCellReuseIdentifier: "announcementCell")
//        ParseOperaions.retrieveProducts()
//        ParseOperaions.retrieveImages()

        // Do any additional setup after loading the view.
    }
    
//    override func awakeFromNib() {
//        announcementsTV.delegate = self
//        announcementsTV.dataSource = self
////        ParseOperaions.retrieveProducts()
////        ParseOperaions.retrieveImages()
//        announcementsTV.reloadData()
//    }
//
    override func viewWillAppear(_ animated: Bool) {
        ParseOperaions.retrieveProducts()
        ParseOperaions.retrieveImages()
        products = ParseOperaions.allProducts
        //print(products)
        self.announcementTV.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    let ANNOUNCEMENT_TAG = 70
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "announcementCell",for: indexPath)
        let imageLBL = cell.viewWithTag(71) as! UIImageView!
        let announcementLBL:UILabel = cell.viewWithTag(70) as! UILabel!
        announcementLBL.text = products[indexPath.row].name
        //announcementLBL.text = pr[indexPath.row]
        //print(products[indexPath.row].name)
        //let thumbnail = products[indexPath.row]["image"] as! PFFile
        
        //imageLBL?.image = products[indexPath.row].image as! UIImage
        imageLBL?.image = ParseOperaions.productImages[indexPath.row]
       // pImage = ParseOperaions.allImages[indexPath.row]
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkStatusTransaction(row: indexPath.row){
            performSegue(withIdentifier: "transaction", sender: nil)
        }else if checkStatus(row: indexPath.row){
            performSegue(withIdentifier: "billId", sender: nil)
        }else {
            performSegue(withIdentifier: "announcementId", sender: nil)
        }
        
    }
    
    
    func checkStatus(row:Int) -> Bool{
        var flag:Bool = false
        
        for productObject in ParseOperaions.allRequests{
            if productObject.productName == products[row].name && productObject.userName == AnnouncementViewController.nameOfUser {
                if productObject.productStatus == 1{
                    flag = true
                    break
                }
            }
            
        }
        return flag
    }
    
    func checkStatusTransaction(row:Int) -> Bool{
        var status:Bool = false
        
        for productObject in ParseOperaions.allRequests{
            if productObject.productName == products[row].name && productObject.userName == AnnouncementViewController.nameOfUser {
                if productObject.productStatus == 2{
                    status = true
                    break
                }
            }
            
        }
        return status
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "announcementId"{
            let announcementObjectVC = segue.destination as! AnnouncementViewController
            //announcementObjectVC.numberOfProducts = numProducts
            announcementObjectVC.numberOfProducts = products[(announcementTV.indexPathForSelectedRow?.row)!].quantity
            announcementObjectVC.aboutProduct = products[(announcementTV.indexPathForSelectedRow?.row)!].productDescription
            announcementObjectVC.navigationItem.title = products[(announcementTV.indexPathForSelectedRow?.row)!].name
            announcementObjectVC.nameOfProduct = products[(announcementTV.indexPathForSelectedRow?.row)!].name
           // announcementObjectVC.imageProduct = pImage
//            announcementObjectVC.imageProduct = ParseOperaions.allImages[(announcementsTV.indexPathForSelectedRow?.row)!]
            announcementObjectVC.imageProduct = ParseOperaions.productImages[(announcementTV.indexPathForSelectedRow?.row)!]
            
            

        }
        else if segue.identifier == "billId" {
            let bilingVC = segue.destination as! BillingViewController
            bilingVC.rowNumber = (announcementTV.indexPathForSelectedRow?.row)!
            bilingVC.pName = products[(announcementTV.indexPathForSelectedRow?.row)!].name
            bilingVC.uName = AnnouncementViewController.nameOfUser
            
        }else if segue.identifier == "transaction" {
            let transactionVC = segue.destination as! UserAccountDetailsViewController
            transactionVC.pName = products[(announcementTV.indexPathForSelectedRow?.row)!].name
            transactionVC.uName = AnnouncementViewController.nameOfUser
        }
      //  else if segue.identifier == "payment" {
      //      let transactionVC = segue.destination as! PaymentConformationViewController
      //      transactionVC.pName = products[(announcementTV.indexPathForSelectedRow?.row)!].name
      //      transactionVC.uName = PaymentConformationViewController.nameOfUser
      //  }
    
    }

    @IBAction func unwindBack(_ sender:UIStoryboardSegue){
    }
    
    
}
