//
//  PlaceDetailPreviewProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 26/07/23.
//

import Foundation

struct PlaceDetailSuccessProvider: PlaceDetailProvider {
	func getPlaceDetail(place: MTPlace) async -> Result<MTPlaceDetail, Error> {
		.success(.preview)
	}

	func checkIn(group: MTGroup, to place: MTPlace) async -> Result<Void, Error> {
		.success(())
	}

	func checkIndividual(with code: Int) async -> Result<MTTempTraveler, Error> {
		.success(.preview)
	}

	func checkIn(code: Int, to place: MTPlace) async -> Result<Void, Error> {
		.success(())
	}
}

struct PlaceDetailFailureProvider: PlaceDetailProvider {
	func getPlaceDetail(place: MTPlace) async -> Result<MTPlaceDetail, Error> {
		.failure(CustomError.message("Mock Failure"))
	}

	func checkIn(group: MTGroup, to place: MTPlace) async -> Result<Void, Error> {
		.failure(CustomError.message("Mock Failure"))
	}

	func checkIndividual(with code: Int) async -> Result<MTTempTraveler, Error> {
		.failure(CustomError.message("Mock Failure"))
	}

	func checkIn(code: Int, to place: MTPlace) async -> Result<Void, Error> {
		.failure(CustomError.message("Mock Failure"))
	}
}
