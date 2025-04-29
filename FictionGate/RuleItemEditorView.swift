//
// RuleItemEditorView.swift.swift
// FictionGate
//
// Copyright © 2025 wangqiyangX.
// All Rights Reserved.
//

import SwiftUI

struct RuleItemEditorView: View {
    let titleKey: LocalizedStringKey
    let rule: RuleItem?

    init(_ titleKey: LocalizedStringKey, rule: RuleItem?) {
        self.titleKey = titleKey
        self.rule = rule
    }

    @State private var selector: String = ""
    @State private var function: String = ""
    @State private var parameters: String = ""
    @State private var regex: String = ""
    @State private var replace: String = ""

    @State private var isExpanded: Bool = true

    var body: some View {
        Section(titleKey, isExpanded: $isExpanded) {
            TextField("Selector", text: $selector)
            TextField("Function", text: $function)
            TextField("Parameters", text: $parameters)
            TextField("Regex", text: $regex)
            TextField("Replace", text: $replace)
        }
    }
}

#Preview {
    RuleItemEditorView("Item", rule: RuleItem(selector: "div"))
}
