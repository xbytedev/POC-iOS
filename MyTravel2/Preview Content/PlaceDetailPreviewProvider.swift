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
}

struct PlaceDetailFailureProvider: PlaceDetailProvider {
	func getPlaceDetail(place: MTPlace) async -> Result<MTPlaceDetail, Error> {
		.failure(CustomError.message("Mock Failure"))
	}
}
