//
//  ModelVerifyReceipt.swift
//  switchwon
//
//  Created by PNX on 2023/03/21.
//

import ObjectMapper

class ModelVerifyReceipt: Mappable {
    /**
     시스템에서 영수증을 생성하는 환경입니다.
     - Possible values: Sandbox, Production
     */
    var environment: String = ""
    
    /**
     Base64로 인코딩된 최신 앱 영수증입니다. 자동 갱신 구독이 포함된 영수증에 대해서만 반환됩니다.
     */
    var latestReceipt:String?
    
    /**
     모든 앱에서 바로 구매 트랜잭션을 포함하는 배열입니다. 앱에서 완료로 표시한 소모성 제품에 대한 트랜잭션은 제외됩니다.
     */
    var latestReceiptInfo: [ReceiptInfo]?
    /**
     JSON 파일에서 각 요소가 product_id가 식별하는 각 자동 갱신 가능 구독에 대한 보류 중인 갱신 정보를 포함하는 배열입니다.
     자동 갱신 구독이 포함된 앱 영수증에 대해서만 반환됩니다.
     */
    var pendingRenewalInfo:[PendingRenewalInfo]?
    
    /**
     영수증이 유효한 경우 0
     오류가 있는 경우 상태 코드 중 하나입니다.
     상태 코드는 앱 영수증의 상태를 전체적으로 반영합니다.
     가능한 상태 코드 및 설명은 상태를 참조하십시오.
     */
    var status:Int = 0
    
    var isRetryable: Bool = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        latestReceiptInfo <- map["latest_receipt_info"]
        latestReceipt <- map["latest_receipt"]
        pendingRenewalInfo <- map["pending_renewal_info"]
        status <- map["status"]
        isRetryable <- map["is_retryable"]
    }
}
