//
//  AuthViewModel.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

class AuthViewModel {
	private let provider: AuthProvider

	init(provider: AuthProvider) {
		self.provider = provider
	}

	func doLogin(email: String, password: String) async throws -> Bool {
		try await provider.doLogin(toEmail: email, withPassword: password).get()
	}
}
