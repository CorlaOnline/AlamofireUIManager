//
//  AlamofireUIManager.swift
//
//  Created by Alex Corlatti on 03/06/16.
//  Copyright © 2016 CorlaOnline. All rights reserved.
//

import Alamofire
import SwiftyJSON

public typealias ACRequestCompletionHandler = JSON -> Void
public typealias ACRequestErrorHandler = NSError? -> Void
public typealias ACRequestCompletionVoid = Void -> Void

public protocol ACAlamofireManagerDelegate {

    func createSpinner() -> UIView
    func closeSpinner(spinner: UIView?)

    func checkJson(json: JSON, showError: Bool, completionHandler: ACRequestCompletionHandler, errorHandler: ACRequestErrorHandler)

    func manageAlertError(error: NSError?, completition: ACRequestCompletionVoid)

}

public class ACAlamofireManager {

    let manager = Alamofire.Manager.sharedInstance

    static let sharedInstance = ACAlamofireManager()

    var delegate: ACAlamofireManagerDelegate?

    var activeConnection = 0
    var progressAlert: UIView?
    var anAlertIsShowed: Bool = false

    init() {}

    // MARK: - Connection Utility

    func addConnection(showSpinner: Bool, spinnerTitle: String, spinnerSubTitle: String) {

        activeConnection += 1

        if activeConnection == 1 {

            UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            if showSpinner {

                progressAlert = delegate?.createSpinner()

            }

        }

    }

    func removeConnection() {

        activeConnection -= 1

        if activeConnection == 0 {

            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            if (progressAlert != nil) {

                delegate?.closeSpinner(progressAlert)

            }

        }

    }

    public func request(request: URLRequestConvertible, showSpinner: Bool = true, showError: Bool = true, spinnerTitle: String = "", spinnerSubTitle: String = "", completionHandler: (ACRequestCompletionHandler), errorHandler: (ACRequestErrorHandler) = { _ in }) {

        addConnection(showSpinner, spinnerTitle: spinnerTitle, spinnerSubTitle: spinnerSubTitle)

        manager
            .request(request)
            .responseJSON() { response in

                self.removeConnection()

                print(response.result.value)

                switch response.result {

                case .Success:

                    guard let value = response.result.value else {

                        let error = NSError(domain: "json", code: 400, userInfo: ["info": "Not value"])

                        self.errorDetected(error: error,
                                        showError: showError,
                                        completition: { errorHandler(error) })

                        return

                    }

                    self.delegate?.checkJson(JSON(value), showError: showError, completionHandler: { json in

                        completionHandler(json)

                    }, errorHandler: { error in

                        self.errorDetected(error: error!,
                                        showError: showError,
                                        completition: { errorHandler(error) })

                    })

                case .Failure(let error):

                    self.errorDetected(error: error,
                                    showError: showError,
                                    completition: { errorHandler(error) })

                }

        }

    }

    func errorDetected(error error: NSError, showError: Bool, completition: ACRequestCompletionVoid) {

        if !anAlertIsShowed && showError {

            anAlertIsShowed = true

            delegate?.manageAlertError(error, completition: { completition() })

        } else {

            delegate?.manageAlertError(error, completition: { completition() })

        }

    }

    public func closeAlert() {

        anAlertIsShowed = false

    }

}
