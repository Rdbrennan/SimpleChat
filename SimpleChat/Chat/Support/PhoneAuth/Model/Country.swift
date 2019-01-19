//
//  Country.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import Foundation

class Country: NSObject {
    
    var countries = [[String : String]]()
    
    override init() {
        super.init()
        
        fetchCountries()
    }
    
    func fetchCountries () {
        let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
        countries = plist as! [[String : String]]
    }
}
