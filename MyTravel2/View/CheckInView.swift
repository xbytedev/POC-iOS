//
//  CheckInView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct CheckInView: MTAsyncView {
	@State private var searchText: String = ""
	@StateObject private var viewModel: LocationViewModel // = LocationViewModel()

	init(provider: LocationProvider) {
		_viewModel = StateObject(wrappedValue: LocationViewModel(provider: provider))
	}

    var loadedView: some View {
		/*VStack(alignment: .leading) {
			Text("Places")
			HStack {
				Image(R.image.ic_avatar)
					.resizable()
					.renderingMode(.template)
					.frame(width: 24.0, height: 24.0)
					.foregroundColor(AppColor.theme)
				TextField("Search", text: $searchText)
				if !searchText.isEmpty {
					Button {
					} label: {
						Image(R.image.ic_delete)
							.renderingMode(.template)
							.foregroundColor(AppColor.theme)
					}

				}
			}*/
			List {
				Section {
					ForEach(viewModel.places, id: \.self) { place in
						HStack {
							Text(place.name ?? "")
							Spacer()
							Image(R.image.ic_arrowRight)
						}
							.mtListBackgroundStyle()
					}
				}
			}
			.listStyle(.plain)
//		}
//		.padding()
    }

	var state: MTLoadingState {
		viewModel.state
	}

	func load() {
		Task {
			do {
				try await viewModel.getPlaceList()
			} catch {
			}

		}
	}
}

#if DEBUG
struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView(provider: LocationSuccessProvider())
    }
}
#endif
