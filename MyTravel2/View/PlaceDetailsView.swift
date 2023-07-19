//
//  PlaceDetailsView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import SwiftUI

struct PlaceDetailsView: View {
    var body: some View {
		GeometryReader { geometryProxy in
			VStack {
				Image(R.image.img_setupGroup)
					.resizable()
					.aspectRatio(16/9.0, contentMode: .fill)
					.frame(height: 120)
					.offset(y: 8)
					.padding(.horizontal)
				AppColor.theme
					.background(AppColor.theme)
					.cornerRadius(32)
					.shadow(radius: 8, y: -4)
			}
			.ignoresSafeArea(edges: .bottom)
		}
			.navigationTitle("Places")
			.setThemeBackButton()
    }
}

struct PlaceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailsView()
    }
}
