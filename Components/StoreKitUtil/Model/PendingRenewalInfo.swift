//
//  PendingRenewalInfo.swift
//  switchwon
//
//  Created by PNX on 2023/03/21.
//
import ObjectMapper

class PendingRenewalInfo: Mappable {
    /**
     - 문자열(string) 타입입니다.
     - 이 키의 값은 고객의 구독이 갱신되는 제품(product)의 productIdentifier 속성과 일치합니다.
     */
    var autoRenewProductId: String?
    /**
     - 이 키의 값은 고객의 구독 갱신과 관련된 제품의 productIdentifier 속성과 일치합니다.
     - **`1`** : 현재 구독 기간이 끝날 때 구독이 자동 갱신됩니다.
     - **`0`**  :고객이 해당 구독의 자동 갱신을 해제했습니다.
     */
    var autoRenewStatus: String?
    /**
     -  구독이 만료된 이유를 나타냅니다. 만료된 자동 갱신 가능 구독이 포함된 영수증에만 이 필드가 있습니다.
     - **`1` : 고객이 구독을 취소했습니다.**
     - **`2` : 청구 오류; 예를 들어, 고객의 결제 정보가 더 이상 유효하지 않습니다.**
     - **`3` : 고객이 동의해야 하는 자동 갱신 구독 가격 인상에 동의하지 않아 구독이 만료되었습니다.**
     - **`4` : 갱신 시점에 제품이 구매할 수 없었습니다.**
     - **`5` : 구독이 다른 이유로 만료되었습니다.**
     */
    var expirationIntent: String?
    
    private var _gracePeriodExpiresDate: String?
    /**
     - 청구 예정이지만 실패한 구독 갱신의 유예 기간이 만료되는 시간입니다.
     - ISO 8601과 유사한 날짜-시간 형식으로 표시됩니다.
     */
    var gracePeriodExpiresDate: Date? { _gracePeriodExpiresDate?.convertDateTimezone() }
    /**
     - 청구 유예 기간이 만료되는 시간을 UNIX epoch 시간 형식(밀리초)으로 표시합니다.
     - 이 키는 청구 유예 기간이 활성화된 앱에서만 사용할 수 있으며, 사용자가 갱신 시 오류가 발생한 경우에만 사용합니다.
     - 이 시간 형식을 날짜 처리에 사용하세요.
     */
    var gracePeriodExpiresDateMs: String?
    
    private var _gracePeriodExpiresDatePst: String?
    /**
     - 청구 예정이지만 실패한 구독 갱신의 유예 기간이 만료되는 시간입니다.
     - 태평양 표준시로 표시됩니다.
     */
    var gracePeriodExpiresDatePst: Date? { getPstDate(_gracePeriodExpiresDatePst) }
    /**
     - Apple이 만료된 구독을 자동으로 갱신하려는 시도를 하고 있는지 나타내는 플래그입니다.
     - 이 필드는 자동 갱신 가능 구독이 청구 재시도 상태에 있을 때만 있습니다.
     - 자세한 내용은 is_in_billing_retry_period를 참조하세요.
     - **`1` : App Store가 구독을 갱신하려는 중임을 나타냅니다.**
     - **`0` : App Store가 구독 갱신을 중지했음을 나타냅니다.**
     */
    var isInBillingRetryPeriod: String?
    /**
     - App Store Connect에서 구성한 구독 오퍼의 참조 이름입니다.
     - 이 필드는 고객이 구독 오퍼 코드를 사용하여 구독을 등록한 경우에만 존재합니다.
     - 자세한 내용은 offer_code_ref_name을 참조하세요.
     */
    var offerCodeRefName: String?
    /**
     - 최초 구매의 거래 식별자입니다.
     */
    var originalTransactionId: String?
    /**
     - 고객 동의가 필요한 자동 갱신 구독 가격 인상에 대한 가격 동의 상태입니다.
     - 이 필드는 가격 인상이 필요한 경우 고객 동의가 요청된 경우에만 존재합니다.
     - 기본값은 "0"이며, 고객이 동의한 경우 "1"로 변경됩니다.
     - 가능한 값: 1, 0
     */
    var priceConsentStatus: String?
    /**
     - 구매한 제품의 고유 식별자입니다.
     - 이 값을 App Store Connect에서 제품을 생성할 때 제공하며, 해당 값은 거래의 결제 속성에 저장된 SKPayment 객체의 productIdentifier 속성과 일치합니다.
     */
    var productId: String?
    /**
     - 사용자가 등록한 자동 갱신 구독 프로모션 제공의 식별자입니다.
     - App Store Connect에서 프로모션 제공을 생성할 때 프로모션 제공 식별자 필드에 이 값을 제공합니다.
     */
    var promotionalOfferId: String?
    /**
     - 자동 갱신 구독에 가격 인상이 적용되는지 여부를 나타내는 상태입니다.
     - 가격 인상 상태는 고객 동의가 필요한 자동 갱신 구독 가격 인상이 요청된 경우 "0"입니다. 이 경우 고객이 동의하지 않은 상태입니다.
     - 가격 인상 상태는 고객이 동의한 가격 인상이 있는 경우 "1"입니다. 또한, 고객 동의가 필요하지 않은 자동 갱신 구독 가격 인상이 고객에게 알려진 경우에도 "1"입니다.
     */
    var priceIncreaseStatus: String?
    
    let PST_TimeZone = "America/Los_Angeles"
    
    func getPstDate(_ dateString: String?) ->Date? {
        return dateString?.convertDateTimezone(timeZone: PST_TimeZone)
    }

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        autoRenewProductId <- map["auto_renew_product_id"]
        autoRenewStatus <- map["auto_renew_status"]
        expirationIntent <- map["expiration_intent"]
        _gracePeriodExpiresDate <- map["grace_period_expires_date"]
        gracePeriodExpiresDateMs <- map["grace_period_expires_date_ms"]
        _gracePeriodExpiresDatePst <- map["grace_period_expires_date_pst"]
        isInBillingRetryPeriod <- map["is_in_billing_retry_period"]
        offerCodeRefName <- map["offer_code_ref_name"]
        originalTransactionId <- map["original_transaction_id"]
        priceConsentStatus <- map["price_consent_status"]
        productId <- map["product_id"]
        promotionalOfferId <- map["promotional_offer_id"]
        priceIncreaseStatus <- map["price_increase_status"]
    }
}
