//
//  MainViewController.swift
//  TigerEvent Login
//
//  Created by linChunbin on 10/13/18.
//  Copyright © 2018 clpk8. All rights reserved.
//

import UIKit
import EventKit
import WebKit

class MainViewController: UIViewController {

    var token:String?
    var userID:String?
    var refreshToken:String?
    
    struct Event{
        var id: String
        var title: String
        var description: String?
        var departnemt: Int?
        var location: String
        var image: String?
        var submissionTime: Date
        var eventTime: Date
    }
    
    override func viewDidLoad() {
        //webView.loadHTMLString(<#T##string: String##String#>, baseURL: <#T##URL?#>)
        super.viewDidLoad()
        print(token)
        print(userID)
        print(refreshToken)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: {(granted, error) in
            
            if (granted) && (error == nil)
            {
                print("granted \(granted)")
                
                //v把event的location， title,dates附值，
                //notes是description
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.location = "Columbia, MO"
                event.title = "Tiger hack second test"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "This is testKDSJbfkajsdbfkhasjdbfkhasdbfkah"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                }catch let error as NSError{
                    print("error : \(error)")
                }
                print("Save Event")
                
                //forward token
                if let token : String = self.token{
                    self.post(token: token)
                }
                
                self.generateJson(event: event)
            }else{
                print("error : \(String(describing: error))")
            }
            
        })
        
    }
    
    func generateJson(event:EKEvent){
        
        if let userID = userID,
            let token = token{
            
            var Dictionary : [String : Any] =  [
                "UserId":userID,
                "Token":token,
                "Title": event.title,
                "Location": "Columbia, MO",
                "StartTime": "02/12/2121",
                "EndTime": "03/12/1990",
                "Description": "description",
            ];
            
            if let description = event.notes{
                Dictionary["Description"] = description
            }
            let validJSON = JSONSerialization.isValidJSONObject(Dictionary)
            
            //test
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: Dictionary, options: [])
                //let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                
                
                if let theJSONText = String(data: jsonData , encoding: .utf8){
                        print(theJSONText)
                }
                
            } catch{
                print(error.localizedDescription)
                
            }
            
        }
        else{
            
        }
    }
    
    
    func post(token:String){
        let myUrl = URL(string: "https://tigerhack-219301.appspot.com/api/events")!
        var request = URLRequest(url:myUrl)
        request.httpMethod = "POST"
        let postData = token.data(using: .utf8)
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // Now we can access value of First Name by its key
                    let firstNameValue = parseJSON["firstName"] as? String
                    print("firstNameValue: \(firstNameValue)")
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
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
