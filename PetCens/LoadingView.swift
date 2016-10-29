//
//  LoadingView.swift
//  PetCens
//
//  Created by Infraestructura on 29/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit

class LoadingView: UIView
{

    static func loadingInView(unView:UIView, mensaje:NSString) -> LoadingView
    {
        let loading = LoadingView(frame: unView.bounds)
        
        loading.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        
        unView.addSubview(loading)
        
        let label = UILabel(frame: CGRectMake(0,0,300, 50))
        
        label.text = mensaje as String
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Right
        
        loading.addSubview(label)
        
        label.center = loading.center
        
        let actInd = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        
        actInd.center = loading.center
        actInd.frame = CGRectOffset(actInd.frame, 0.0, -55.0)
        
        loading.addSubview(actInd)
        
        actInd.startAnimating()
        
        return loading
        
    }
    
    func removeLoading()
    {
        self.removeFromSuperview()
    }

}
