//
//  LoginViewModel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 16/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    var email = BehaviorRelay<String?>(value: nil)
    var password = BehaviorRelay<String?>(value: nil)
    var emailValidationError = BehaviorRelay<String?>(value: nil)
    
    private let keychainManager: KeychainFetchable
    private let disposeBag = DisposeBag()
    
    init(keychainManager: KeychainFetchable = KeychainManager()) {
        self.keychainManager = keychainManager
        setupBindings()
    }
    
    private func setupBindings() {
        email.asObservable().subscribe(onNext: { [weak self] in
            guard let input = $0 else { return }
            self?.validateEmail(input)
        }).disposed(by: disposeBag)
    }
    
    private func validateEmail(_ email: String) {
        let regex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
        let validationError = predicate.evaluate(with: email) ? nil : "Invalid email"
        emailValidationError.accept(validationError)
    }
    
    func validateLogin() -> Bool {
        //guard let _ = emailValidationError.value,
              guard let email = email.value,
              let password = password.value,
              let fetchedPassword = keychainManager.fetchPassword(for: email),
              password == fetchedPassword
        else { return false }
        return true
    }
}
