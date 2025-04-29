import Foundation

@Observable
class ItemListViewModel: ObservableObject {
    var books: [ItemInfo] = []
    var isLoading = false
    var error: Error?

    private let bookService = MainService.shared

    func fetchBooks(_ pageRule: PageRule) async {
        isLoading = true
        error = nil

        do {
            books = try await bookService.fetchBookList(pageRule)
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
