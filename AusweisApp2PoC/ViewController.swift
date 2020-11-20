//
//  ViewController.swift
//  AusweisApp2PoC
//
//  Created by Niroshan Maheswaran on 21.11.20.
//

import UIKit
import AusweisApp2

/// Extension on UIView.
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
        
        get {
            layer.cornerRadius
        }
    }
}

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var retryButton: UIButton!
    
    // MARK: - Private properties
    
    private let ausweisService = AusweisApp2Service.shared
    private var resultUrlString: String?
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receivedAusweisServiceMessage(_:)),
            name: Notification.ausweisApp2Messages,
            object: nil
        )
        setupView()
    }
}

// MARK: - Private methods

extension ViewController {
    
    private func setupView() {
        startButton.setTitle("Start Authentication", for: .normal)
        startButton.tag = 0
        statusLabel.text = "-"
        retryButton.isHidden = false
        ausweisService.start()
    }
    
    @IBAction private func run(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            ausweisService.sendCommand(Command.runAuth)
            
        case 1:
            if let urlString = resultUrlString {
                self.showResults(urlString: urlString)
            }
            
        case 2:
            enterPinAlert()
            
        default:
            break
        }
    }
    
    @IBAction private func retryTapped(_ sender: UIButton) {
        setupView()
    }
    
    @objc private func receivedAusweisServiceMessage(_ notifications: NSNotification) {
        guard let message = notifications.userInfo?["msg"] as? AusweisApp2Result else {
            fatalError("Reveived notification should have a message from AusweisApp2SDK.")
        }
        
        switch message.message {
        
        case .auth:
            if let url = message.resultURL {
                self.resultUrlString = url
                
                DispatchQueue.main.async {
                    self.startButton.setTitle("Show Results", for: .normal)
                    self.startButton.tag = 1
                    self.statusLabel.text = "Authentication completed successfully."
                }
                print("SDK: Authentication successfully finished. See results in webview.")
            } else {
                DispatchQueue.main.async {
                    self.statusLabel.text = "Authentication started."
                }
                print("SDK: Authentication started successfully.")
            }
            
        case .accessRights:
            print("SDK: Received ACCESS_RIGHTS command. ACCEPT command will be send.")
            ausweisService.sendCommand(.accept)
            
        case .enterPin:
            print("SDK: A PIN is required to continue workflow.")
            DispatchQueue.main.async {
                self.statusLabel.text = "PIN required"
                self.startButton.setTitle("Enter PIN", for: .normal)
                self.startButton.tag = 2
            }
            
        default:
            break
        }
    }
    
    private func enterPinAlert() {
        let alert = UIAlertController(title: "Enter PIN", message: nil, preferredStyle: .alert)
        alert.addTextField { alertTextfield in
            alertTextfield.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Send PIN", style: .default, handler: { [unowned self] _ in
            guard let alertTextfield = alert.textFields?.first else { return }
            if let pin = alertTextfield.text {
                self.ausweisService.sendCommand(.setPin(pin: pin))
            }
        }))
        
        self.present(alert, animated: true)
    }
}

// MARK: - Navigation

extension ViewController {
    
    private func showResults(urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("Given url string is not a URL.")
        }
        
        guard let webviewViewController = mainStoryboard.instantiateViewController(
                withIdentifier: String(describing: WebviewViewController.self)
        ) as? WebviewViewController else {
            fatalError("Could not instantiate WebviewViewController.")
        }
        webviewViewController.url = url
        
        self.navigationController?.pushViewController(webviewViewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
