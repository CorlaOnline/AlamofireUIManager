//
//  ViewController.swift
//  AlamofireUIManager
//
//  Created by Alex Corlatti on 06/03/2016.
//  Copyright (c) 2016 Alex Corlatti. All rights reserved.
//

import UIKit
import AlamofireUIManager

class ViewController: UIViewController {
    
    let ACManager = ACAlamofireManager.sharedInstance

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ACManager.delegate = self
        
        ACManager.re
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: ACAlamofireManagerDelegate {
    
    func createSpinner() -> UIView {
        
        let act  = UIActivityIndicatorView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        act.center = self.view.center
        act.activityIndicatorViewStyle = .Gray
        
        self.view.addSubview(act)
        
        act.startAnimating()
        
        return act
        
    }
    
    func closeSpinner(spinner: UIView?) {
        
        guard spinner != nil else { return }
        
        if let act = spinner as? UIActivityIndicatorView {
            
            act.stopAnimating()
            act.removeFromSuperview()
            
        }
        
    }
    
    func checkJson(json: JSON, showError: Bool, completionHandler: ACRequestCompletionHandler, errorHandler: ACRequestErrorHandler) {
        
        if let errorStr = json["error"]["message"].string { // Probably authorization required
            
            let error = NSError(domain: "json", code: 400, userInfo: ["info": errorStr])
            
            errorHandler(error)
            
        } else { completionHandler(json) }
        
    }
    
    func manageAlertError(error: NSError?, completition: ACRequestCompletionVoid) {
        
        let alertController = UIAlertController(title: "Hey AppCoda", message: "What do you want to do?", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in
            
            self.ACManager.closeAlert()
            completition()
            
        })
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
