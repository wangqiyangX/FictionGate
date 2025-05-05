import Foundation
import SwiftUI

@Observable
class ItemListViewModel: ObservableObject {
    var items: [ItemInfo] = []
    var isLoading = false
    var nextPageUrl = ""
    var error: Error?

    private let bookService = MainService.shared

    func fetchItems(_ pageRule: PageRule, isFirstPage: Bool = true) async {
        withAnimation {
            isLoading = true
        }
        error = nil

        do {
            nextPageUrl = try await bookService.fetchNextPageURL(
                url: "https://www.xbiqu6.com/" + pageRule.url,
                pageRule.nextPageURLRule
            )
            let newBooks = try await bookService.fetchBookList(
                pageRule,
                url: "https://www.xbiqu6.com/"
                    + (isFirstPage ? pageRule.url : nextPageUrl)
            )
            if !isFirstPage {
                items.append(
                    contentsOf: newBooks
                )
            } else {
                items = newBooks
            }
        } catch {
            self.error = error
        }

        withAnimation {
            isLoading = false
        }
    }

    func searchBooks(_ text: String) async {
    }
}
