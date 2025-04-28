import Foundation

@Observable
class BookListViewModel: ObservableObject {
    var books: [Book] = []
    var isLoading = false
    var error: Error?

    private let bookService = BookService.shared

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
