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
        // Create loader view
        loaderView = UIView(frame: viewController.view.bounds)
        loaderView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        // Add loader image
        loaderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) // Set your desired frame
        loaderImageView?.center = loaderView!.center
        loaderImageView?.contentMode = .scaleAspectFit
        loaderImageView?.image = UIImage(named: "colorLoader") // Change "loader_image" to your image name
        
        loaderView?.addSubview(loaderImageView!)
        viewController.view.addSubview(loaderView!)
        
        // Start loader animation
        startLoadingAnimation()
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.loaderImageView?.layer.removeAllAnimations()
            self.loaderView?.removeFromSuperview()
            self.loaderView = nil
            self.loaderImageView = nil
        }
    }
    
    private func startLoadingAnimation() {
        // Start rotating animation
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveLinear, .repeat], animations: {
            self.loaderImageView?.transform = self.loaderImageView!.transform.rotated(by: CGFloat.pi)
        }, completion: nil)
    }
}
