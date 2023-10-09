//
//  MetaDataCache.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/10/08.
//

import Foundation
import LinkPresentation

struct MetaDataCache {
    static func cache(metaData: LPLinkMetadata) {
        guard let metaDataUrl = metaData.url else { return }
        
        do {
            guard retrieve(urlString: metaDataUrl.absoluteString) == nil else { return }
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: metaData, requiringSecureCoding: true)
            UserDefaults.standard.setValue(data, forKey: metaDataUrl.absoluteString)
        }
        catch let error {
            print("Error when caching: \(error.localizedDescription)")
        }
    }

    static func retrieve(urlString: String) -> LPLinkMetadata? {
        do {
            guard let data = UserDefaults.standard.object(forKey: urlString) as? Data,
                  let metaData = try NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data)
            else { return nil }
            
            return metaData
        }
        catch let error {
            print("Error when caching: \(error.localizedDescription)")
            return nil
        }
    }
}
