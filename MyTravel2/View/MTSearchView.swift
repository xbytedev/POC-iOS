//
//  MTSearchView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/08/23.
//

import SwiftUI

struct MTSearchView: View {
	@Binding var searchText: String
    var body: some View {
		HStack {
			Image(R.image.ic_search)
				.resizable()
				.renderingMode(.template)
				.frame(width: 24.0, height: 24.0)
				.foregroundColor(AppColor.theme)
			TextField(R.string.localizable.search(), text: $searchText)
			if !searchText.isEmpty {
				Button {
					searchText = ""
				} label: {
					Image(R.image.ic_cancel)
				}

			}
		}
		.padding(.vertical, 8)
		.padding(.horizontal, 12)
		.myBackground {
			RoundedRectangle(cornerRadius: 12)
				.foregroundColor(AppColor.Background.white)
				.shadow(radius: 8, y: 4)
		}
    }
}

struct MTSearchView_Previews: PreviewProvider {
	struct ContainerView: View {
		@State var txtSearch: String = ""
		var body: some View {
			MTSearchView(searchText: $txtSearch)
		}
	}
    static var previews: some View {
		ContainerView()
    }
}
