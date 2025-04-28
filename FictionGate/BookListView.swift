//
// BookListView.swift.swift
// FictionGate
//
// Copyright © 2025 wangqiyangX.
// All Rights Reserved.
//

import SwiftUI

struct RuleItem {
    var selector: String
    var function: String?
    var parameters: String?
    var regex: String?
    var replace: String?
}

struct PageRule {
    var url: String
    var name: String
    var itemsRule: RuleItem
    var itemInfoRule: ItemInfoRule
}

struct ItemInfoRule {
    let name: RuleItem
    let author: RuleItem
    let coverURL: RuleItem
}

struct BookListView: View {
    let xuanhuanPage = PageRule(
        url: "https://www.xbiqu6.com/xiaoshuo/xuanhuan_1/",
        name: "玄幻小说",
        itemsRule: .init(
            selector:
                "body > div.container > div:nth-child(2) > div.layout.layout2.layout-col2 > ul > li"
        ),
        itemInfoRule: ItemInfoRule(
            name: .init(selector: "span.s2 > a"),
            author: .init(selector: "span.s4"),
            coverURL: .init(selector: "span.s3 > a")
        )
    )
    @StateObject private var viewModel = BookListViewModel()

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
            .navigationTitle("Books")
            .task {
                await viewModel.fetchBooks(xuanhuanPage)
            }
        }
    }
}

#Preview {
    BookListView()
}
