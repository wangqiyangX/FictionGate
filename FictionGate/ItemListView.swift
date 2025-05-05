//
// ItemListView.swift.swift
// FictionGate
//
// Copyright © 2025 wangqiyangX.
// All Rights Reserved.
//

import SwiftUI

struct ItemListView: View {
    let xuanhuanPage = PageRule(
        url: "xiaoshuo/xuanhuan_1/",
        name: "玄幻小说",
        nextPageURLRule: .init(
            selector: "#pagelink > a:nth-last-child(2)",
            function: .attr,
            parameters: "href"
        ),
        itemsRule: .init(
            selector:
                "body > div.container > div:nth-child(2) > div.layout.layout2.layout-col2 > ul > li"
        ),
        itemInfoRule: ItemInfoRule(
            name: .init(selector: "span.s2 > a"),
            url: .init(
                selector: "span.s2 > a",
                function: .attr,
                parameters: "href"
            ),
            author: .init(selector: "span.s4"),
            coverURL: .init(selector: "span.s3 > a")
        )
    )

    var viewModel = ItemListViewModel()

    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.items) { item in
                        NavigationLink {
                            Text(item.url)
                        } label: {
                            LabeledContent {
                                
                            } label: {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.author)
                                Text(item.lastChapter)
                            }
                        }
                        .onAppear {
                            if item.id == viewModel.items.last?.id {
                                Task {
                                    await viewModel.fetchItems(
                                        xuanhuanPage,
                                        isFirstPage: false
                                    )
                                }
                            }
                        }
                    }
                } header: {
                    Text("^[\(viewModel.items.count) book](inflect: true)")
                } footer: {
                    if viewModel.isLoading {
                        Text("Loading...")
                    } else if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(xuanhuanPage.name)
            .onAppear {
                Task {
                    await viewModel.fetchItems(xuanhuanPage)
                }
            }
            .refreshable {
                Task {
                    await viewModel.fetchItems(xuanhuanPage)
                }
            }
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    ItemListView()
}
