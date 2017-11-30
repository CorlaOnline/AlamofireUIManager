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
public typealias AFRequestCompletionVoid = () -> ()

public protocol AlamofireUIManagerDelegate {

    func createSpinner() -> UIView
    func closeSpinner(_ spinner: UIView?)

    func checkJson(_ json: JSON, showError: Bool, completionHandler: AFRequestCompletionHandler, errorHandler: AFRequestErrorHandler)

    func manageAlertError(_ error: NSError?, completition: @escaping AFRequestCompletionVoid)

}

open class AlamofireUIManager {

    let AFManager = Alamofire.SessionManager.default

    open static let sharedInstance = AlamofireUIManager()

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

                delegate?.closeSpinner(progressAlert)

            }

        }

    }

    open func request(_ request: URLRequestConvertible, showSpinner: Bool = true, showError: Bool = true, spinnerTitle: String = "", spinnerSubTitle: String = "", completionHandler: @escaping (AFRequestCompletionHandler), errorHandler: @escaping (AFRequestErrorHandler) = { _ in }) {

        addConnection(showSpinner, spinnerTitle: spinnerTitle, spinnerSubTitle: spinnerSubTitle)
        
        AFManager
            .request(request)
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

                    self.delegate?.checkJson(JSON(value), showError: showError, completionHandler: { json in

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

    func errorDetected(error: NSError, showError: Bool, completition: @escaping AFRequestCompletionVoid) {

        if !anAlertIsShowed && showError {

            anAlertIsShowed = true

            delegate?.manageAlertError(error, completition: { completition() })

        } else {

            completition()

        }

    }

    open func closeAlert() {

        anAlertIsShowed = false

    }

}
