import Foundation
import Testing
@testable import SwiftWidgets
import SwiftUI

struct CustomError: Error {
    let message: String
}

@Test func testContentUnavailableViewErrorGeneric() async throws {
    let customError = CustomError(message: "Custom error occurred")
    let view = ContentUnavailableView.error(customError)
    #expect(view != nil)
}

@Test func testContentUnavailableViewErrorEmpty() async throws {
    let emptyError = ContentUnavailableError.empty
    let view = ContentUnavailableView.error(emptyError)
    #expect(view != nil)
}

@Test func testContentUnavailableViewErrorWithCustomTitle() async throws {
    let customError = CustomError(message: "Custom error occurred")
    let titleKey: LocalizedStringKey = "NetworkError"
    let view = ContentUnavailableView.error(customError, title: titleKey)
    #expect(view != nil)
}

@Test func testContentUnavailableViewErrorWithStringProtocolTitle() async throws {
    let customError = CustomError(message: "Custom error occurred")
    let dynamicTitle: String = "Dynamic Error Title"
    let view = ContentUnavailableView.error(customError, title: dynamicTitle)
    #expect(view != nil)
}

@Test func testContentUnavailableViewEmptyWithItem() async throws {
    let view = ContentUnavailableView.empty(item: "Channels") {
        try await Task.sleep(nanoseconds: 100_000)
    }
    #expect(view != nil)
}

@Test func testContentUnavailableViewEmptyWithItemKey() async throws {
    let key: LocalizedStringKey = "Channels"
    let view = ContentUnavailableView.empty(item: key) {
        try await Task.sleep(nanoseconds: 100_000)
    }
    #expect(view != nil)
}

@Test func testContentUnavailableViewEmptyWithStringProtocolItem() async throws {
    let dynamicItem: String = "Dynamic Item"
    let view = ContentUnavailableView.empty(item: dynamicItem) {
        try await Task.sleep(nanoseconds: 100_000)
    }
    #expect(view != nil)
}

@Test func testLocalizationDefaultEnglish() async throws {
    guard let path = Bundle.module.path(forResource: "en", ofType: "lproj"),
          let enBundle = Bundle(path: path) else {
        #expect(Bool(false), "English lproj bundle missing")
        return
    }
    
    let retryStr = enBundle.localizedString(forKey: "Retry", value: nil, table: nil)
    #expect(retryStr == "Retry")
    
    let confirmStr = enBundle.localizedString(forKey: "Confirm", value: nil, table: nil)
    #expect(confirmStr == "Confirm")
    
    let errorStr = enBundle.localizedString(forKey: "Something went wrong", value: nil, table: nil)
    #expect(errorStr == "Something went wrong")
}

@Test func testLocalizationSimplifiedChinese() async throws {
    guard let path = Bundle.module.path(forResource: "zh-Hans", ofType: "lproj"),
          let zhBundle = Bundle(path: path) else {
        #expect(Bool(false), "Simplified Chinese lproj bundle missing")
        return
    }
    
    let retryStr = zhBundle.localizedString(forKey: "Retry", value: nil, table: nil)
    #expect(retryStr == "重试")
    
    let confirmStr = zhBundle.localizedString(forKey: "Confirm", value: nil, table: nil)
    #expect(confirmStr == "确定")
    
    let cancelStr = zhBundle.localizedString(forKey: "Cancel", value: nil, table: nil)
    #expect(cancelStr == "取消")

    let errorStr = zhBundle.localizedString(forKey: "Something went wrong", value: nil, table: nil)
    #expect(errorStr == "出错了")
    
    let noContentStr = zhBundle.localizedString(forKey: "No Content", value: nil, table: nil)
    #expect(noContentStr == "暂无内容")
}

@Test func testLocalizationJapanese() async throws {
    guard let path = Bundle.module.path(forResource: "ja", ofType: "lproj"),
          let jaBundle = Bundle(path: path) else {
        #expect(Bool(false), "Japanese lproj bundle missing")
        return
    }
    
    let retryStr = jaBundle.localizedString(forKey: "Retry", value: nil, table: nil)
    #expect(retryStr == "再試行")
    
    let confirmStr = jaBundle.localizedString(forKey: "Confirm", value: nil, table: nil)
    #expect(confirmStr == "確認")
}

@Test func testLocalizationGerman() async throws {
    guard let path = Bundle.module.path(forResource: "de", ofType: "lproj"),
          let deBundle = Bundle(path: path) else {
        #expect(Bool(false), "German lproj bundle missing")
        return
    }
    
    let retryStr = deBundle.localizedString(forKey: "Retry", value: nil, table: nil)
    #expect(retryStr == "Wiederholen")
    
    let cancelStr = deBundle.localizedString(forKey: "Cancel", value: nil, table: nil)
    #expect(cancelStr == "Abbrechen")
}

@Test func testLocalizationTraditionalChinese() async throws {
    guard let path = Bundle.module.path(forResource: "zh-Hant", ofType: "lproj"),
          let hantBundle = Bundle(path: path) else {
        #expect(Bool(false), "Traditional Chinese lproj bundle missing")
        return
    }
    
    let retryStr = hantBundle.localizedString(forKey: "Retry", value: nil, table: nil)
    #expect(retryStr == "重試")
    
    let refreshStr = hantBundle.localizedString(forKey: "Refresh", value: nil, table: nil)
    #expect(refreshStr == "重新整理")
}
