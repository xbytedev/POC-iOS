//
//  MTSegmentView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 17/07/23.
//

import SwiftUI

struct MTSegmentView: View {
	enum SegmentItem: String, CaseIterable, Identifiable {
		var id: String {
			rawValue
		}

		case places = "Places"
		case checkIns = "Check-ins"
	}
	@State private var tabs = SegmentItem.allCases
	@State private var selection: SegmentItem = .places
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
			GeometryReader { geometryProxy in
				RoundedRectangle(cornerRadius: geometryProxy.size.height/2.0)
					.stroke(AppColor.theme, lineWidth: 2)
			}
		})
		.clipShape(Capsule())
    }

	private func tabView(tab: SegmentItem) -> some View {
		Text(tab.rawValue)
			.foregroundColor(selection == tab ? AppColor.Text.tertiary : AppColor.theme)
			.padding()
			.frame(maxWidth: .infinity)
			.myBackground {
				ZStack {
					if selection == tab {
						GeometryReader { geometryProxy in
							RoundedRectangle(cornerRadius: geometryProxy.size.height / 2.0)
								.foregroundColor(AppColor.theme)
								.matchedGeometryEffect(id: "background_segment", in: namespace)
						}
					}
				}
			}
//			.background(selection == tab ? AppColor.theme : Color.clear)
			.clipShape(Capsule())
	}

	func switchToTab(tab: SegmentItem) {
		withAnimation {
			selection = tab
		}
	}
}

struct MTSegmentView_Previews: PreviewProvider {
    static var previews: some View {
        MTSegmentView()
    }
}
