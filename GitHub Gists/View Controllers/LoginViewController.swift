//
//  LoginViewController.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/25/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

// MARK: - LoginViewControllerDelegate Protocol
// This protocol handles dismissing the LoginViewController Scene
protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidFinishSelecting(_ controller: LoginViewController)
}

// This class is responsible for the login page. Some HTTP protocols require a log in for OAUTH.
class LoginViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: LoginViewControllerDelegate?

    // MARK: - IBOutlets

    // MARK: - IBActions
    // Will bring up login view
    @IBAction func loginButtonTapped(_ sender: Any) {
        delegate?.loginViewControllerDidFinishSelecting(self)
    }

    // MARK: - Life Cycle

    // MARK: - Methods

    // MARK: - Navigation

    // MARK: - Data Persistance
}
