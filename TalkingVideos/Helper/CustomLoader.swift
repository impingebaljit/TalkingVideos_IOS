//
//  CustomLoader.swift
//  Bluelight
//
//  Created by Nisha Gupta on 08/04/24.
//

import UIKit

import UIKit

class CustomLoader {
    
    static let shared = CustomLoader() // Singleton instance
    
    private var loaderView: UIView?
    private var loaderImageView: UIImageView?
    
    private init() {} // Prevent external instantiation
    
    func showLoader(in viewController: UIViewController) {
        // Ensure loader is not already present
        if loaderView != nil { return }

        // Create a full-screen overlay
        loaderView = UIView(frame: viewController.view.bounds)
        loaderView?.backgroundColor = UIColor(white: 0, alpha: 0.4) // Semi-transparent black background

        // Create the default UIActivityIndicatorView (spinner)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loaderView!.center
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        // Add subviews
        loaderView?.addSubview(activityIndicator)
        viewController.view.addSubview(loaderView!)
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.loaderImageView?.layer.removeAllAnimations()
            self.loaderView?.removeFromSuperview()
            self.loaderView = nil
            self.loaderImageView = nil
        }
    }
    
//    private func startLoadingAnimation() {
//        // Start rotating animation
//        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveLinear, .repeat], animations: {
//            self.loaderImageView?.transform = self.loaderImageView!.transform.rotated(by: CGFloat.pi)
//        }, completion: nil)
//    }
    
    func startLoadingAnimation() {
        guard let loaderImageView = loaderImageView else { return }

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        loaderImageView.layer.add(rotation, forKey: "rotateAnimation")
    }
}
