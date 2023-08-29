//
//  CheckInPreviewProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 25/08/23.
//

import Foundation

struct CheckInSuccessProvider: CheckInProvider {
	func getCheckInTravellerList() async -> Result<[MTCheckInTraveller], Error> {
		return .success([.preview])
	}
	func getCheckInPeopleDetails(
		from checkInTraveller: MTCheckInTraveller) async -> Result<MTCheckInTravellerDetail, Error> {
			return .success(.preview)
		}
}

struct CheckInFailureProvider: CheckInProvider {
	func getCheckInTravellerList() async -> Result<[MTCheckInTraveller], Error> {
		.failure(CustomError.message("Mock Failure"))
	}
	func getCheckInPeopleDetails(
		from checkInTraveller: MTCheckInTraveller) async -> Result<MTCheckInTravellerDetail, Error> {
			.failure(CustomError.message("Mock Failure"))
		}
}
