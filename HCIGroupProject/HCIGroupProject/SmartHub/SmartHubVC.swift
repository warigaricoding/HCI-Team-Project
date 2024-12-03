//
//  SmartHubVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/26/24.
//

import UIKit

class SmartHubVC: UIViewController {
    
    @IBOutlet weak var smartHubDevicesBtn: UIButton!
    @IBOutlet weak var smartHubDeviceGroupsBtn: UIButton!
    @IBOutlet weak var smartHubStatsBtn: UIButton!
    @IBOutlet weak var activeDevicesBtn: UIButton!
    
    private var isConfigured = false // To prevent multiple configurations
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply the UI configuration only once, after the layout is complete
        if !isConfigured {
            configureButtons()
            isConfigured = true
        }
    }
    
    private func configureButtons() {
        if #available(iOS 15.0, *) {
            let resizedActiveImage = resizeImage(image: UIImage(named: "active"), targetSize: CGSize(width: 25, height: 25))
            // Configure "Smart Devices" button
            configureButton(smartHubDevicesBtn, title: "Smart Devices", fontSize: 20, imageName: "sh_1")

            
            configureButton(smartHubDeviceGroupsBtn, title: "Device Groups", fontSize: 20, imageName: "sh_2")
            
            configureButton(smartHubStatsBtn, title: "Statistics Report", fontSize: 20, imageName: "sh_3")
            
            
            
            // Configure "Active Devices" button
            var activeConfig = UIButton.Configuration.plain()
            activeConfig.image = resizedActiveImage
            activeConfig.imagePlacement = .leading
            activeConfig.imagePadding = 8
            activeConfig.attributedTitle = AttributedString("Active Devices: \(AppConfig.shared.devices.count)", attributes: .init([
                .font: UIFont.systemFont(ofSize: 16)
            ]))
            activeConfig.baseForegroundColor = .black
            activeConfig.baseBackgroundColor = .white
            activeDevicesBtn.configuration = activeConfig

            
            // Apply rounded style for all buttons
            activeDevicesBtn.applyRoundedStyle()
        }
    }
    
    private func configureButton(_ button: UIButton, title: String, fontSize: CGFloat, imageName: String) {
        guard let originalImage = UIImage(named: imageName) else { return }
        let resizedImage = resizeImage(image: originalImage)
        
        if #available(iOS 15.0, *) {
            // Use UIButton's configuration API for iOS 15+
            var config = UIButton.Configuration.plain()
            config.title = title
            config.image = resizedImage
            config.imagePlacement = .top
            config.imagePadding = 8 // Space between image and text
            config.baseForegroundColor = .black
            config.attributedTitle = AttributedString(title, attributes: .init([
                .font: UIFont.systemFont(ofSize: fontSize)
            ]))
            button.configuration = config
        } else {
            // Fallback for earlier iOS versions
            button.setImage(resizedImage, for: .normal)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(.black, for: .normal)
            
            // Adjust insets for image and title
            let spacing: CGFloat = 8 // Space between image and title
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center
            button.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -resizedImage!.size.width, bottom: -resizedImage!.size.height, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: -button.titleLabel!.intrinsicContentSize.height - spacing, left: 0, bottom: 0, right: -button.titleLabel!.intrinsicContentSize.width)
        }
        
        button.applyRoundedStyle(cornerRadius: 10)
    }
    
    private func resizeImage(image: UIImage?, targetSize: CGSize = CGSize(width: 80, height: 80)) -> UIImage? {
        guard let image = image else { return nil }
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    
    @IBAction func devicesBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let devicesVC = storyboard.instantiateViewController(withIdentifier: "DevicesCollectionVC") as? DevicesCollectionVC else {
            return
        }
        
        // Configure modal presentation style
        devicesVC.modalPresentationStyle = .custom // Use popover for a centered effect
        devicesVC.transitioningDelegate = self
        devicesVC.preferredContentSize = CGSize(width: 340, height: 600)
        
        // Set up popover presentation controller
        if let popover = devicesVC.popoverPresentationController {
            popover.sourceView = self.view // Anchor to the presenting view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Center the popover
            popover.permittedArrowDirections = [] // Disable arrow
            popover.delegate = self // Enable adaptive behavior
        }
        
        devicesVC.isFromSmartHub = true
        devicesVC.parentVC = self
        
        // Present the modal
        self.present(devicesVC, animated: true, completion: nil)
    }
    @IBAction func deviceGroupBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let deviceGroupVC = storyboard.instantiateViewController(withIdentifier: "DeviceGroupOverviewVC") as? DeviceGroupOverviewVC else {
            return
        }

        // Pass data to the next view controller
        deviceGroupVC.deviceGroups = AppConfig.shared.deviceGroups

        // Push the view controller onto the navigation stack
        self.navigationController?.pushViewController(deviceGroupVC, animated: true)
    }
    @IBAction func smartHubStatsBtnClicked(_ sender: Any) {
        
        let activityVC = PDFGenerator().generateUsageStatsPDF()
            // Present the Activity View Controller
            self.present(activityVC, animated: true, completion: nil)
    }
    
}
extension SmartHubVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Force popover to remain centered on iPhone
    }
}

extension SmartHubVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, width: 340, height: 600)
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverPresentationAnimator(width: 340, height: 600)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil // Optional: Provide a custom dismiss animation
    }
}


class PopoverPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let customWidth: CGFloat
    private let customHeight: CGFloat

    // Initializer to accept custom dimensions
    init(width: CGFloat, height: CGFloat) {
        self.customWidth = width
        self.customHeight = height
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // Animation duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView

        // Set the size and position of the presented view
        let xPosition = (containerView.bounds.width - customWidth) / 2
        let yPosition = (containerView.bounds.height - customHeight) / 2
        toView.frame = CGRect(x: xPosition, y: yPosition, width: customWidth, height: customHeight)

        // Add optional rounded corners and shadows for a polished look
        toView.layer.cornerRadius = 12
        toView.clipsToBounds = true

        // Initial state for animation
        toView.alpha = 0
        toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.addSubview(toView)

        // Animate to final state
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                           toView.alpha = 1
                           toView.transform = .identity
                       },
                       completion: { finished in
                           transitionContext.completeTransition(finished)
                       })
    }
}


class CustomPresentationController: UIPresentationController {
    private let customWidth: CGFloat
    private let customHeight: CGFloat

    // Dismissable dimming view
    private lazy var dimmingView: UIView = {
        let view = UIView(frame: containerView?.bounds ?? .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    // Initializer to accept custom dimensions
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, width: CGFloat, height: CGFloat) {
        self.customWidth = width
        self.customHeight = height
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        containerView.addSubview(dimmingView)
        dimmingView.frame = containerView.bounds

        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1
            })
        } else {
            dimmingView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0
            })
        } else {
            dimmingView.alpha = 0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        // Use the passed dimensions for the frame
        let xPosition = (containerView.bounds.width - customWidth) / 2
        let yPosition = (containerView.bounds.height - customHeight) / 2
        return CGRect(x: xPosition, y: yPosition, width: customWidth, height: customHeight)
    }

    @objc private func handleTapOutside() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
