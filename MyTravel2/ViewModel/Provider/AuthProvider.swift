//
//  AuthProvider.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

protocol AuthProvider {
	func doLogin(toEmail email: String, withPassword password: String) async -> Result<Bool, Error>
}

struct AuthAPIProvider: AuthProvider {

	struct LoginRequester: Encodable {
		let email: String
		let password: String
	}

	func doLogin(toEmail email: String, withPassword password: String) async -> Result<Bool, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.loginBorderScannerPartner, withParameters:
												LoginRequester(email: email, password: password))
		switch result {
		case .success(let response):
			if response.status == true {
				return .success(true)
			} else {
				return .failure(CustomError.message(response.message))
			}
		case .failure(let error):
			return .failure(error)
		}
	}
}
