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
        url: "https://www.xbiqu6.com/xiaoshuo/xuanhuan_1/",
        name: "玄幻小说",
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
    @StateObject private var viewModel = ItemListViewModel()

    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    ForEach(viewModel.books) { book in
                        NavigationLink {
                            Text(book.url)
                        } label: {
                            LabeledContent {
                                Text(book.author)
                            } label: {
                                Text(book.name)
                                    .font(.headline)
                                Text(book.lastChapter)
                            }
                        }

                    }
                }
            }
            .navigationTitle("Books")
            .task {
                await viewModel.fetchBooks(xuanhuanPage)
            }
        }
    }
}

#Preview {
    ItemListView()
}
