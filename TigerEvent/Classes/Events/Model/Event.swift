//
//  Event.swift
//  TigerEvent
//
//  Created by SiyangLiu on 2018/10/12.
//  Copyright © 2018 SiyangLiu. All rights reserved.
//

import UIKit

class Event: NSObject {
    
//    enum Department
//    {
//        case ArtAndCultureJournalism,
//        BusinessAndEconomicsJournalism,
//        DataJournalism,
//        InternationalJournalism,
//        SportsJournalism,
//        CivilAndEnvironmentalEngineering,
//        ElectricalEngineeringAndCompouterScience,
//        InformationTechnology,
//        IndustrialAndManufacturingSystemEngineering,
//        MechanicalAndAerospceEngineering
//    }
    
    var eventId: String!
    var title: String!
    var desc: String!
    var department: String!
    var eventTime: Date!
    var imageUrl: String!
    var submitTime: Date!
    var location: String!

    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["eventId": "id",
                "desc": "description",
                "imageUrl": "image",
                "submitTime": "submissionTime"
        ]
    }
    
    override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if property.name == "eventTime" || property.name == "submitTime" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.timeZone = TimeZone(secondsFromGMT: -6)
            let date = formatter.date(from: oldValue as! String)
            return date
        }
        return oldValue;
    }
    
    //public func getDepartmentDesc() {
      //  let department = Department
//        return
    //}
}

extension Date {
    public func getDescription() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: -6)
        return formatter.string(from: self)
    }
    
    public func getNetworkDescription() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: -6)
        return formatter.string(from: self)
    }
}
