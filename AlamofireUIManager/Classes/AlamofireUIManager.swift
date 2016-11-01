//
//  AlamofireUIManager.swift
//
//  Created by Alex Corlatti on 03/06/16.
//  Copyright © 2016 CorlaOnline. All rights reserved.
//

import Alamofire
import SwiftyJSON

public typealias AFRequestCompletionHandler = (JSON) -> Void
public typealias AFRequestErrorHandler = (NSError?) -> Void
public typealias AFRequestCompletionVoid = (Void) -> Void

public protocol AlamofireUIManagerDelegate {

    func createSpinner() -> UIView
    func closeSpinner(_ spinner: UIView?)

    func checkJson(_ json: JSON, showError: Bool, completionHandler: AFRequestCompletionHandler, errorHandler: AFRequestErrorHandler)

<<<<<<< HEAD
    func manageAlertError(_ error: NSError?, completition: @escaping AFRequestCompletionVoid)
=======
    func manageAlertError(error: NSError?, completition: @escaping AFRequestCompletionVoid)
>>>>>>> 2c5689334276e2619e2c80178779a88eb5416710

}

open class AlamofireUIManager {

<<<<<<< HEAD
    let AFManager = Alamofire.SessionManager.default

    open static let sharedInstance = AlamofireUIManager()
=======
    let AFManager = Alamofire.SessionManager()
    
    public static let sharedInstance = AlamofireUIManager()
>>>>>>> 2c5689334276e2619e2c80178779a88eb5416710

    open var delegate: AlamofireUIManagerDelegate?

    var activeConnection = 0
    var progressAlert: UIView?
    var anAlertIsShowed: Bool = false

    init() {}

    // MARK: - Connection Utility

    func addConnection(_ showSpinner: Bool, spinnerTitle: String, spinnerSubTitle: String) {

        activeConnection += 1

        if activeConnection == 1 {

            #if os(iOS)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            #endif

            if showSpinner {

                progressAlert = delegate?.createSpinner()

            }

        }

    }

    func removeConnection() {

        activeConnection -= 1

        if activeConnection == 0 {

            #if os(iOS)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            #endif

            if (progressAlert != nil) {

                delegate?.closeSpinner(spinner: progressAlert)

            }

        }

    }

<<<<<<< HEAD
    open func request(_ request: URLRequestConvertible, showSpinner: Bool = true, showError: Bool = true, spinnerTitle: String = "", spinnerSubTitle: String = "", completionHandler: @escaping (AFRequestCompletionHandler), errorHandler: @escaping (AFRequestErrorHandler) = { _ in }) {

        addConnection(showSpinner, spinnerTitle: spinnerTitle, spinnerSubTitle: spinnerSubTitle)
=======
    public func request(request: String, method: Alamofire.HTTPMethod = .get ,showSpinner: Bool = true, showError: Bool = true, spinnerTitle: String = "", spinnerSubTitle: String = "", completionHandler: @escaping (AFRequestCompletionHandler), errorHandler: @escaping (AFRequestErrorHandler) = { _ in }) {
>>>>>>> 2c5689334276e2619e2c80178779a88eb5416710

        addConnection(showSpinner: showSpinner, spinnerTitle: spinnerTitle, spinnerSubTitle: spinnerSubTitle)
        
        AFManager
            .request(request, method: method)
            .responseJSON() { response in

                self.removeConnection()

                switch response.result {

                case .success:

                    guard let value = response.result.value else {

                        let error = NSError(domain: "json", code: 400, userInfo: ["info": "Not value"])

                        self.errorDetected(error: error,
                                        showError: showError,
                                        completition: { errorHandler(error) })

                        return

                    }

                    self.delegate?.checkJson(json: JSON(value), showError: showError, completionHandler: { json in

                        completionHandler(json)

                    }, errorHandler: { error in

                        self.errorDetected(error: error!,
                                        showError: showError,
                                        completition: { errorHandler(error) })

                    })

                case .failure(let error):

                    self.errorDetected(error: error as NSError,
                                    showError: showError,
                                    completition: { errorHandler(error as NSError?) })

                }

        }

    }

<<<<<<< HEAD
    func errorDetected(error: NSError, showError: Bool, completition: @escaping AFRequestCompletionVoid) {
=======
    func errorDetected(error error: NSError, showError: Bool, completition: @escaping AFRequestCompletionVoid) {
>>>>>>> 2c5689334276e2619e2c80178779a88eb5416710

        if !anAlertIsShowed && showError {

            anAlertIsShowed = true

            delegate?.manageAlertError(error: error, completition: { completition() })

        } else {

            completition()

        }

    }

    open func closeAlert() {

        anAlertIsShowed = false

    }

}
