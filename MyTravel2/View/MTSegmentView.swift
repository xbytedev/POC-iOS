//
//  MTSegmentView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 17/07/23.
//

import SwiftUI

enum SegmentItem: String, CaseIterable, Identifiable {
	var id: String {
		rawValue
	}

	case places = "Places"
	case checkIns = "Check-ins"
}

struct MTSegmentView: View {
	@State private var tabs = SegmentItem.allCases
	@Binding var selection: SegmentItem
	@Namespace var namespace

    var body: some View {
		HStack {
			ForEach(tabs) { tab in
				tabView(tab: tab)
					.onTapGesture {
						switchToTab(tab: tab)
					}
			}
		}
		.myOverlay(overlayView: {
			Capsule()
				.stroke(lineWidth: 2)
				.foregroundColor(AppColor.theme)

		})
		.clipShape(Capsule())
    }

	@ViewBuilder private func tabView(tab: SegmentItem) -> some View {
		if selection == tab {
			segmentTitleView(tab: tab)
				.myBackground {
					ZStack {
						GeometryReader { geometryProxy in
							RoundedRectangle(cornerRadius: geometryProxy.size.height / 2.0)
								.foregroundColor(AppColor.theme)
								.matchedGeometryEffect(id: "background_segment", in: namespace)
						}
					}
				}
		} else {
			segmentTitleView(tab: tab)
		}
	}

	private func segmentTitleView(tab: SegmentItem) -> some View {
		Text(tab.rawValue)
			.foregroundColor(selection == tab ? AppColor.Text.tertiary : AppColor.theme)
			.padding(8)
			.frame(maxWidth: .infinity)
	}

	func switchToTab(tab: SegmentItem) {
		withAnimation {
			selection = tab
		}
	}
}

struct MTSegmentView_Previews: PreviewProvider {
    static var previews: some View {
		MTSegmentView(selection: .constant(.checkIns))
    }
}
