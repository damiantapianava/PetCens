//
//  File.swift
//  PetCens
//
//  Created by Infraestructura on 21/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import Foundation

public protocol SOAPManagerDelegate: NSObjectProtocol
{
    func WMRegresaMunicipiosResponse(responseArray:NSArray)
}

public class SOAPManager: NSObject, NSURLConnectionDelegate, NSXMLParserDelegate
{
    static let instance:SOAPManager = SOAPManager()

    var conexion:NSURLConnection?
    var datosrecibidos: NSMutableData?
    var delegate: SOAPManagerDelegate?
    
    let NODO_RESULTADOS = "NewDataSet"
    let NODO_MUNICIPIO  = "ReturnDataSet"
    
    private var municipios:NSMutableArray?
    private var municipio:NSMutableDictionary?
    private var guardaResultados:Bool = false
    private var esMunicipio:Bool = false
    private var nombreCampo : String?
    
    public func consultaMunicipios(estado:String)
    {
        let soapMun1 = "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><WMRegresaMunicipios xmlns=\"http://tempuri.org/\"><c_estado>"
        
        let soapMun2 = "</c_estado></WMRegresaMunicipios></soap:Body></soap:Envelope>"
        
        
        
        let soapCol1 = "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><WMRegresaColonias xmlns=\"http://tempuri.org/\"><c_estado>"
        
        let soapCol2 = "</c_estado><c_mnpio>"
        
        let soapCol3 = "</c_mnpio></WMRegresaColonias></soap:Body></soap:Envelope>"
        
        let soapMessage = soapMun1 + estado + soapMun2
        
        if ConnectionManager.hayConexion()
        {
            if !ConnectionManager.esConexionWiFi()
            {
                // Pedir confirmación para descargar
            }
            
            let urlString = "http://edg3.mx/webservicessepomex/sepomex.asmx"
            
            let laURL = NSURL(string: urlString)!
            
            let elRequest = NSMutableURLRequest(URL: laURL)
            
            elRequest.HTTPMethod = "POST"
            
            elRequest.setValue("text/xml", forHTTPHeaderField: "Content-Type")
            
            let longitudMensaje = "\(soapMessage.characters.count)"
            
            elRequest.setValue(longitudMensaje, forHTTPHeaderField: "Content-Length")
            
            elRequest.setValue("http://tempuri.org/WMRegresaMunicipios", forHTTPHeaderField: "SOAPAction")
            
            elRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
            
            self.datosrecibidos = NSMutableData(capacity: 0)
            
            self.conexion = NSURLConnection(request: elRequest, delegate: self)
            
            if self.conexion == nil
            {
                self.datosrecibidos = nil
                self.conexion = nil
                
                print("No se puiede acceder al WS Estados")
            }
            
        } else {
            
            print("No hay conexión a internet")
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
        let responseSTR = NSString(data: self.datosrecibidos!, encoding:NSUTF8StringEncoding)
        
        print(responseSTR)
        
        let xmlParser = NSXMLParser(data: self.datosrecibidos!)
        
        xmlParser.delegate = self
        xmlParser.shouldResolveExternalEntities = true
        xmlParser.parse()
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        if(elementName == NODO_RESULTADOS)
        {
            self.guardaResultados = true
        }
        
        if(guardaResultados && elementName == NODO_MUNICIPIO)
        {
            self.municipio = NSMutableDictionary()
            
            self.esMunicipio = true
        }
        
        nombreCampo = elementName
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if guardaResultados
        {
            municipio!.setObject(string, forKey: nombreCampo!)
        }
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == NODO_MUNICIPIO
        {
            if municipios == nil
            {
                municipios = NSMutableArray()
            }
            
            municipios!.addObject(municipio!)
            
            esMunicipio = false
        }
    }
    
    public func parserDidEndDocument(parser: NSXMLParser)
    {
        if municipios != nil
        {
            print("resultado, parseado: \(municipios!.description)")
            
            let ns = NSNotification(name: "WMRegresaMunicipios", object: nil, userInfo: ["municipiosResponse":self.municipios!])
            
            NSNotificationCenter.defaultCenter().postNotification(ns)
            
            if delegate != nil
            {
                if delegate!.respondsToSelector(Selector("WMRegresaMunicipiosResponse"))
                {
                    delegate!.WMRegresaMunicipiosResponse(self.municipios!)
                }
            }
        }
    }
}




