//
//  AlamofireUIManager.swift
//
//  Created by Alex Corlatti on 03/06/16.
//  Copyright © 2016 CorlaOnline. All rights reserved.
//

import Alamofire
import SwiftyJSON

public typealias AFRequestCompletionHandler = JSON -> Void
public typealias AFRequestErrorHandler = NSError? -> Void
public typealias AFRequestCompletionVoid = Void -> Void

public protocol AlamofireUIManagerDelegate {

    func createSpinner() -> UIView
    func closeSpinner(spinner: UIView?)

    func checkJson(json: JSON, showError: Bool, completionHandler: AFRequestCompletionHandler, errorHandler: AFRequestErrorHandler)

    func manageAlertError(error: NSError?, completition: AFRequestCompletionVoid)

}

public class AlamofireUIManager {

    let AFManager = Alamofire.Manager.sharedInstance

    public static let sharedInstance = AlamofireUIManager()

    public var delegate: AlamofireUIManagerDelegate?

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

    public func request(request: URLRequestConvertible, showSpinner: Bool = true, showError: Bool = true, spinnerTitle: String = "", spinnerSubTitle: String = "", completionHandler: (AFRequestCompletionHandler), errorHandler: (AFRequestErrorHandler) = { _ in }) {

        addConnection(showSpinner, spinnerTitle: spinnerTitle, spinnerSubTitle: spinnerSubTitle)

        AFManager
            .request(request)
            .responseJSON() { response in

                self.removeConnection()

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

    func errorDetected(error error: NSError, showError: Bool, completition: AFRequestCompletionVoid) {

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
