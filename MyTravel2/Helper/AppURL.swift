//
//  AppURL.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

struct APPURL {
	private static let apiBaseURL: String = {
		guard let scheme: String = try? MTConfiguration.value(for: Key.Config.apiBaseScheme),
			  let url: String = try? MTConfiguration.value(for: Key.Config.apiBaseURL),
			  let path: String = try? MTConfiguration.value(for: Key.Config.apiPath) else {
			return ""
		}
		var urlComponents = URLComponents()
		let components = url.components(separatedBy: ":")

		urlComponents.scheme = scheme
		if components.count > 1 {
			urlComponents.host = components.first
			if let port = Int(components.last ?? "") {
				urlComponents.port = port
			}
		} else {
			urlComponents.host = url
		}
		urlComponents.path = path
		if let url = urlComponents.url {
			return url.absoluteString + "/"
		} else {
			return ""
		}
	}()

	static var loginBorderScannerPartner: String {
		 apiBaseURL + "login_border_scanner_partner"
	}

	static var resendLoginOTP: String {
		apiBaseURL + "resend_login_otp"
	}

	static var borderScannerPartnerCheckOtp: String {
		apiBaseURL + "border_scanner_partner_check_otp"
	}

	static var createGroup: String {
		apiBaseURL + "create_group"
	}

	static var groupList: String {
		apiBaseURL + "group_list"
	}

	static var groupPeopleList: String {
		apiBaseURL + "group_people_list"
	}
}
