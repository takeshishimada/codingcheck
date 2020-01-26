//
//  FurigawaAPI.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/22.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class FuriganaAPI {
    
    static let endpoint = "https://jlp.yahooapis.jp/FuriganaService/V1/furigana"
    static let appid = "dj00aiZpPThjeEJTdWJmak5OQiZzPWNvbnN1bWVyc2VjcmV0Jng9ZjA-"
    
    static func translate(text: String) -> Observable<FuriganaWordList>  {
        let params: [String: Any] = [
            "appid": appid,
            "sentence": text
        ]
        if let url = URL(string: endpoint) {
            return Observable<FuriganaWordList>.create { observer in
                AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default)
                    .validate(statusCode: 200..<300)
                    .response { response in
                        switch response.result {
                        case .success( _):
                            guard let data = response.data, let str = String(data: data, encoding: .utf8) else { return }
                            let result = FuriganaResultSet(XMLString: str)
                            debugPrint(str)
                            if let list = result?.result.wordList {
                                observer.onNext(list)
                            }
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                            observer.onCompleted()
                        }
                }
                return Disposables.create()
            }
        } else {
            return Observable.empty()
        }
    }
    
}

