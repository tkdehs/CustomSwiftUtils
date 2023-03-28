//
//  ModelReceiptInfo.swift
//  switchwon
//
//  Created by PNX on 2023/03/21.
//
import ObjectMapper

class ReceiptInfo: Mappable {
    
    /**
     - 이 거래와 관련된 appAccountToken.
     - 사용자가 구매를 진행할 때, 앱에서 appAccountToken(_:)을 제공하거나 applicationUsername 속성에 UUID를 제공한 경우에만 이 필드가 존재합니다.
     */
    var appAccountToken: String?
    
    private var _cancellationDate: String?
    /**
     - App Store가 거래를 환불하거나 Family Sharing에서 취소한 시간입니다.
     - ISO 8601과 유사한 날짜-시간 형식으로 표시됩니다.
     - 이 필드는 환불 또는 취소된 거래에 대해서만 존재합니다.
     */
    var cancellationDate: Date? { _cancellationDate?.convertDateTimezone() }
    
    /**
     - App Store가 거래를 환불하거나 Family Sharing에서 취소한 시간입니다.
     - UNIX epoch 시간 형식으로 밀리초 단위로 표시됩니다.
     - 이 필드는 환불 또는 취소된 거래에 대해서만 존재합니다.
     - 날짜를 처리할 때 이 시간 형식을 사용합니다.
    */
    var cancellationDateMs: String?
    
    private var _cancellationDatePst: String?
    /**
     - App Store가 거래를 환불하거나 Family Sharing에서 취소한 시간입니다.
     - 태평양 표준시로 표시됩니다.
     - 이 필드는 환불 또는 취소된 거래에 대해서만 존재합니다.
     */
    var cancellationDatePst: Date? { getPstDate(_cancellationDatePst) }
    /**
     - 환불 또는 취소된 거래의 이유입니다.
     - 값이 1이면 고객이 앱 내의 실제 또는 인식상의 문제로 인해 거래를 취소했음을 나타냅니다.
     - 값이 0이면 거래가 다른 이유로 취소된 경우입니다. 예를 들어, 고객이 실수로 구매한 경우입니다.
     - 가능한 값: 1, 0
     */
    var cancellationReason: String?
    
    private var _expiresDate: String?
    /**
     - 자동 갱신 구독이 만료되거나 갱신될 때의 시간입니다.
     - ISO 8601과 유사한 날짜-시간 형식으로 표시됩니다
     */
    var expiresDate: Date? { _expiresDate?.convertDateTimezone() }
    /**
     - 자동 갱신 구독이 만료되거나 갱신될 때의 시간입니다.
     - UNIX epoch 시간 형식으로 밀리초 단위로 표시됩니다. 이 시간 형식을 사용하여 날짜를 처리합니다.
     */
    var expiresDateMs: String?
    
    private var _expiresDatePst: String?
    /**
     - 자동 갱신 구독이 만료되거나 갱신될 때의 시간입니다.
     - 태평양 표준시로 표시됩니다.
     */
    var expiresDatePst: Date? { getPstDate(_expiresDatePst) }
    /**
     - 사용자가 제품을 구매한 구매자인지 아니면 Family Sharing을 통해 제품에 액세스하는 가족 구성원인지를 나타내는 값입니다.
     - **`FAMILY_SHARED` : 거래는 서비스 혜택을 받는 가족 구성원에 속합니다.**
     - **`PURCHASED` : 거래는 구매에 속합니다.**
     */
    var inAppOwnershipType: String?
    /**
     - 자동 갱신 구독이 소개 가격 기간인지 여부를 나타내는 지표입니다.
     - 자세한 정보는 is_in_intro_offer_period를 참조하십시오.
     - 가능한 값: true, false
     - **`true` :  고객의 구독은 출시 기간 가격입니다.**
     - **`false` : 구독은 출시 기간 가격이 아닙니다.**
     */
    var isInIntroOfferPeriod: String?
    /**
     - 자동 갱신 구독 상품이 무료 체험 기간에 있는지 여부를 나타내는 표시자입니다.
     - **`true` :  구독은 무료 체험 기간에 있습니다.**
     - **`false` : 구독은 무료 체험 기간이 아닙니다.**
     */
    var isTrialPeriod: String?
    /**
     - 자동 갱신 구독 상품이 업그레이드로 인해 취소되었는지 여부를 나타내는 표시자입니다.
     - 이 필드는 업그레이드 거래에만 존재합니다.
     - 값: true
     */
    var isUpgraded: String?
    /**
     - 앱 스토어 연동에서 구성한 구독 제공 코드의 참조 이름입니다.
     - 고객이 구독 제공 코드를 사용하는 경우에만 이 필드가 존재합니다.
     - 구독 제공 코드에 대한 자세한 내용은 "Set Up Offer Codes"와 "Implementing offer codes in your app"을 참조하십시오.
     */
    var offerCodeRefName: String?
    
    private var _originalPurchaseDate: String?
    /**
     - ISO 8601와 유사한 날짜-시간 형식으로 원래 앱 구매 시간입니다.
     */
    var originalPurchaseDate: Date? { _originalPurchaseDate?.convertDateTimezone() }
    /**
     - 밀리초 단위의 UNIX epoch 시간 형식으로 원래 앱 구매 시간입니다.
     - 자동 갱신 구독 상품의 경우 이 값은 구독의 초기 구매 날짜를 나타냅니다.
     - 원래 구매 날짜는 모든 제품 유형에 적용되며 동일한 제품 ID에 대한 모든 거래에서 동일한 값입니다.
     - 이 값은 StoreKit의 원래 거래의 transactionDate 속성에 해당합니다.
     */
    var originalPurchaseDateMs: String?
    
    private var _originalPurchaseDatePst: String?
    /**
     - 태평양 표준시(Pacific Standard Time)로 나타낸 원래 앱 구매 시간입니다.
     */
    var originalPurchaseDatePst: Date? { getPstDate(_originalPurchaseDatePst) }
    /**
     - 원래 구매의 거래 식별자입니다.
     */
    var originalTransactionId: String?
    /**
     - 구매한 제품의 고유 식별자입니다.
     - 이 값을 App Store Connect에서 제품을 생성할 때 제공하며, 거래의 payment 속성에 저장된 SKPayment 객체의 productIdentifier 속성에 해당합니다.
     */
    var productId: String?
    /**
     - 사용자가 교환한 구독 제공 코드의 식별자입니다.
     */
    var promotionalOfferId: String?
    
    private var _purchaseDate: String?
    /**
     - ISO 8601와 유사한 날짜-시간 형식으로 App Store에서 구매 또는 복원된 제품에 대해 사용자 계정을 청구한 시간 또는 구독 구매 또는 갱신 후에 재개하는 경우 App Store에서 사용자 계정을 청구한 시간입니다.
     */
    var purchaseDate: Date? { _purchaseDate?.convertDateTimezone() }
    /**
     - 구매나 복원된 제품에 대해 App Store가 사용자 계정에서 비용을 청구한 시간(밀리초로 된 UNIX epoch 시간 형식).
     - 자동 갱신 구독의 경우, 구독 구매 또는 갱신이 일어난 후 App Store가 사용자 계정에서 비용을 청구한 시간(밀리초로 된 UNIX epoch 시간 형식). 이 시간 형식은 날짜를 처리할 때 사용됩니다.
     */
    var purchaseDateMs: String?
    
    private var _purchaseDatePst: String?
    /**
     - App Store가 사용자 계정에서 구매 또는 복원한 제품에 대한 비용 청구 시간 또는 갱신 후 사용자 계정에서 구독 구매 또는 갱신에 대한 비용 청구 시간(태평양 표준시).
     */
    var purchaseDatePst: Date? { getPstDate(_purchaseDatePst) }
    /**
     - 구매한 소모 가능 제품 수량.
     - 이 값은 거의 항상 1이며, 가변 결제로 수정하지 않는 한 그렇습니다. 최대 값은 10입니다.
     - 이 값은 트랜잭션의 payment 속성에 저장된 SKPayment 객체의 quantity 속성과 일치합니다.
     */
    var quantity: String?
    /**
     - 해당 구독이 속한 구독 그룹의 식별자입니다.
     - 이 필드의 값은 SKProduct의 subscriptionGroupIdentifier 속성과 동일합니다.
     */
    var subscriptionGroupIdentifier: String?
    /**
     - 기기 간 구매 이벤트, 구독 갱신 이벤트를 식별하기 위한 고유한 식별자입니다.
     - 이 값은 구독 구매를 식별하는 주요 키입니다.
     */
    var webOrderLineItemId: String?
    /**
     - 구매, 복원 또는 갱신과 같은 트랜잭션의 고유 식별자입니다.
     */
    var transactionId: String?
    
    let PST_TimeZone = "America/Los_Angeles"
    
    func getPstDate(_ dateString: String?) ->Date? {
        return dateString?.convertDateTimezone(timeZone: PST_TimeZone)
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        appAccountToken <- map["app_account_token"]
        _cancellationDate <- map["cancellation_date"]
        cancellationDateMs <- map["cancellation_date_ms"]
        _cancellationDatePst <- map["cancellation_date_pst"]
        cancellationReason <- map["cancellation_reason"]
        _expiresDate <- map["expires_date"]
        expiresDateMs <- map["expires_date_ms"]
        _expiresDatePst <- map["expires_date_pst"]
        inAppOwnershipType <- map["in_app_ownership_type"]
        isInIntroOfferPeriod <- map["is_in_intro_offer_period"]
        isTrialPeriod <- map["is_trial_period"]
        isUpgraded <- map["is_upgraded"]
        offerCodeRefName <- map["offer_code_ref_name"]
        _originalPurchaseDate <- map["original_purchase_date"]
        originalPurchaseDateMs <- map["original_purchase_date_ms"]
        _originalPurchaseDatePst <- map["original_purchase_date_pst"]
        originalTransactionId <- map["original_transaction_id"]
        productId <- map["product_id"]
        promotionalOfferId <- map["promotional_offer_id"]
        _purchaseDate <- map["purchase_date"]
        purchaseDateMs <- map["purchase_date_ms"]
        _purchaseDatePst <- map["purchase_date_pst"]
        quantity <- map["quantity"]
        subscriptionGroupIdentifier <- map["subscription_group_identifier"]
        webOrderLineItemId <- map["web_order_line_item_id"]
        transactionId <- map["transaction_id"]
    }
}
