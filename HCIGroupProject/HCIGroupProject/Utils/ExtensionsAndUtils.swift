//
//  ExtensionsAndUtils.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/26/24.
//

import UIKit

class Utils {
    
    open func updateUIForAPICall(vc: UIViewController, on: Bool, completion: @escaping ()->()) {
        
        if on == true {
            toggleFreezeScreen(vc: vc, freeze: on)
            showLoadingIndicator(vc: vc, on: on) {
                completion()
            }
        } else {
            showLoadingIndicator(vc: vc, on: on) {
                self.toggleFreezeScreen(vc: vc, freeze: on)
                completion()
            }
        }
    }
    
    open func toggleFreezeScreen(vc: UIViewController, freeze: Bool) {
        if freeze == true {
            vc.view.isUserInteractionEnabled = false
        } else {
            vc.view.isUserInteractionEnabled = true
        }
    }
    
    open func promptAlert(vc: UIViewController, title: String, message: String, actions: Array<AlertActions>) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        if actions.isEmpty == false {
            for action in actions {
                if action == .ok {
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                } else if action == .cancel {
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                } else if action == .done {
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {_ in
                        vc.navigationController?.popViewController(animated: true)
                    }))
                } else if action == .terminate {
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                        DispatchQueue.main.async {
                            self.alertToCloseApp(vc: vc)
                        }
                    }))
                }
            }
        }
        vc.present(alert, animated: false, completion: nil)
    }
    
    open func alertToCloseApp(vc: UIViewController) {
        let alert = UIAlertController(title: "Closing App", message: "Please restart after resolving issue", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
            exit(-1)
        }))
        vc.present(alert, animated: false, completion: nil)
    }
    
    open func showLoadingIndicator(vc: UIViewController, on: Bool, completion: @escaping ()->()) {
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        if on == true {
            vc.present(alert, animated: false) {
                completion()
            }
        } else {
            if let childvc = vc.navigationController?.viewControllers.first {
                childvc.dismiss(animated: true, completion: nil)
                completion()
            } else {
                if let vc = self.getTopVC() {
                    if vc.isKind(of: UIAlertController.self) {
                        vc.dismiss(animated: true)
                        completion()
                    }
                }
            }
            //
            
            
        }
    }
    
    func getTopVC() -> UIViewController? {
        let keyWindow = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        if var top = keyWindow?.rootViewController {
            while let presentedViewController = top.presentedViewController {
                top = presentedViewController
            }
            if top.isKind(of: UIAlertController.self) {
                if let parent = top.presentingViewController {
                    parent.children.forEach { child in
                        print(child)
                        if !child.isKind(of: UIAlertController.self) {
                            top = child
                        }
                    }
                }
                
                return top
            } else {
                print("Uh oh")
                return nil
            }
            
        }
        return nil
        
    }
    
    
}

extension UIButton {
    /// Styles the button with rounded corners, a border, and a shadow.
    func applyRoundedStyle(
        cornerRadius: CGFloat? = nil,
        borderColor: UIColor = .lightGray,
        borderWidth: CGFloat = 1,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.2,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowRadius: CGFloat = 4,
        backgroundColor: UIColor = .white,
        textColor: UIColor = .black,
        highlightedTextColor: UIColor? = nil, // Optional highlighted text color
        font: UIFont = UIFont.boldSystemFont(ofSize: 16)
    ) {
        // If UIButton.Configuration is being used, apply only border, shadow, and corner radius
        if #available(iOS 15.0, *), self.configuration != nil {
            self.layer.cornerRadius = cornerRadius ?? self.frame.height / 2
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOpacity = shadowOpacity
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            return
        }
        
        // Normal behavior for non-configured buttons
        self.layer.cornerRadius = cornerRadius ?? self.frame.height / 2
        self.layer.masksToBounds = false // Allow shadows outside bounds
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        
        self.backgroundColor = backgroundColor
        
        self.setTitleColor(textColor, for: .normal)
        if let highlightedColor = highlightedTextColor {
            self.setTitleColor(highlightedColor, for: .highlighted)
        }
        self.titleLabel?.font = font
        
        self.adjustsImageWhenHighlighted = false
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

enum AlertActions {
    case ok
    case cancel
    case done
    case terminate
}
