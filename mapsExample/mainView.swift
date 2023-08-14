//
//  ViewController.swift
//  mapsExample
//
//  Created by Vic Yoshioka on 12/08/23.
//

import UIKit
import Foundation
import MapKit
class mainView: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var paisLabel: UILabel!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var datosCiudadLabel: UILabel!
    @IBOutlet weak var tableViewPaisesCiudades: UITableView!
    @IBOutlet weak var tableViewEstados: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var mapsE = mapsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPaises), name: NSNotification.Name(rawValue: "newPaisNotif"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshEstados), name: NSNotification.Name(rawValue: "newEstadoNotif"), object: nil)
        
        self.mapsE.paises()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableViewPaisesCiudades.dataSource = self
        self.tableViewPaisesCiudades.delegate = self
        self.tableViewPaisesCiudades.reloadData()
        self.tableViewEstados.dataSource = self
        self.tableViewEstados.delegate = self
        self.tableViewEstados.reloadData()
    }
    
    @objc func refreshPaises() {
        
        self.tableViewPaisesCiudades.reloadData()
    }
    
    @objc func refreshEstados() {
        self.tableViewEstados.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewPaisesCiudades{
            return mapsE.arrayPaises.count
        }else{
            return mapsE.arrayEstados.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableViewPaisesCiudades{
            
            let cell = tableViewPaisesCiudades.dequeueReusableCell(withIdentifier: "paisCell") as! paisCell
            let arrayP = mapsE.arrayPaises[indexPath.row]
            cell.odPais.text = arrayP.idPais
            cell.nombrePais.text = arrayP.nombrePais
            
            return cell
            
        }else{
            let cell = tableViewEstados.dequeueReusableCell(withIdentifier: "estadoCell") as! estadosCell
            let arrayE = mapsE.arrayEstados[indexPath.row]
            cell.idEstadoLabel.text = arrayE.idEstado
            cell.nombreEstadoLabel.text = arrayE.estadoNombre
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableViewPaisesCiudades{
            
            let arrayP = self.mapsE.arrayPaises[indexPath.row]
            print("id pais a enviar")
            print(mapsE.arrayPaises[indexPath.row])
            self.paisLabel.text = arrayP.nombrePais
            
            if !self.mapsE.arrayEstados.isEmpty{
                
                self.mapsE.arrayEstados.removeAll()
            }
            
            self.tableViewEstados.reloadData()
            self.mapsE.estadosByPais(idEstado: arrayP.idPais)
            
        }else{
            
            let arrayE = self.mapsE.arrayEstados[indexPath.row]
            self.ciudadLabel.text = arrayE.estadoNombre
            self.datosCiudadLabel.text = arrayE.coordenadas
            
            let coordinatesComponents = arrayE.coordenadas.split(separator: ",")
            if coordinatesComponents.count == 2,
               let latitude = Double(coordinatesComponents[0].trimmingCharacters(in: .whitespaces)),
               let longitude = Double(coordinatesComponents[1].trimmingCharacters(in: .whitespaces)) {
                
                let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                let region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3))
                self.mapView.setRegion(region, animated: true)
                mapView.removeAnnotations(mapView.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationCoordinate
                self.mapView.addAnnotation(annotation)
                
                //
                
            }
            
        }
        
        
    }
    
}
