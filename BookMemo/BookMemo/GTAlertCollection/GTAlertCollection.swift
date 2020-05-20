//
//  GTAlertCollection.swift
//  BookMemo
//
//  Created by BessieJiang on 5/19/20.
//

import UIKit

class GTAlertCollection: NSObject {

    // MARK: - Properties
    
    /// The `GTAlertCollection` shared instance.
    static let shared = GTAlertCollection()
    
    /// The presented alert controller.
    var alertController: UIAlertController!
    
    /// The view controller that the alert controller is presented to.
    var hostViewController: UIViewController!
    
    /// The activity indicator of the alert.
    var activityIndicator: UIActivityIndicatorView!
    
    /// The `UIProgressView` object that displays the progress bar.
    var progressBar: UIProgressView!
    
    /// The label right below the progress bar.
    var label: UILabel!
    
    /// The image view of the alert.
    var imageView: UIImageView!
    
    
    
    // MARK: - Initialization
    init(withHostViewController hostViewController: UIViewController) {
        super.init()
        self.hostViewController = hostViewController
    }
    
    
    /// Default `init` method.
    override init() {
        super.init()
    }
    
    
    
    // MARK: - Fileprivate Methods
    
    /// It makes the alertController property `nil` in case it's not already.
    fileprivate func cleanUpAlertController() {
        if alertController != nil {
            alertController = nil
            
            if let _ = self.progressBar { self.progressBar = nil }
            if let _ = self.label { self.label = nil }
            if let _ = self.imageView { self.imageView = nil }
        }
    }
    
    fileprivate func createAlertActions(usingTitles buttonTitles: [String], cancelButtonIndex: Int?, destructiveButtonIndices: [Int]?, actionHandler: @escaping (_ actionIndex: Int) -> Void) -> [UIAlertAction] {
        var actions = [UIAlertAction]()
        
        // Create as many UIAlertAction actions as the items in the buttonTitles array are.
        for i in 0..<buttonTitles.count {
            // By default, all action buttons will have the .default style.
            var buttonStyle: UIAlertAction.Style = .default
            
            // Check if there should be a Cancel-like button.
            if let index = cancelButtonIndex {
                // Check if the current button should be displayed using the .cancel style.
                if index == i {
                    // If so, set the proper button style.
                    buttonStyle = .cancel
                }
            }
            
            // Check if there should be destructive buttons.
            if let destructiveButtonIndices = destructiveButtonIndices {
                // Go through each destructive button index and check if the current button should be one of them.
                for index in destructiveButtonIndices {
                    if index == i {
                        // If so, apply the .destructive style.
                        buttonStyle = .destructive
                        break
                    }
                }
            }

            let action = UIAlertAction(title: buttonTitles[i], style: buttonStyle, handler: { (action) in
                // Call the actionHandler passing the index of the current action when user taps on the current one.
                actionHandler(i)
            })
            
            // Append each new action to the actions array.
            actions.append(action)
        }
        
        
        // Return the collection of the alert actions.
        return actions
    }
    
    
    
    
    // MARK: - Public Methods
    
    func dismissAlert(completion: (() -> Void)?) {
        DispatchQueue.main.async { [unowned self] in
            if let alertController = self.alertController {
                alertController.dismiss(animated: true) {
                    self.alertController = nil
                    
                    if let _ = self.progressBar { self.progressBar = nil }
                    if let _ = self.label { self.label = nil }
                    if let _ = self.imageView { self.imageView = nil }
                    
                    if let completion = completion {
                        completion()
                    }
                }
            }
        }
    }
    
    func presentSingleButtonAlert(withTitle title: String?, message: String?, buttonTitle: String, actionHandler: @escaping () -> Void) {
        // Check if the hostViewController has been set.
        if let hostVC = hostViewController {
            // Perform all actions on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController object is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alertController object.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Create one UIAlertAction using the .default style.
                let action = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { (action) in
                    // Call the actionHandler when the action button is tapped.
                    actionHandler()
                })
                
                // Add the alert action to the alert controller.
                self.alertController.addAction(action)
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: nil)
            }
            
        } else {
            // The host view controller has no value.
            NSLog("[GTAlertCollection]: No host view controller was specified")
        }
    }
    

    func presentAlert(withTitle title: String?, message: String?, buttonTitles: [String], cancelButtonIndex: Int?, destructiveButtonIndices: [Int]?, actionHandler: @escaping (_ actionIndex: Int) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Perform all operations on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController object is nil.
                self.cleanUpAlertController()
                
                // Initialize the alert controller using the given title and message.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Create the action buttons and add them to the alert controller.
                let actions = self.createAlertActions(usingTitles: buttonTitles, cancelButtonIndex: cancelButtonIndex, destructiveButtonIndices: destructiveButtonIndices, actionHandler: actionHandler)
                for action in actions {
                    self.alertController.addAction(action)
                }
                
                // After having finished with the actions, present the alert controller animated.
                hostVC.present(self.alertController, animated: true, completion: nil)
            }
        } else {
            // The host view controller has no value.
            NSLog("[GTAlertCollection]: No host view controller was specified")
        }
        
    }

    func presentButtonlessAlert(withTitle title: String?, message: String?, presentationCompletion: @escaping (_ success: Bool) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Operate on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: {
                    // Pass true to the presentationCompletion indicating that the alert controller was presented.
                    presentationCompletion(true)
                })
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            
            // Pass false to the presentationCompletion indicating that presenting the alert controller failed.
            presentationCompletion(false)
        }
    }
    
    
    
    func presentActivityAlert(withTitle title: String?, message: String?, activityIndicatorColor: UIColor = UIColor.black, showLargeIndicator: Bool = false, presentationCompletion: @escaping (_ success: Bool) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Operate on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                // If the alert message is not nil, then add additional spaces at the end, or if it's nil add just these spaces, so it's possible to make
                // room for the activity indicator.
                // If the large activity indicator is about to be shown, then add three spaces, otherwise two.
                self.alertController = UIAlertController(title: title, message: (message ?? "") + (showLargeIndicator ? "\n\n\n" : "\n\n"), preferredStyle: .alert)
                
                // Initialize the activity indicator as large or small according to the showLargeIndicator parameter value.
                self.activityIndicator = UIActivityIndicatorView(style: showLargeIndicator ? .whiteLarge : .gray)
                
                // Set the activity indicator color.
                self.activityIndicator.color = activityIndicatorColor
                
                // Start animating.
                self.activityIndicator.startAnimating()
                
                // Add it to the alert controller's view as a subview.
                self.alertController.view.addSubview(self.activityIndicator)
                
                // Specify the following constraints to make it appear properly.
                self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                self.activityIndicator.centerXAnchor.constraint(equalTo: self.alertController.view.centerXAnchor).isActive = true
                self.activityIndicator.bottomAnchor.constraint(equalTo: self.alertController.view.bottomAnchor, constant: -8.0).isActive = true
                self.alertController.view.layoutIfNeeded()
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: {
                    // Pass true to the presentationCompletion indicating that the alert controller was presented.
                    presentationCompletion(true)
                })
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            
            // Pass false to the presentationCompletion indicating that presenting the alert controller failed.
            presentationCompletion(false)
        }
    }
    

    func presentSingleTextFieldAlert(withTitle title: String?, message: String?, doneButtonTitle: String = "Done", cancelButtonTitle: String = "Cancel", configurationHandler: @escaping (_ textField: UITextField?, _ didFinishConfiguration: () -> Void) -> Void, completionHandler: @escaping (_ editedTextField: UITextField?) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Work on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Add a textfield to the alert controller.
                self.alertController.addTextField(configurationHandler: { (textField) in
                    
                })
                
                // Add the two actions to the alert controller (Done & Cancel).
                self.alertController.addAction(UIAlertAction(title: doneButtonTitle, style: .default, handler: { (action) in
                    if let textFields = self.alertController.textFields {
                        if textFields.count > 0 {
                            // When the Done button is tapped, return the first textfield in the textfields collection.
                            completionHandler(textFields[0])
                        } else { completionHandler(nil) }
                    } else { completionHandler(nil) }
                }))
                
                self.alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action) in
                    completionHandler(nil)
                }))
                
                
                // After having added the textfield and the action buttons to the alert controller,
                // call the configurationHandler closure and pass the first textfield and the didFinishConfiguration closure.
                // When that one gets called, the alert will be presented.
                if let textFields = self.alertController.textFields {
                    if textFields.count > 0 {
                        configurationHandler(textFields[0], {
                            DispatchQueue.main.async { [unowned self] in
                                hostVC.present(self.alertController, animated: true, completion: nil)
                            }
                        })
                    } else { configurationHandler(nil, {}) }
                } else { configurationHandler(nil, {}) }
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            configurationHandler(nil, {})
        }
    }
 

    func presentMultipleTextFieldsAlert(withTitle title: String?, message: String?, doneButtonTitle: String = "Done", cancelButtonTitle: String = "Cancel", numberOfTextFields: Int, configurationHandler: @escaping (_ textFields: [UITextField]?, _ didFinishConfiguration: () -> Void) -> Void, completionHandler: @escaping (_ editedTextFields: [UITextField]?) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Work on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Add the desired number of textfields to the alert controller.
                for _ in 0..<numberOfTextFields {
                    self.alertController.addTextField(configurationHandler: { (textField) in
                        
                    })
                }
                
                // Add the two actions to the alert controller (Done & Cancel).
                self.alertController.addAction(UIAlertAction(title: doneButtonTitle, style: .default, handler: { (action) in
                    if let textFields = self.alertController.textFields {
                        if textFields.count > 0 {
                            // When the Done button is tapped, return the textfields collection.
                            completionHandler(textFields)
                        } else { completionHandler(nil) }
                    } else { completionHandler(nil) }
                }))
                
                self.alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action) in
                    
                }))
                
                
                // After having added the textfield and the action buttons to the alert controller,
                // call the configurationHandler closure and pass the textfields collection and the didFinishConfiguration closure.
                // When that one gets called, the alert will be presented.
                if let textFields = self.alertController.textFields {
                    if textFields.count > 0 {
                        configurationHandler(textFields, {
                            DispatchQueue.main.async { [unowned self] in
                                hostVC.present(self.alertController, animated: true, completion: nil)
                            }
                        })
                    } else { configurationHandler(nil, {}) }
                } else { configurationHandler(nil, {}) }
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            configurationHandler(nil, {})
        }
    }
    
    func presentProgressBarAlert(withTitle title: String?, message: String?, progressTintColor: UIColor, trackTintColor: UIColor, showPercentage: Bool, showStepsCount: Bool, updateHandler: @escaping (_ updateHandler: @escaping (_ currentStep: Int, _ totalSteps: Int) -> Void) -> Void, presentationCompletion: @escaping (_ success: Bool) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Operate on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: (message ?? "") + "\n\n", preferredStyle: .alert)
                
                // Add more space if the progress percentage or steps count should be displayed.
                if showPercentage || showStepsCount {
                    self.alertController.message! += "\n"
                }
                
                // Initialize the progress bar.
                if self.progressBar != nil {
                    self.progressBar = nil
                }
                self.progressBar = UIProgressView()
                
                // Set its color.
                self.progressBar.progressTintColor = progressTintColor
                self.progressBar.trackTintColor = trackTintColor
                
                // Set the initial progress.
                self.progressBar.progress = 0.0
                
                // Add it to the alert controller's view as a subview.
                self.alertController.view.addSubview(self.progressBar)
                
                // Specify the following constraints to make it appear properly.
                self.progressBar.translatesAutoresizingMaskIntoConstraints = false
                self.progressBar.leftAnchor.constraint(equalTo: self.alertController.view.leftAnchor, constant: 16.0).isActive = true
                self.progressBar.rightAnchor.constraint(equalTo: self.alertController.view.rightAnchor, constant: -16.0).isActive = true
                
                if showPercentage || showStepsCount {
                    self.progressBar.bottomAnchor.constraint(equalTo: self.alertController.view.bottomAnchor, constant: -28.0).isActive = true
                } else {
                    self.progressBar.bottomAnchor.constraint(equalTo: self.alertController.view.bottomAnchor, constant: -8.0).isActive = true
                }
                
                
                // Uncomment the following to change the height of the progress bar.
                // self.progressBar.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
                
                
                // Create a label right below the progress view if any text status should be displayed.
                if showPercentage || showStepsCount {
                    if self.label != nil {
                        self.label = nil
                    }
                    self.label = UILabel()
                    self.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
                    self.label.textColor = UIColor.black
                    self.label.textAlignment = .center
                    
                    if showPercentage {
                        self.label.text = "\(self.progressBar.progress * 100.0)%"
                    } else {
                        self.label.text = "0 / 0"
                    }
                    
                    
                    self.alertController.view.addSubview(self.label)
                    self.label.translatesAutoresizingMaskIntoConstraints = false
                    self.label.centerXAnchor.constraint(equalTo: self.alertController.view.centerXAnchor).isActive = true
                    self.label.topAnchor.constraint(equalTo: self.progressBar.bottomAnchor, constant: 8.0).isActive = true
                    self.label.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
                    self.label.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
                }
                
                self.alertController.view.layoutIfNeeded()
                
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: {
                    // Call the presentation completion handler passing true to indicate that the alert was presented.
                    presentationCompletion(true)
                    
                    // Implement the updateHandler closure.
                    // In it, update the progress of the progress bar, and the label if any text output should be displayed.
                    updateHandler({ currentStep, totalSteps in
                        DispatchQueue.main.async { [unowned self] in
                            self.progressBar.setProgress(Float(currentStep)/Float(totalSteps), animated: true)
                            
                            if showPercentage {
                                self.label.text = "\(Int(self.progressBar.progress * 100.0))%"
                            } else if showStepsCount {
                                self.label.text = "\(currentStep) / \(totalSteps)"
                            }
                        }
                    })
                })
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
            presentationCompletion(false)
        }
    }

    func presentImageViewAlert(withTitle title: String?, message: String?, buttonTitles: [String], cancelButtonIndex: Int?, destructiveButtonIndices: [Int]?, image: UIImage, actionHandler: @escaping (_ actionIndex: Int) -> Void) {
        // Check if the host view controller has been set.
        if let hostVC = hostViewController {
            // Operate on the main thread.
            DispatchQueue.main.async { [unowned self] in
                // Make sure that the alertController is nil before initializing it.
                self.cleanUpAlertController()
                
                // Initialize the alert controller.
                self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // Add a few empty lines to make room for the imageview.
                var updatedMessage = self.alertController.message ?? ""
                for _ in 0..<10 {
                    updatedMessage += "\n"
                }
                self.alertController.message = updatedMessage

                // Create the action buttons.
                let actions = self.createAlertActions(usingTitles: buttonTitles, cancelButtonIndex: cancelButtonIndex, destructiveButtonIndices: destructiveButtonIndices, actionHandler: actionHandler)
                for action in actions {
                    self.alertController.addAction(action)
                }
                
                
                // Initialize the imageview and configure it.
                if let _ = self.imageView {
                    self.imageView = nil
                }
                self.imageView = UIImageView()
                self.imageView.image = image
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.layer.cornerRadius = 8.0
                self.imageView.layer.masksToBounds = false
                self.imageView.clipsToBounds = true
                
                // Add it to the alert controller's view.
                self.alertController.view.addSubview(self.imageView)
                
                // Specify its constraints.
                self.imageView.translatesAutoresizingMaskIntoConstraints = false
                self.imageView.centerXAnchor.constraint(equalTo: self.alertController.view.centerXAnchor).isActive = true
                self.imageView.bottomAnchor.constraint(equalTo: self.alertController.view.bottomAnchor, constant: -16.0 - (44.0 * CGFloat(buttonTitles.count))).isActive = true
                self.imageView.widthAnchor.constraint(equalToConstant: self.alertController.view.frame.size.width/3).isActive = true
                self.imageView.heightAnchor.constraint(equalToConstant: self.alertController.view.frame.size.width/3).isActive = true
                self.alertController.view.layoutIfNeeded()
                
                
                // Present the alert controller to the host view controller.
                hostVC.present(self.alertController, animated: true, completion: {
                    
                })
            }
            
        } else {
            // The host view controller is nil and the alert controller cannot be presented.
            NSLog("[GTAlertCollection]: No host view controller was specified")
        }
        
        
    }
    
}
