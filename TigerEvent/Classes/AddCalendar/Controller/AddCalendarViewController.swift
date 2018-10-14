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
    
    
    @IBAction func outlookBtnTapped(_ sender: Any) {
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
                }
            }
        }
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
    
}

