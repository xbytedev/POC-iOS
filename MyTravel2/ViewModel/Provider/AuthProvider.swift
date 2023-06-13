//
//  AuthProvider.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

protocol AuthProvider {
	func doLogin(toEmail email: String, withPassword password: String) async -> Result<WebUser, Error>
	func doResendLoginOTP(user: WebUser) async -> Result<Bool, Error>
	func verify(user: WebUser, otp: String) async -> Result<WebUser, Error>
}

struct AuthAPIProvider: AuthProvider {

	struct LoginRequester: Encodable {
		let email: String
		let password: String
	}

	struct ResendLoginOTPRequester {
		let userID: Int
	}

	struct VerifyOTPRequester {
		let userID: Int
		let otp: String
	}

	func doLogin(toEmail email: String, withPassword password: String) async -> Result<WebUser, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.loginBorderScannerPartner, withParameters:
												LoginRequester(email: email, password: password))
		switch result {
		case .success(let response):
			if response.status == true {
				MTUserDefaults.lastOTPSendDate = Date()
				if let userID = response.userID {
					let user = WebUser(id: userID, name: "", email: email, emailVerifiedAt: "", viewPassword: password, ipAddress: "",
									   lastLoginDateTime: "", role: "", number: "", createdBy: "", image: "", location: "",
									   businessName: "", businessType: "", businessLogo: "", country: "", state: "", city: "",
									   address: "", status: "", documentName: "", documentImage: "", otp: 0, createdAt: "", updatedAt: "")

					return .success(user)
				} else {
					return .failure(CustomError.message(R.string.localizable.requestSucceedNoData()))
				}
			} else {
				return .failure(CustomError.message(response.message ?? ""))
			}
		case .failure(let error):
			return .failure(error)
		}
	}

	func doResendLoginOTP(user: WebUser) async -> Result<Bool, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.resendLoginOTP,
											 withParameters: ResendLoginOTPRequester(userID: user.id))
		switch result {
		case .success(let response):
			if response.status == true {
				MTUserDefaults.lastOTPSendDate = Date()
				return .success(true)
			} else {
				return .failure(CustomError.message(response.message ?? ""))
			}
		case .failure(let error):
			return .failure(getOriginalErrorIfAny(error))
		}
	}

	func verify(user: WebUser, otp: String) async -> Result<WebUser, Error> {
		let requester = WebRequester<CheckOTPResponse>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.borderScannerPartnerCheckOtp,
											 withParameters: VerifyOTPRequester(userID: user.id, otp: otp))
		switch result {
		case .success(let response):
			if response.status == true {
				if let loggedInUser = response.data {
					MTUserDefaults.currentUser = loggedInUser
					MTKeychainWrapper.authToken = response.token
					WebRequesterSessionProvider.authStorage.refreshToken()
					return .success(loggedInUser)
				} else {
					return .failure(CustomError.successButNoData)
				}
			} else {
				return .failure(CustomError.message(response.message ?? ""))
			}
		case .failure(let error):
			return .failure(getOriginalErrorIfAny(error))
		}
	}
}

extension AuthAPIProvider.ResendLoginOTPRequester: Encodable {
	enum CodingKeys: String, CodingKey {
		case userID = "user_id"
	}
}

extension AuthAPIProvider.VerifyOTPRequester: Encodable {
	enum CodingKeys: String, CodingKey {
		case userID = "user_id"
		case otp
	}
}
