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
      return "Metadata 패치가 취소됨."
    case .metadataFetchFailed:
      return "Metadata 패치가 실패됨."
    case .metadataFetchTimedOut:
      return "Metadata 패치 시간 초과."
    case .unknown:
      return "Metadata 알수없음."
    case .metadataFetchNotAllowed:
        return "Metadta 가져올수없음"
    @unknown default:
      return "Metadata 알수없음."
    }
  }
}


