//
//  LinkPresentationError.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/08.
//

import Foundation
import LinkPresentation

extension LPError {
  var prettyString: String {
    switch self.code {
    case .metadataFetchCancelled:
      return "링크 패치가 취소되었습니다."
    case .metadataFetchFailed:
      return "알수없는 링크입니다."
    case .metadataFetchTimedOut:
      return "링크 패치 시간이 초과되었습니다."
    case .unknown:
      return "알수없는 링크입니다."
    case .metadataFetchNotAllowed:
        return "링크를 가져올 수 없음니다."
    @unknown default:
      return "알수없는 링크입니다."
    }
  }
}


