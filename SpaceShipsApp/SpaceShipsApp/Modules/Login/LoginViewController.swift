//
//  LoginViewController.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 16/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private let contentView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        textField.autocapitalizationType = .none
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
        textField.autocapitalizationType = .none
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailValidationErrorLabel = {
        let label = UILabel()
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
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginAsGuestButton = {
        let button = UIButton()
        button.setTitle("Continue as guest", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(loginAsGuestButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let bannerLabel = {
        let banner = UILabel()
        banner.text = "No internet connection. You’re in Offline mode."
        banner.textAlignment = .center
        banner.numberOfLines = 0
        banner.isHidden = true
        banner.backgroundColor = .systemGray4
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        guard let navigationController = navigationController else { return }
        navigationController.view.addSubview(bannerLabel)
        
        view.addSubview(contentView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(emailValidationErrorLabel)
        contentView.addSubview(loginButton)
        contentView.addSubview(loginAsGuestButton)
        contentView.addSubview(activityIndicator)
        
        
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -5),
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 5),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
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
            loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 35),
            
            loginAsGuestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            loginAsGuestButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            loginAsGuestButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginAsGuestButton.heightAnchor.constraint(equalToConstant: 30),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            bannerLabel.topAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor),
            bannerLabel.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            bannerLabel.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor),
            bannerLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        emailTextField.rx.text.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: viewModel.password).disposed(by: disposeBag)
        viewModel.emailValidationError.bind(to: emailValidationErrorLabel.rx.text).disposed(by: disposeBag)
        viewModel.isConnectedToInternet.subscribe(onNext: { [weak self] isConnectedToInternet in
            DispatchQueue.main.async {
                self?.bannerLabel.isHidden = isConnectedToInternet
                self?.view.isHidden = !isConnectedToInternet
            }
        }).disposed(by: disposeBag)
    }
    
    @objc private func loginButtonPressed() {
        handleLogin(asGuest: false)
    }
    
    @objc private func loginAsGuestButtonPressed() {
        handleLogin(asGuest: true)
    }
    
    private func handleLogin(asGuest isGuest: Bool) {
        activityIndicator.startAnimating()
        let isLoginValid = viewModel.validateLogin(isGuest)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.activityIndicator.stopAnimating()
            guard 
                isLoginValid,
                let shipsListViewModel = self?.viewModel.getShipsListViewModel(isGuest)
            else { return }
            let shipsListViewController = ShipsListViewController(viewModel: shipsListViewModel)
            self?.navigationController?.pushViewController(shipsListViewController, animated: true)
        }
    }
}
