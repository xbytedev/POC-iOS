//
//  AuthViewModel.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
	private let provider: AuthProvider
	var cancellable: Cancellable?
	var user: WebUser?

	init(provider: AuthProvider) {
		self.provider = provider
	}

	func doLogin(email: String, password: String) async throws -> WebUser {
		let user = try await provider.doLogin(toEmail: email, withPassword: password).get()
		self.user = user
		return user
	}

	func resendLoginOTP() async throws -> Bool {
		let result = await provider.doResendLoginOTP(user: user)
		return try result.get()
	}

	func otpVerification(otp: String) async throws {
		let result = await provider.verify(user: user, otp: otp)
		_ = try result.get()
	}
}
