//
//  ViewController.swift
//  AlamofireUIManager
//
//  Created by Alex Corlatti on 06/03/2016.
//  Copyright (c) 2016 Alex Corlatti. All rights reserved.
//

import UIKit
import AlamofireUIManager
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    let netManager = AlamofireUIManager.sharedInstance

    override func viewDidLoad() {

        super.viewDidLoad()

        netManager.delegate = self

<<<<<<< HEAD
        let URL = Foundation.URL(string: "http://jsonplaceholder.typicode.com/posts/1")!
        var mutableURLRequest = URLRequest(url: URL)
        mutableURLRequest.httpMethod = HTTPMethod.get.rawValue

        netManager.request(mutableURLRequest, showError: false, completionHandler: { json in
=======
        netManager.request(request: "http://jsonplaceholder.typicode.com/posts/1", showError: false, completionHandler: { json in
>>>>>>> 2c5689334276e2619e2c80178779a88eb5416710

            print(json)

            self.resultLabel.text = json["body"].stringValue

            }, errorHandler: { error in

                print("Error: \(error)")
                
                self.manageAlertError(error, completition: { _ in
                
                
                })


        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: AlamofireUIManagerDelegate {

    func createSpinner() -> UIView {

        let act  = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        act.center = self.view.center
        act.activityIndicatorViewStyle = .gray

        self.view.addSubview(act)

        act.startAnimating()

        return act

    }

    func closeSpinner(_ spinner: UIView?) {

        guard spinner != nil else { return }

        if let act = spinner as? UIActivityIndicatorView {

            act.stopAnimating()
            act.removeFromSuperview()

        }

    }

    func checkJson(_ json: JSON, showError: Bool, completionHandler: AFRequestCompletionHandler, errorHandler: AFRequestErrorHandler) {

        if let errorStr = json["error"]["message"].string { // Probably authorization required

            let error = NSError(domain: "json", code: 401, userInfo: ["info": errorStr])

            errorHandler(error)

        } else { completionHandler(json) }

    }

<<<<<<< HEAD
    func manageAlertError(_ error: NSError?, completition: @escaping AFRequestCompletionVoid) {
=======
    func manageAlertError(error: NSError?, completition: @escaping AFRequestCompletionVoid) {
>>>>>>> 2c5689334276e2619e2c80178779a88eb5416710

        let alertController = UIAlertController(title: "Error", message: error?.description, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in

            self.netManager.closeAlert()
            completition()

        })

        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)

    }

}
