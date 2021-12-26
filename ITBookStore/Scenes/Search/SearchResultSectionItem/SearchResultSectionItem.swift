//
//  SearchResultSectionItem.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import RxDataSources
import SwiftUI


enum SearchResultSectionItem {
    case ITBook(_ book: ITBook)
    case loadMore
}

enum SearchResultSectionModel {
    case ITBookSection(title: String, itmes: [SearchResultSectionItem])
    case loadMore(title: String, items: [SearchResultSectionItem])
}

extension SearchResultSectionModel: SectionModelType {
    typealias Item = SearchResultSectionItem
    
    var items: [SearchResultSectionItem] {
        switch self {
        case .ITBookSection(_, let items):
            return items.map { $0 }
        case .loadMore(_, let items):
            return items.map { $0 }
        }
    }
    
    init(original: SearchResultSectionModel, items: [SearchResultSectionItem]) {
        switch original {
        case let .ITBookSection(title: title, itmes: items):
            self = .ITBookSection(title: title, itmes: items)
        case let .loadMore(title: title, items: items):
            self = .loadMore(title: title, items: items)
        }
    }
}
