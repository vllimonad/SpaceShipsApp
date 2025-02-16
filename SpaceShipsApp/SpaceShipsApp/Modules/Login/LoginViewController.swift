//
//  LoginViewController.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 16/02/2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let headerLabel = {
        let label = UILabel()
        label.text = "Space X ships"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel = {
        let label = UILabel()
        label.text = "Email:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel = {
        let label = UILabel()
        label.text = "Password:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your email"
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 0.2
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your password"
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 0.2
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailValidationErrorLabel = {
        let label = UILabel()
        //label.text = "Incorrect email"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginAsGuestButton = {
        let button = UIButton()
        button.setTitle("Continue as guest", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubview(headerLabel)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(emailValidationErrorLabel)
        view.addSubview(loginButton)
        view.addSubview(loginAsGuestButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -5),
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 5),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            emailValidationErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            emailValidationErrorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 5),
            emailValidationErrorLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),

            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -5),
            passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 5),
            
            passwordTextField.topAnchor.constraint(equalTo: emailValidationErrorLabel.bottomAnchor, constant: 35),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 70),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 35),
            
            loginAsGuestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            loginAsGuestButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            loginAsGuestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginAsGuestButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
