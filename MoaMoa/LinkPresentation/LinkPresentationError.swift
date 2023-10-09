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
      return "Metadata fetch cancelled."
    case .metadataFetchFailed:
      return "Metadata fetch failed."
    case .metadataFetchTimedOut:
      return "Metadata fetch timed out."
    case .unknown:
      return "Metadata fetch unknown."
    @unknown default:
      return "Metadata fetch unknown."
    }
  }
}
