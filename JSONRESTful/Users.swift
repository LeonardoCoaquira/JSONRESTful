//
//  Users.swift
//  JSONRESTful
//
//  Created by Leonardo Coaquira on 28/11/23.
//

import Foundation

struct Users:Decodable {
    let id:Int
    let nombre:String
    let clave:String
    let email:String
}
