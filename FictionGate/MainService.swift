import Alamofire
import Foundation
import SwiftSoup

class MainService {
    static let shared = MainService()

    private init() {}

    func getFunction(
        for type: RuleItemFunctionType,
        from element: Element?,
        attrKey: String
    ) -> String? {
        switch type {
        case .html:
            try? element?.html()
        case .attr:
            try? element?.attr(attrKey)
        case .text:
            try? element?.text()
        }
    }

    func fetchNextPageURL(url: String, _ nextPageURLRule: RuleItem) async throws
        -> String
    {
        let response = try await AF.request(url).serializingString()
            .value
        let doc = try SwiftSoup.parse(response)

        let nextPageElement = try doc.select(nextPageURLRule.selector)
            .first()

        let nextPageURL = getFunction(
            for: nextPageURLRule.function ?? .text,
            from: nextPageElement,
            attrKey: nextPageURLRule.parameters ?? ""
        )

        return nextPageURL ?? ""
    }

    func fetchBookList(_ pageRule: PageRule, url: String) async throws
        -> [ItemInfo]
    {
        let response = try await AF.request(url).serializingString()
            .value
        let doc = try SwiftSoup.parse(response)

        var items: [ItemInfo] = []

        // Select the book list elements
        let bookElements = try doc.select(
            pageRule.itemsRule.selector
        )

        let itemInfoRule = pageRule.itemInfoRule

        for element in bookElements {
            let nameElement = try element.select(itemInfoRule.name.selector)
                .first()
            let urlElement = try element.select(itemInfoRule.url.selector)
                .first()
            let authorElement = try element.select(itemInfoRule.author.selector)
                .first()
            let lastChapterElement = try element.select(
                itemInfoRule.coverURL.selector
            ).first()

            if let name = getFunction(
                for: itemInfoRule.name.function ?? .text,
                from: nameElement,
                attrKey: itemInfoRule.name.parameters ?? ""
            ),
                let url = getFunction(
                    for: itemInfoRule.url.function ?? .text,
                    from: urlElement,
                    attrKey: itemInfoRule.url.parameters ?? ""
                ),
                let author = try authorElement?.text(),
                let lastChapter = try lastChapterElement?.text()
            {
                let item = ItemInfo(
                    name: name,
                    url: url,
                    author: author,
                    lastChapter: lastChapter,
                )
                items.append(item)
            }
        }

        return items
    }
}
