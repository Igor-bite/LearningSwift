//
//  ViewController.swift
//  Project28
//
//  Created by Игорь Клюжев on 25.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    var isOpened = false {
        didSet {
            if isOpened {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } // else {
//                        let ac = UIAlertController(title: "Authentication failed", message: "You couldn't be identified", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "OK", style: .default))
//                        self?.present(ac, animated: true)
//                    }
                }
            }
        } else {
            if let password = KeychainWrapper.standard.string(forKey: "Password") {
                let ac = UIAlertController(title: "Enter a password", message: "To set new password just enter a current and then press \"Set\"", preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "Set a new password", style: .default, handler: { [weak self, weak ac] (action) in
                    if ac?.textFields![0].text == password {
                        self?.setNewPassword()
                        self?.unlockSecretMessage()
                    }
                }))
                ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self, weak ac] (action) in
                    if ac?.textFields![0].text == password {
                        self?.unlockSecretMessage()
                    } else {
                        let newAC = UIAlertController(title: "Password error", message: "Password is incorrect", preferredStyle: .alert)
                        newAC.addAction(UIAlertAction(title: "OK", style: .default))
                        
                        self?.present(newAC, animated: true)
                    }
                }))
                present(ac, animated: true)
            } else {
                setNewPassword()
            }
        }
    }
    
    func setNewPassword() {
        let ac = UIAlertController(title: "Set a new password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak ac] (action) in
            KeychainWrapper.standard.set((ac?.textFields![0].text)!, forKey: "Password")
        }))
        
        present(ac, animated: true)
    }
    
    func unlockSecretMessage() {
        isOpened = true
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        isOpened = false
    }
}

