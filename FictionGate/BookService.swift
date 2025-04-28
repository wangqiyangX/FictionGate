import Alamofire
import Foundation
import SwiftSoup

class BookService {
    static let shared = BookService()

    private init() {}

    func fetchBookList(_ pageRule: PageRule) async throws -> [Book] {
        let response = try await AF.request(pageRule.url).serializingString()
            .value
        let doc = try SwiftSoup.parse(response)

        var books: [Book] = []

        // Select the book list elements
        let bookElements = try doc.select(
            pageRule.itemsRule.selector
        )

        let itemInfoRule = pageRule.itemInfoRule

        for element in bookElements {
            let titleElement = try element.select(itemInfoRule.author.selector)
                .first()
            let authorElement = try element.select(itemInfoRule.author.selector)
                .first()
            let lastChapterElement = try element.select(
                itemInfoRule.coverURL.selector
            ).first()

            if let title = try titleElement?.text(),
                let author = try authorElement?.text(),
                let lastChapter = try lastChapterElement?.text()
            {
                let book = Book(
                    name: title,
                    author: author,
                    lastChapter: lastChapter,
                )
                books.append(book)
            }
        }

        return books
    }
}
