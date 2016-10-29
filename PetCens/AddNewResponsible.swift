//
//  AddNewResponsible.swift
//  PetCens
//
//  Created by Infraestructura on 15/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit
import Foundation

class AddNewResponsible: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtFechaNacimiento: UITextField!
    @IBOutlet weak var txtCalleYNo: UITextField!
    @IBOutlet weak var txtEstado: UITextField!
    @IBOutlet weak var txtColonia: UITextField!
    @IBOutlet weak var txtMunicipio: UITextField!
    @IBOutlet weak var pickerFN: UIDatePicker!
    
    @IBOutlet weak var pickerEstados: UIPickerView!
    @IBOutlet weak var pickerMunicipios: UIPickerView!
    @IBOutlet weak var pickerColonias: UIPickerView!
    
    var estados:NSArray?
    var municipios:NSArray?
    var colonias:NSArray?
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.txtNombre.delegate = self
        self.txtApellidos.delegate = self
        self.txtFechaNacimiento.delegate = self
        self.txtCalleYNo.delegate = self
        self.txtEstado.delegate = self
        self.txtColonia.delegate = self
        self.txtMunicipio.delegate = self
        
        self.pickerFN.hidden = true
        
        self.pickerEstados.delegate   = self
        self.pickerEstados.dataSource = self
        
        self.estados    = NSArray()
        self.municipios = NSArray()
        self.colonias   = NSArray()
        
        RESTManager.instance.consultaEstados()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        
        self.ocultaPickers()
    }
    
    @IBAction func pickerDateChange(sender: AnyObject)
    {
        let format = NSDateFormatter()
        
        format.dateFormat = "dd-MM-yyyy"
        
        let fechaString = format.stringFromDate(self.pickerFN.date)
        
        self.txtFechaNacimiento.text = fechaString
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if (textField.isEqual(self.txtNombre) || textField.isEqual(self.txtApellidos) || textField.isEqual(self.txtCalleYNo))
        {
            self.ocultaPickers()
            
            return true
            
        } else {
            
            self.txtNombre.resignFirstResponder()
            self.txtApellidos.resignFirstResponder()
            self.txtCalleYNo.resignFirstResponder()
            
            if(textField.isEqual(self.txtFechaNacimiento))
            {
                self.subeBajaPicker(self.pickerFN, subeOBaja: true)
            }
            
            return false
        }
    }
    
    func ocultaPickers()
    {
        var unFrame:CGRect
        
        unFrame = self.pickerFN.frame
        
        self.pickerFN.frame = CGRectMake(unFrame.origin.x, CGRectGetMaxY(self.view.frame), unFrame.size.width, unFrame.size.height)
        
        self.pickerFN.hidden = false
    }
    
    func subeBajaPicker(elPicker:UIView, subeOBaja: Bool)
    {
        var elFrame:CGRect = elPicker.frame
        
        UIView.animateWithDuration(0.5)
        {
            if subeOBaja
            {
                elFrame.origin.y = CGRectGetMaxY(self.txtFechaNacimiento.frame)
                
            } else {
                
                elFrame.origin.y = CGRectGetMaxY(self.view.frame)
            }
            
            elPicker.frame = elFrame
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView.isEqual(pickerEstados))
        {
            return estados!.count
        }
        
        if(pickerView.isEqual(pickerMunicipios))
        {
            return municipios!.count
        }
        
        if(pickerView.isEqual(pickerColonias))
        {
            return colonias!.count
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView.isEqual(pickerEstados))
        {
            return (estados![row].valueForKey("nombreEstado") as? String)
        }
        
        if(pickerView.isEqual(pickerMunicipios))
        {
            return (municipios![row].valueForKey("nombreEstado") as? String)
        }
        
        if(pickerView.isEqual(pickerColonias))
        {
            return (colonias![row].valueForKey("nombreEstado") as? String)
        }
        
        return nil
    }
    
    //Cuando se selecciona el picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView.isEqual(pickerEstados))
        {
            self.txtEstado.text = (estados![row].valueForKey("nombreEstado") as! String)
            
            let codigoestado = (estados![row].valueForKey("c_estado") as? String)
            
            SOAPManager.instance.consultaMunicipios(codigoestado!)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddNewResponsible.municipiosResponse(_ :)), name: "WMRegresaMunicipios", object: nil)
            
            LoadingView.loadingInView(self.view, mensaje: "Buscando municipios")
        }
    }
    
    func municipiosResponse(notif: NSNotification)
    {
        self.municipios = (notif.userInfo!["municipiosResponse"] as! NSArray)
        
        self.pickerMunicipios.reloadAllComponents()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "WMRegresaMunicipios", object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
