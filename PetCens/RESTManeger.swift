//
//  RESTManeger.swift
//  PetCens
//
//  Created by Infraestructura on 21/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit
import Foundation

public class RESTManager: NSObject, NSURLConnectionDelegate
{
    static let instance:RESTManager = RESTManager()
    
    var conexion:NSURLConnection?
    var datosrecibidos: NSMutableData?
    
    var vista : UIViewController?
    
    func consultaEstados()
    {
        if ConnectionManager.hayConexion()
        {
            if !ConnectionManager.esConexionWiFi()
            {
                // Pedir confirmación para descargar
            }
            
            let urlString = "http://edg3.mx/webservicessepomex/WMRegresaEstados.php"
            
            let laURL = NSURL(string: urlString)!
            
            let elRequest = NSURLRequest(URL: laURL)
            
            self.datosrecibidos = NSMutableData(capacity: 0)
            
            self.conexion = NSURLConnection(request: elRequest, delegate: self)
            
            if self.conexion == nil
            {
                self.datosrecibidos = nil
                self.conexion = nil
                
                print("No se puiede acceder al WS Estados")
            }
            
        } else {
            
            print("Nohay conexión a internet")
        }
    }
    
    public func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        self.datosrecibidos = nil
        self.conexion = nil
        
        print("No se puiede acceder al WS Estados")
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
    {
        self.datosrecibidos?.length = 0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData)
    {
        self.datosrecibidos?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        do
        {
            let arregloRecibido = try (NSJSONSerialization.JSONObjectWithData(self.datosrecibidos!, options: .AllowFragments) as? NSArray)
            
/* TODO actualizar UI con un delegate
            self.estados = arregloRecibido
            
            self.pickerEstados.reloadAllComponents()
 */
            
        } catch {
            
        }
    }
}
