//
//  MetaData.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/08.
//

import Foundation
import LinkPresentation

struct MetaData {
    static func fetchMetaData(for url: URL, completion: @escaping ((Result<LPLinkMetadata ,LPError>) -> Void)) {
        let metaDataProvider = LPMetadataProvider()
        metaDataProvider.timeout = 3
        
        metaDataProvider.startFetchingMetadata(for: url) { metaData, error in
            guard let metaData = metaData, error == nil
                
            else {
                if let error = error as? LPError {
                    completion(.failure(error))
                }
                return
            }
            
            MetaDataCache.cache(metaData: metaData)
            completion(.success(metaData))
        }
    }
    
}
