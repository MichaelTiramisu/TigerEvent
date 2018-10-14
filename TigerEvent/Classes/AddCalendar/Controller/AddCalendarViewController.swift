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
            // Logout
            service.logout()
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
                    
//                    service.makeApiCall(api: "/v1.0/me/events", params: <#T##[String : String]?#>, callback: <#T##(JSON?) -> Void#>)
                    var request = URLRequest(url: URL(string: "https://graph.microsoft.com/v1.0/me/events")!)
                    request.addValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
                    request.addValue("application/json", forHTTPHeaderField: "Content-type")
                    request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJub25jZSI6IkFRQUJBQUFBQUFDNXVuYTBFVUZnVElGOEVsYXh0V2pUc1o4NXFCc0dacDRpUWREMmVmb0xTS0wtaVFMR3JFMjdMZkJ0RFJQb2lzOXR6MFloWVF1QkFUNWw3cjMwa0pNVC1ON0pSZDdHWmhxWE9HQXJSN0hhN1NBQSIsImFsZyI6IlJTMjU2IiwieDV0IjoiaTZsR2szRlp6eFJjVWIyQzNuRVE3c3lISmxZIiwia2lkIjoiaTZsR2szRlp6eFJjVWIyQzNuRVE3c3lISmxZIn0.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9lM2ZlZmRiZS1mN2U5LTQwMWItYTUxYS0zNTVlMDFiMDVhODkvIiwiaWF0IjoxNTM5NDk0MTEzLCJuYmYiOjE1Mzk0OTQxMTMsImV4cCI6MTUzOTQ5ODAxMywiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFTUUEyLzhKQUFBQU5YUG1Ydk56UXEwcDg2bmxVb1RkSGI3azdHdmFDYWZzZ2FjcFdVK0Nzd2s9IiwiYW1yIjpbInB3ZCJdLCJhcHBfZGlzcGxheW5hbWUiOiJHcmFwaCBleHBsb3JlciIsImFwcGlkIjoiZGU4YmM4YjUtZDlmOS00OGIxLWE4YWQtYjc0OGRhNzI1MDY0IiwiYXBwaWRhY3IiOiIwIiwiZmFtaWx5X25hbWUiOiJLaWV3IiwiZ2l2ZW5fbmFtZSI6IlJvZ2VyIiwiaXBhZGRyIjoiMTI4LjIwNi4yNTEuMjciLCJuYW1lIjoiS2lldywgUm9nZXIgKE1VLVN0dWRlbnQpIiwib2lkIjoiMjY3MTRlOTAtNzc1Zi00ZDJiLThkYmQtOGExYzhiMzEzZTA1IiwicGxhdGYiOiI1IiwicHVpZCI6IjEwMDNCRkZEOTc0MkU4RjgiLCJzY3AiOiJDYWxlbmRhcnMuUmVhZFdyaXRlIENvbnRhY3RzLlJlYWRXcml0ZSBGaWxlcy5SZWFkV3JpdGUuQWxsIE1haWwuUmVhZFdyaXRlIE5vdGVzLlJlYWRXcml0ZS5BbGwgb3BlbmlkIFBlb3BsZS5SZWFkIHByb2ZpbGUgU2l0ZXMuUmVhZFdyaXRlLkFsbCBUYXNrcy5SZWFkV3JpdGUgVXNlci5SZWFkQmFzaWMuQWxsIFVzZXIuUmVhZFdyaXRlIGVtYWlsIiwic3ViIjoiZ0l6T2dRblhMVEI5NktJeUR0aUhnYkFMdGlBNlZWaHdfYnRXR19QRnM4USIsInRpZCI6ImUzZmVmZGJlLWY3ZTktNDAxYi1hNTFhLTM1NWUwMWIwNWE4OSIsInVuaXF1ZV9uYW1lIjoicmtyeThAbWFpbC5taXNzb3VyaS5lZHUiLCJ1cG4iOiJya3J5OEBtYWlsLm1pc3NvdXJpLmVkdSIsInV0aSI6IlFFcnNXZmVrVFVLbkhWQ3d6T2hKQUEiLCJ2ZXIiOiIxLjAiLCJ4bXNfc3QiOnsic3ViIjoidG9JdXlVaEFRZ3lReXFrWWFEX01RWXE1OHhLZlUyc2xUNi1tMC15cHo1SSJ9LCJ4bXNfdGNkdCI6MTM2Njc2NDQ4Nn0.fopJTUY7cFNtRanrLUwjZutqiyP58yDzJ7y30M2ex24B1pBkQbNDMzIbIkmsJmTfcgHTycsyt3rci6dypMUqkYIRQk6K1ep_fP1UjfQItkqCdgtM0Ld8bq-eG_5F2_fAJ77Ia_d9DNPI2QBpViLOzHhU6XjFnZmvJQTS9T1qstO59Sb-sZ8d4sBMpjq4-zSicSRl_lZFK8dwPpPEWGoI8sHApVqXteU2KBKX0Jz73BkWiZn6d9s0S36xDZ4YLMMLQ2T1YYLmIr6oB2UItQ7yDxgb6aiYBpxio_bnE7Zoj_gh7qcp-0Onc28ZAQ2UZYMa6f2kd0KA5KAhpV9G1nDgvw", forHTTPHeaderField: "Authorization")
                    
                    request.httpMethod = "POST"

                    var jsonBody: [String: Any] = [
                        "subject": self.event.title,
                        "start": [
                            "dateTime": self.event.eventTime.getNetworkDescription(),
                            "timeZone": "CDT"
                        ],
                        "end": [
                            "dateTime": Date(timeInterval: 60 * 60, since: self.event.eventTime).getNetworkDescription(),
                            "timeZone": "CDT"
                        ],
                        "location": [
                            "displayName": self.event.location
                        ],
                        "body": [
                            "content": self.event.desc
                        ]
                    ]
                    let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody, options: JSONSerialization.WritingOptions.prettyPrinted)
//                    let jsonString = String(data: jsonData, encoding: .utf8)
//                    print(jsonString)
                    request.httpBody = jsonData
                    let session = URLSession.shared
                    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                        print(data)
                        print(response)
                    })
                    task.resume()
                    

                }
            }
        }
    }
    
}

