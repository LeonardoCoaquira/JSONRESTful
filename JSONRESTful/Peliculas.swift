//
//  Peliculas.swift
//  JSONRESTful
//
//  Created by Leonardo Coaquira on 28/11/23.
//

import Foundation

struct Peliculas:Decodable {
    let usuarioId:Int
    let id:Int
    let nombre:String
    let genero:String
    let duracion:String
}
