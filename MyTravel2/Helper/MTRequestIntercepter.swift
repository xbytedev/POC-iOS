//
//  MTRequestIntercepter.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation
import Alamofire

protocol TokenProvider {
	var accessToken: String? { get set }
}

final class KeychainStorage: TokenProvider {
	var accessToken: String?

	init() {
		accessToken = MTKeychainWrapper.authToken
	}

	func refreshToken() {
		accessToken = MTKeychainWrapper.authToken
	}
}

struct MTRequestInterceptor: RequestInterceptor {
	enum RequestInterceptorError: Error {
		case noURL
		case noAccessToken
		case noUser
	}
	let tokenProvider: TokenProvider
	private let noAuthURLs = [
		APPURL.loginBorderScannerPartner,
		APPURL.resendLoginOTP,
		APPURL.borderScannerPartnerCheckOtp
	]

	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		guard let url = urlRequest.url else {
			completion(.failure(RequestInterceptorError.noURL))
			return
		}
		// Some URLs doesn't need authentication
		if noAuthURLs.contains(url.absoluteString) {
			completion(.success(urlRequest))
			return
		}

		var updatedURLRequest = urlRequest
		guard let user = MTUserDefaults.currentUser else {
			completion(.failure(RequestInterceptorError.noUser))
			return
		}
		guard let accessToken = tokenProvider.accessToken else {
			completion(.failure(RequestInterceptorError.noAccessToken))
			return
		}
		updatedURLRequest.headers.add(HTTPHeader(name: "token", value: accessToken))
		updatedURLRequest.headers.add(HTTPHeader(name: "id", value: NSNumber(value: user.id).stringValue))
		completion(.success(updatedURLRequest))
	}
}

extension MTRequestInterceptor.RequestInterceptorError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .noAccessToken: return "No access token found"
		case .noURL: return "No URL found"
		case .noUser: return "No User found"
		}
	}
}
