//
//  mapsPresenter.swift
//  mapsExample
//
//  Created by Vic Yoshioka on 12/08/23.
//

import Foundation
import Alamofire
import SWXMLHash
import MapKit
class mapsPresenter {
    
    //    presenter que realiza las peticiones de web service

    var arrayPaises:[Pais] = []
    var arrayEstados:[Estados] = []
    
    func paises() {
        let soapMessage = """
           <?xml version="1.0" encoding="utf-8"?>
           <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
             <soap:Body>
               <GetPaises xmlns="http://tempuri.org/" />
             </soap:Body>
           </soap:Envelope>
           """
        
        let headers: HTTPHeaders = [
            "Host": "servicesoap.azurewebsites.net",
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": "http://tempuri.org/GetPaises"
        ]
        
        if let soapData = soapMessage.data(using: .utf8) {
            AF.upload(soapData, to: "https://servicesoap.azurewebsites.net/ws/Paises.asmx", method: .post, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):
                    print("Response: \(value)")
                    self.parsePais(response: value )
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func parsePais(response: String) {
        let xml = XMLHash.parse(response)
        
        let namespaces = ["soap": "http://schemas.xmlsoap.org/soap/envelope/",
                          "tempuri": "http://tempuri.org/"]
        
        var paisesArray: [[String: String]] = []
        
        let body = xml["soap:Envelope"]["soap:Body"]
        
        for element in body.children {
            for paisElem in element["GetPaisesResult"]["Paises"]["Pais"].all {
                let idPais = paisElem["idPais"].element?.text ?? ""
                let nombrePais = paisElem["NombrePais"].element?.text ?? ""
                
                let paisDict = ["idPais": idPais, "nombrePais": nombrePais]
                paisesArray.append(paisDict)
                self.arrayPaises.append(Pais(idPais: idPais, nombrePais: nombrePais))
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPaisNotif"), object: nil)
                
            }
        }
        
        //        print("Paises: \(paisesArray)")
        
    }
    
    func estadosByPais(idEstado: String) {
        let soapMessage = """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <GetEstadosbyPais xmlns="http://tempuri.org/">
              <idEstado>\(idEstado)</idEstado>
            </GetEstadosbyPais>
          </soap:Body>
        </soap:Envelope>
        """
        
        let headers: HTTPHeaders = [
            "Host": "servicesoap.azurewebsites.net",
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": "http://tempuri.org/GetEstadosbyPais"
        ]
        
        AF.upload(soapMessage.data(using: .utf8)!, to: "https://servicesoap.azurewebsites.net/ws/Paises.asmx", method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(let value):
                self.paseEstadoByPais(response: value)
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func paseEstadoByPais(response: String) {
        let xml = XMLHash.parse(response)
        
        var estadosArray: [[String: String]] = []
        
        let body = xml["soap:Envelope"]["soap:Body"]
        
        for element in body.children {
            for estadoElem in element["GetEstadosbyPaisResult"]["Estados"]["Estado"].all {
                let idEstado = estadoElem["idEstado"].element?.text ?? ""
                let estadoNombre = estadoElem["EstadoNombre"].element?.text ?? ""
                let coordenadas = estadoElem["Coordenadas"].element?.text ?? ""
                let idPais = estadoElem["idPais"].element?.text ?? ""
                
                let estadoDict = ["idEstado": idEstado,
                                  "estadoNombre": estadoNombre,
                                  "coordenadas": coordenadas,
                                  "idPais": idPais]
                estadosArray.append(estadoDict)
                self.arrayEstados.append(Estados(idEstado: idEstado, estadoNombre: estadoNombre, coordenadas: coordenadas, idPais: idPais))
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newEstadoNotif"), object: nil)
            }
        }
        
        print("Estados: \(estadosArray)")
    }
    
    func obtenerPaisPorIdEstado(_ idEstado: String) -> Pais? {
        
        if let estado = arrayEstados.first(where: { $0.idEstado == idEstado }) {
            return arrayPaises.first(where: { $0.idPais == estado.idPais })
        }
        
        return nil
    }
    
}

