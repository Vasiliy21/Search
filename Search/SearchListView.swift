//
//  SearchListView.swift
//  Search
//
//  Created by Vasiliy on 14.10.2023.
//

import SwiftUI

struct SearchListView: View {

    @ObservedObject var network = NetworkManager()

    private let columns = [
        GridItem(.adaptive(minimum: UIScreen.main.bounds.width - 20))
    ]
    @State var searchText = ""

    var body: some View {
        ZStack {
            Color("List")
                .ignoresSafeArea()
            VStack {
                SearchBarView(searchText: $searchText)
                ScrollViewReader { value in
                    ScrollView(showsIndicators: false) {
                        EmptyView()
                            .id(1)
                        scrollView
                        Rectangle()
                            .frame(height: 60)
                            .padding(.bottom)
                            .opacity(0)
                        Spacer()
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .onChange(of: searchText) { _ in
                        withAnimation {
                            value.scrollTo(1, anchor: .top)
                        }
                    }
                }
                .refreshable {
                    network.fetchNameOfClubs()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView()
    }
}

extension SearchListView {

    private var scrollView: some View {
        LazyVGrid(columns: columns, spacing: 72) {
            ForEach(network.nameOfClubs.uniqued(), id: \.self) {
                club in
                let name = club.name.lowercased()
                if  name.contains(searchText.lowercased()) {
                    CellLabelView(
                        name: club.name,
                        description: club.description,
                        openingHours: club.openingHours,
                        image: club.image,
                        yandexMap: club.yandexMap,
                        appleMap: club.appleMap,
                        phoneNumber: club.phoneNumber,
                        website: club.website
                    )
                } else if searchText == "" {
                    CellLabelView(
                        name: club.name,
                        description: club.description,
                        openingHours: club.openingHours,
                        image: club.image,
                        yandexMap: club.yandexMap,
                        appleMap: club.appleMap,
                        phoneNumber: club.phoneNumber,
                        website: club.website
                    )
                }
            }

        }
        .padding(.top, 35)
    }
}


