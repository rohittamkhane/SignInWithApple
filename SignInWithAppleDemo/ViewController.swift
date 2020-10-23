//
//  ViewController.swift
//  SignInWithAppleDemo
//
//  Created by Rohit on 23/10/20.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSignInWithAppleButton()
    }
    
    func setupSignInWithAppleButton() {
        
        let authButton = ASAuthorizationAppleIDButton()
        authButton.frame = CGRect.init(x: 50, y: self.view.frame.height/2 - 25, width: self.view.frame.width - 100, height: 50)
        authButton.addTarget(self, action: #selector(actionOnSignInWithAppleIDButton), for: .touchUpInside)
        self.view.addSubview(authButton)
    }
    
    @objc func actionOnSignInWithAppleIDButton() {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        let authVC = ASAuthorizationController.init(authorizationRequests: [request])
        authVC.presentationContextProvider = self
        authVC.delegate = self
        authVC.performRequests()
        
    }
    
}

extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        let id = appleIDCredential.user
        let email = appleIDCredential.email
        let firstName = appleIDCredential.fullName?.givenName ?? ""
        let lastName = appleIDCredential.fullName?.familyName ?? ""
        let name = firstName + lastName
        print(appleIDCredential)
        UserDefaults.standard.set(id, forKey: "userId")
        let result = String("User ID:\(id)\nEmail:\(email)\nName:\(name)")
        print(result)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding
{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
