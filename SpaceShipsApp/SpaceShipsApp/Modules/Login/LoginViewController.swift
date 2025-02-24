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
    
    private let headerLabel = {
        let label = UILabel()
        label.text = "Space X ships"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginFieldsView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        textField.layer.borderWidth = 0.3
        textField.autocapitalizationType = .none
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your password"
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 0.3
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
    
    private let bannerView = {
        let view = BannerVeiw()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        navigationController.view.addSubview(bannerView)
        
        view.addSubview(headerLabel)
        view.addSubview(loginFieldsView)
        view.addSubview(activityIndicator)
        
        loginFieldsView.addSubview(emailLabel)
        loginFieldsView.addSubview(passwordLabel)
        loginFieldsView.addSubview(emailTextField)
        loginFieldsView.addSubview(passwordTextField)
        loginFieldsView.addSubview(emailValidationErrorLabel)
        loginFieldsView.addSubview(loginButton)
        loginFieldsView.addSubview(loginAsGuestButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            headerLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 400),

            loginFieldsView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            loginFieldsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loginFieldsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginFieldsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginFieldsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250),
            loginFieldsView.heightAnchor.constraint(lessThanOrEqualToConstant: 500),
            
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -5),
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 5),
            
            emailTextField.leadingAnchor.constraint(equalTo: loginFieldsView.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: loginFieldsView.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailValidationErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            emailValidationErrorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 5),
            emailValidationErrorLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),

            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -5),
            passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 5),
            
            passwordTextField.topAnchor.constraint(equalTo: emailValidationErrorLabel.bottomAnchor, constant: 35),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: loginFieldsView.centerYAnchor),
            
            loginButton.topAnchor.constraint(lessThanOrEqualTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 35),
            
            loginAsGuestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            loginAsGuestButton.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor),
            loginAsGuestButton.heightAnchor.constraint(equalToConstant: 30),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bannerView.topAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor),
            bannerView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        emailTextField.rx.text.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: viewModel.password).disposed(by: disposeBag)
        viewModel.emailValidationError.bind(to: emailValidationErrorLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.isConnectedToInternet.subscribe(onNext: { [weak self] isConnectedToInternet in
            DispatchQueue.main.async {
                self?.bannerView.isHidden = isConnectedToInternet
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
            guard isLoginValid, let shipsListViewModel = self?.viewModel.getShipsListViewModel(isGuest) else { return }
            let shipsListViewController = ShipsListViewController(viewModel: shipsListViewModel)
            self?.navigationController?.pushViewController(shipsListViewController, animated: true)
        }
    }
}
