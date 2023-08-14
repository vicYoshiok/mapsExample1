//
//  modelPaises.swift
//  mapsExample
//
//  Created by Vic Yoshioka on 12/08/23.
//
import Foundation
    
    struct Pais {
        var idPais: String
        var nombrePais: String
    }


struct Estados{
    
    var idEstado: String
    var estadoNombre: String
    var coordenadas: String
    var idPais: String
    
}

    

/*
 tengo el array paises con objetos pais  que tienen la siguiente estructura     struct Pais {
         var idPais: String
         var nombrePais: String
     }
 
 y el array estados con objetos estado que tienen la siguiente estructura
 struct Estados{
     
     var idEstado: String
     var estadoNombre: String
     var coordenadas: String
     var idPais: String
     
 }
 
 necesito una función que reciba del arreglo de estados el idPais y me devuelva del array paises el pais correspondiente
 
 
 **/
