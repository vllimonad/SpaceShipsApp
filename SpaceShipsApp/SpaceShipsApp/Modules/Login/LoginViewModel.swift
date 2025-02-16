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
    var email = PublishRelay<String?>()
    var password = PublishRelay<String?>()
    var emailValidationError = PublishRelay<String?>()
    
    private let disposeBag = DisposeBag()
    
    init() {
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
}
