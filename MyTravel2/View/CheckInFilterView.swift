//
//  CheckInFilterView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 29/08/23.
//

import SwiftUI

struct CheckInFilterView: View {
	private let minimumDate = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
	@State private var startDate: Date
	@State private var isDateFilterApplied: Bool
	@State private var isPartnerFilterApplied: Bool
	private let maximumDate = Calendar.current.endOfDay(for: Date())
	private let partners: [String]
	@State private var endDate: Date
	@State private var selectedPartner = ""
	@Binding var isPresenting: Bool
	var completionBlock: (ClosedRange<Date>?, _ selectedPartner: String?) -> Void

	init(
		dateFilter: ClosedRange<Date>?, partners: [String], selectedPartner: String?, isPresenting: Binding<Bool>,
		completionBlock: @escaping (ClosedRange<Date>?, _: String?) -> Void) {
			_startDate = State(initialValue: dateFilter?.lowerBound ?? Calendar.current.startOfDay(for: Date()))
			_endDate = State(initialValue: dateFilter?.upperBound ?? Calendar.current.endOfDay(for: Date()))
			_selectedPartner = State(initialValue: selectedPartner ?? "")
			_isDateFilterApplied = State(initialValue: dateFilter != nil)
			_isPartnerFilterApplied = State(initialValue: selectedPartner != nil)
			_isPresenting = isPresenting
			self.completionBlock = completionBlock
			self.partners = partners
		}

	var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
				.opacity(isPresenting ? 0.4 : 0)
				.animation(.easeInOut, value: isPresenting)
			popupView
				.scaleEffect(isPresenting ? 1 : 0)
				.animation(.spring(), value: isPresenting)
				.opacity(isPresenting ? 1 : 0)
		}
	}

    var popupView: some View {
		VStack(spacing: 40) {
			HStack {
				Text(R.string.localizable.filter)
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
					.foregroundColor(AppColor.theme)
				Spacer()
				Button {
					isPresenting = false
				} label: {
					Image(systemName: "xmark")
						.font(.title)
						.aspectRatio(1, contentMode: .fit)
						.padding(8)
						.background(Color.gray)
						.clipShape(Circle())
				}
			}
			VStack(spacing: 32) {
				HStack(spacing: 16) {
					Button(action: dateFilterToggle) {
						isDateFilterApplied ? Image(systemName: "checkmark.circle") : Image(systemName: "circle")
					}
					VStack {
						DatePicker(
							"Start Date", selection: $startDate, in: minimumDate...min(endDate, maximumDate), displayedComponents: [.date])
						DatePicker(
							"End Date", selection: $endDate, in: max(minimumDate, startDate)...maximumDate, displayedComponents: [.date])
					}
					.opacity(isPresenting ? 1 : 0)
				}
				HStack(spacing: 16) {
					Button(action: partnerFilterToggle) {
						isPartnerFilterApplied ? Image(systemName: "checkmark.circle") : Image(systemName: "circle")
					}
					updatedPicker
				}
			}
		}
		.padding(.bottom, 24)
		.modifier(FormModifier())
		.myOverlay(alignment: .bottom) {
			MTButton(
				isLoading: .constant(false), title: R.string.localizable.done(),
				loadingTitle: R.string.localizable.creatingGroup()) {
					let dateFilter = isDateFilterApplied ? startDate...Calendar.current.endOfDay(for: endDate) : nil
					let partnerFilter = isPartnerFilterApplied ? selectedPartner : nil
					completionBlock(dateFilter, partnerFilter)
					isPresenting = false
				}
				.padding(.horizontal, 64)
				.offset(x: 0, y: 20)
		}
		.onChange(of: startDate) { _ in
			isDateFilterApplied = true
		}
		.onChange(of: endDate) { _ in
			isDateFilterApplied = true
		}
		.onChange(of: selectedPartner) { _ in
			isPartnerFilterApplied = true
		}
    }

	@ViewBuilder
	private var updatedPicker: some View {
		if #available(iOS 16.0, *) {
			picker.pickerStyle(.navigationLink)
		} else {
			picker
		}
	}

	private var picker: some View {
		Picker(selection: $selectedPartner) {
			ForEach(partners, id: \.self) { partner in
				Text(partner).tag(partner)
			}
		} label: {
			Text("Partner")
				.font(AppFont.getFont(forStyle: .headline, forWeight: .semibold))
				.foregroundColor(AppColor.Text.primary)
		}
	}

	private func dateFilterToggle() {
		isDateFilterApplied.toggle()
	}

	private func partnerFilterToggle() {
		isPartnerFilterApplied.toggle()
	}
}

struct CheckInFilterView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			CheckInFilterView(
				dateFilter: nil, partners: [""], selectedPartner: nil, isPresenting: .constant(true),
				completionBlock: { _, _ in })
		}
	}
}
