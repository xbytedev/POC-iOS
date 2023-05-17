//
//  WebUser.swift
//  MyTravel
//
//  Created by Xuser on 16/05/23.
//

import Foundation

struct WebUser: Codable {
	var id: Int
	let name, email: String
	let emailVerifiedAt: String?
	let viewPassword: String
	let ipAddress, lastLoginDateTime: String?
	let role, number: String
	let createdBy: String?
	let image, location, businessName, businessType: String
	let businessLogo, country, state, city: String
	let address, status, documentName, documentImage: String
	let otp: Int
	let createdAt, updatedAt: String

	enum CodingKeys: String, CodingKey {
		case id, name, email
		case emailVerifiedAt = "email_verified_at"
		case viewPassword = "view_password"
		case ipAddress = "ip_address"
		case lastLoginDateTime = "last_login_date_time"
		case role, number
		case createdBy = "created_by"
		case image, location
		case businessName = "business_name"
		case businessType = "business_type"
		case businessLogo = "business_logo"
		case country, state, city, address, status
		case documentName = "document_name"
		case documentImage = "document_image"
		case otp
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}
}
