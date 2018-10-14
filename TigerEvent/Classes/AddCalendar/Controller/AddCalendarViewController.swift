//
//  ViewController.swift
//  TigerEvent Login
//
//  Created by linChunbin on 10/13/18.
//  Copyright © 2018 clpk8. All rights reserved.
//

import UIKit
import EventKit

class AddCalendarViewController: UIViewController {
    
    var event: Event!
    
    @IBOutlet weak var outlookBtn: UIButton!
    @IBOutlet weak var googleLoginBtn: UIButton!
    
    let service = OutlookService.shared()
    var token:String?
    var userID:String?
    var refreshToken:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogInState(loggedIn: service.isLoggedIn)
    }
    
    
    func setLogInState(loggedIn: Bool) {
        if (loggedIn) {
            outlookBtn.setTitle("Log Out", for: UIControl.State.normal)
        }
        else {
            outlookBtn.setTitle("Log In", for: UIControl.State.normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
    @IBAction func addToAppleCalendarButtonClick(_ sender: UIButton) {
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: {(granted, error) in
            
            if (granted) && (error == nil)
            {
                print("granted \(granted)")
                
                //v把event的location， title,dates附值，
                //notes是description
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.location = self.event.location
                event.title = self.event.title
                event.startDate = self.event.eventTime
                event.endDate = Date(timeInterval: 60 * 60, since: self.event.eventTime)
                event.notes = self.event.desc
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                }catch let error as NSError{
                    print("error : \(error)")
                }
                print("Save Event")

            }else{
                
            }
            
        })
    }
    @IBAction func addToMSCalendarClick(_ sender: UIButton) {
        if (service.isLoggedIn) {
            addMSCalendar()
            
            setLogInState(loggedIn: false)
        } else {
            // Login
            service.login(from: self) {
                error in
                if let unwrappedError = error {
                    NSLog("Error logging in: \(unwrappedError)")
                } else {
                    NSLog("Successfully logged in.")
                    self.setLogInState(loggedIn: true)
                    self.addMSCalendar()
                }
            }
        }
    }
    
    private func addMSCalendar() {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.string(forKey: "MSToken")!
        
        var request = URLRequest(url: URL(string: "https://graph.microsoft.com/v1.0/me/events")!)
        request.addValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //                    request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJub25jZSI6IkFRQUJBQUFBQUFDNXVuYTBFVUZnVElGOEVsYXh0V2pUOTMzTDZReDRzYlBoNUItVUlPSC1IUlN6YTRLVUJ5SkNlcWtnaEhHYzVFRGlPX0MtTkxVQzF5NVlWUlNOa1FGTDFQSzFVb2pwSXFGaGR5dXg2T0FoV1NBQSIsImFsZyI6IlJTMjU2IiwieDV0IjoiaTZsR2szRlp6eFJjVWIyQzNuRVE3c3lISmxZIiwia2lkIjoiaTZsR2szRlp6eFJjVWIyQzNuRVE3c3lISmxZIn0.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9lM2ZlZmRiZS1mN2U5LTQwMWItYTUxYS0zNTVlMDFiMDVhODkvIiwiaWF0IjoxNTM5NDk5NzMxLCJuYmYiOjE1Mzk0OTk3MzEsImV4cCI6MTUzOTUwMzYzMSwiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IjQyUmdZTERtNUx2SFVYdmdwOEVkNjhib1NzTld2MzhOY3dPdUxBMjh2TXpnRmwvM3dRb0EiLCJhbXIiOlsicHdkIl0sImFwcF9kaXNwbGF5bmFtZSI6IlRpZ2VyRXZlbnQiLCJhcHBpZCI6IjQ0N2Q3NzQ2LTY2OWYtNGE5My1hYTAyLTZlNzcwOWYyMjcyMCIsImFwcGlkYWNyIjoiMCIsImZhbWlseV9uYW1lIjoiS2lldyIsImdpdmVuX25hbWUiOiJSb2dlciIsImlwYWRkciI6IjEyOC4yMDYuMjUxLjI3IiwibmFtZSI6IktpZXcsIFJvZ2VyIChNVS1TdHVkZW50KSIsIm9pZCI6IjI2NzE0ZTkwLTc3NWYtNGQyYi04ZGJkLThhMWM4YjMxM2UwNSIsInBsYXRmIjoiMiIsInB1aWQiOiIxMDAzQkZGRDk3NDJFOEY4Iiwic2NwIjoiQ2FsZW5kYXJzLlJlYWQgQ2FsZW5kYXJzLlJlYWQuU2hhcmVkIENhbGVuZGFycy5SZWFkV3JpdGUgQ2FsZW5kYXJzLlJlYWRXcml0ZS5TaGFyZWQgQ29udGFjdHMuUmVhZCBNYWlsLlJlYWQgb3BlbmlkIHByb2ZpbGUgVXNlci5SZWFkIGVtYWlsIiwic2lnbmluX3N0YXRlIjpbImttc2kiXSwic3ViIjoiZ0l6T2dRblhMVEI5NktJeUR0aUhnYkFMdGlBNlZWaHdfYnRXR19QRnM4USIsInRpZCI6ImUzZmVmZGJlLWY3ZTktNDAxYi1hNTFhLTM1NWUwMWIwNWE4OSIsInVuaXF1ZV9uYW1lIjoicmtyeThAbWFpbC5taXNzb3VyaS5lZHUiLCJ1cG4iOiJya3J5OEBtYWlsLm1pc3NvdXJpLmVkdSIsInV0aSI6IkpucWdRSWNtRTB5WHU3RDZkQTVNQUEiLCJ2ZXIiOiIxLjAiLCJ4bXNfc3QiOnsic3ViIjoiRy16Z2lvb0U3a2M0N29GV0treFBVYzMxNUtJYS1EM1l2ellWSDlVNzFLZyJ9LCJ4bXNfdGNkdCI6MTM2Njc2NDQ4Nn0.SlLKKuU7aiF60oRttovpZqoTifFT_BURdNwfpCvtZe2d9iJSB_dlRZX7iA5wlZII2D3NOmBmX8xiVc6lKrqrOt59aieznd63r3wH0TJZvZQ6ep3E7URSplPbmOV1pYEVp7kP576gcXOkUoNoHjXmpM1CaW5z39esXy9_8tz-mVhd5ZwMSbw74maBJnn0XKPCVb5qofb203AZsp_OAOQTX9Pr6LbjQSrQp6RnlyJQyBjB06sD4v_7fA8aQCeAXyl0GY7RG56JxxZXfts0MRLhWKGDxKC_eCgFHdFHhx0frkeFi_GXtIh3wb7zPOuLKoMwprUBqlrjwWydUG21n2xIjg", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        
        /*[
         "subject": self.event.title,
         "start": [
         "dateTime": self.event.eventTime.getNetworkDescription(),
         "timeZone": "UTC"
         ],
         "end": [
         "dateTime": Date(timeInterval: 60 * 60, since: self.event.eventTime).getNetworkDescription(),
         "timeZone": "UTC"
         ],
         "location": [
         "displayName": self.event.location
         ],
         "body": [
         "content": self.event.desc
         ]
         ]*/
        
        let startTimeStr = self.event.eventTime.getNetworkDescription()
        let endTimeStr = Date(timeInterval: 60 * 60, since: self.event.eventTime).getNetworkDescription()
        var jsonBody: [String: Any] =
            [
                "subject": self.event.title,
                "start":[
                    "dateTime": self.event.eventTime.getNetworkDescription(),
                    "timeZone": "UTC"
                ],
                "end":[
                    "dateTime": Date(timeInterval: 60 * 60, since: self.event.eventTime).getNetworkDescription(),
                    "timeZone": "UTC"
                ],
                "location":[
                    "displayName": self.event.location
                ],
                "body":[
                    "content": self.event.desc
                ]
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = String(data: jsonData, encoding: .utf8)
        print(jsonString)
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            print(data)
            print(response)
        })
        task.resume()
    }
    
}

