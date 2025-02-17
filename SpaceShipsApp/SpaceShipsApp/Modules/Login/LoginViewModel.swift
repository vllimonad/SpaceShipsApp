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
    func validateLogin(_ isGuest: Bool) -> Bool
}

final class LoginViewModel: LoginViewModelProtocol {
    private let keychainManager: KeychainFetchable
    private let disposeBag = DisposeBag()
    
    var email = BehaviorRelay<String?>(value: nil)
    var password = BehaviorRelay<String?>(value: nil)
    var emailValidationError = BehaviorRelay<String?>(value: nil)
    
    init(keychainManager: KeychainFetchable = KeychainManager()) {
        self.keychainManager = keychainManager
        setupBindings()
    }
    
    private func setupBindings() {
        email.asObservable().subscribe(onNext: { [weak self] in
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
}
