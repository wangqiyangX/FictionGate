import Foundation

struct Book: Identifiable {
    let id = UUID()
    let name: String
    let author: String
    let coverURL: String? = nil
    let lastChapter: String
}
