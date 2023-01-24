//
//  AppDelegate.swift
//  PhotoFaceSample
//
//  Created by Thiago Silva on 02/12/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var restrictRotation: UIInterfaceOrientationMask = .all
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let presenter = UINavigationController()
      presenter.navigationBar.isTranslucent = false
      presenter.navigationBar.tintColor = .blue
      presenter.navigationBar.barTintColor = .blue
    let router = PhotoFaceRouter(presenter: presenter)
    router.start()
    
    let worker = PhotoFaceWorker()
    let rootViewModel = LoginViewModel(worker: worker, navigationDelegate: router)
    let rootViewController = LoginViewController(viewModel: rootViewModel)

    worker.accessToken = rootViewModel.accessToken
    
//    let navigationController = UINavigationController(rootViewController: rootViewController)
//      navigationController.setNavigationBarHidden(false, animated: false)
    
      let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = presenter
    window.makeKeyAndVisible()
    
    self.window = window
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {}
  
  func applicationDidEnterBackground(_ application: UIApplication) {}
  
  func applicationWillEnterForeground(_ application: UIApplication) {}
  
  func applicationDidBecomeActive(_ application: UIApplication) {}
  
  func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // Ensure the URL is a file URL
    guard inputURL.isFileURL else { return false }
    
    // Reveal / import the document at the URL
    guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else { return false }
    
    documentBrowserViewController.revealDocument(at: inputURL, importIfNeeded: true) { (revealedDocumentURL, error) in
      if let error = error {
        // Handle the error appropriately
        print("Failed to reveal the document at URL \(inputURL) with error: '\(error)'")
        return
      }
      
      // Present the Document View Controller for the revealed URL
      documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
    }
    
    return true
  }
  
//  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//      return self.restrictRotation
//  }
}

