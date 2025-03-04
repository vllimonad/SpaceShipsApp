//
//  LoginViewModel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 16/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelProtocol {
    var email: BehaviorRelay<String?> { get }
    var password: BehaviorRelay<String?> { get }
    var emailValidationError: BehaviorRelay<String?> { get }
    var isConnectedToInternet: BehaviorRelay<Bool> { get }
    
    func validateLogin(_ isGuest: Bool) -> Bool
    func getShipsListViewModel(_ isGuest: Bool) -> ShipsListViewModel
}

final class LoginViewModel: LoginViewModelProtocol {
    private let keychainManager: KeychainFetchable
    private let networkConnectionManager: NetworkConnectionManagable
    private let disposeBag = DisposeBag()
    
    var email = BehaviorRelay<String?>(value: nil)
    var password = BehaviorRelay<String?>(value: nil)
    var emailValidationError = BehaviorRelay<String?>(value: nil)
    var isConnectedToInternet = BehaviorRelay<Bool>(value: true)
    
    init(keychainManager: KeychainFetchable = KeychainManager(), networkConnectionManager: NetworkConnectionManagable) {
        self.keychainManager = keychainManager
        self.networkConnectionManager = networkConnectionManager
        setupBindings()
    }
    
    private func setupBindings() {
        networkConnectionManager.isConnected.bind(to: isConnectedToInternet).disposed(by: disposeBag)
        
        email.subscribe(onNext: { [weak self] in
            guard let input = $0, !input.isEmpty else { return }
            self?.validateEmail(input)
        }).disposed(by: disposeBag)
    }
    
    private func validateEmail(_ email: String) {
        let regex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
        let validationError = predicate.evaluate(with: email) ? nil : "Invalid email"
        emailValidationError.accept(validationError)
    }
}
    
extension LoginViewModel {
    func validateLogin(_ isGuest: Bool) -> Bool {
        guard !isGuest else { return true }
        guard emailValidationError.value == nil,
              let email = email.value,
              let password = password.value,
              let fetchedPassword = keychainManager.fetchPassword(for: email),
              password == fetchedPassword
        else { return false }
        return true
    }
    
    func getShipsListViewModel(_ isGuest: Bool) -> ShipsListViewModel {
        let userStatusManager = UserStatusManager(isGuest: isGuest, userEmail: email.value)
        return ShipsListViewModel(networkConnectionManager: networkConnectionManager, userStatusManager: userStatusManager)
    }
}
