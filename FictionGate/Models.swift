import Foundation

struct ItemInfo: Identifiable {
    let id = UUID()
    let name: String
    let url: String
    let author: String
    let coverURL: String? = nil
    let lastChapter: String
}

enum RuleItemFunctionType: String, CaseIterable, Identifiable {
    case html
    case attr
    case text
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .html:
            "html"
        case .attr:
            "attr"
        case .text:
            "text"
        }
    }
}

struct RuleItem {
    var selector: String
    var function: RuleItemFunctionType?
    var parameters: String?
    var regex: String?
    var replace: String?
}

struct SourceRule {
    var name: String
    var sourceURL: String
    var version: String = "0.0.1"
    var pageRules: [PageRule]
}

struct PageRule {
    var url: String
    var name: String
    var itemsRule: RuleItem
    var itemInfoRule: ItemInfoRule
}

struct ItemInfoRule {
    let name: RuleItem
    let url: RuleItem
    let author: RuleItem
    let coverURL: RuleItem
}
