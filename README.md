# AlamofireUIManager

[![CI Status](http://img.shields.io/travis/Alex Corlatti/AlamofireUIManager.svg?style=flat)](https://travis-ci.org/Alex Corlatti/AlamofireUIManager)
[![Version](https://img.shields.io/cocoapods/v/AlamofireUIManager.svg?style=flat)](http://cocoapods.org/pods/AlamofireUIManager)
[![License](https://img.shields.io/cocoapods/l/AlamofireUIManager.svg?style=flat)](http://cocoapods.org/pods/AlamofireUIManager)
[![Platform](https://img.shields.io/cocoapods/p/AlamofireUIManager.svg?style=flat)](http://cocoapods.org/pods/AlamofireUIManager)

AlamofireRouter is a simple Alamofire router. If you need swift 2.3 version, use the 0.1.0 pod version

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0+ / tvOS 9.0+
- Xcode 8.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.0.0+ is required to build AlamofireUIManager

To integrate AlamofireRouter into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'AlamofireUIManager'
```

Then, run the following command:

```bash
$ pod install
```

## Usage
In your viewcontroller create the shared instance of the ```
AlamofireUIManager``` like in this way

```swift
class MyViewController: UIViewController {

	let netManager = AlamofireUIManager.sharedInstance
	...
	
```

In ``` viewDidLoad() ``` method set the delegate

```swift
override func viewDidLoad() {

	super.viewDidLoad()

   	netManager.delegate = self
   	...
	
```

Implements the delegate methods:

*  ```createSpinner() -> UIView``` customize the view during loading data
*  ```closeSpinner(spinner: UIView?)``` for removing your customized view
*  ```checkJson(json: JSON, showError: Bool, completionHandler: AFRequestCompletionHandler, errorHandler: AFRequestErrorHandler) {``` for cheching the JSON response before passing it to the completition handler
*  ```manageAlertError(error: NSError?, completition: @escaping AFRequestCompletionVoid)``` customize the alert view

For example:

```swift
extension MyViewController: AlamofireUIManagerDelegate {

    func createSpinner() -> UIView {

        let act  = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
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

    func checkJson(json: JSON, showError: Bool, completionHandler: AFRequestCompletionHandler, errorHandler: AFRequestErrorHandler) {

        if let errorStr = json["error"]["message"].string { // Probably authorization required

            let error = NSError(domain: "json", code: 401, userInfo: ["info": errorStr])

            errorHandler(error)

        } else { completionHandler(json) }

    }

    func manageAlertError(error: NSError?, completition: @escaping AFRequestCompletionVoid) {

        let alertController = UIAlertController(title: "Error", message: error?.description, preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in

            self.netManager.closeAlert()
            completition()

        })

        alertController.addAction(defaultAction)

        presentViewController(alertController, animated: true, completion: nil)

    }

}
	
```

## Author

Alex Corlatti, alex.corlatti@gmail.com

## License

AlamofireUIManager is available under the MIT license. See the LICENSE file for more info.
