//
//  SubscriptionManager.swift
//  switchwon
//
//  Created by PNX on 2023/03/16.
//

import StoreKit
import RxSwift
import RxCocoa
import ObjectMapper

class SubscriptionManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    static let shared = SubscriptionManager()
    
    let productIdentifiers:[ProductType] = [.defaultSubscription,.promotionSubscription]
    
    var products = [SKProduct]()
    
    var productCollection:[ProductType:SKProduct] {
        get {
            Dictionary(uniqueKeysWithValues: products.map { (ProductType(rawValue: $0.productIdentifier), $0) })
        }
    }
    
    var requestObserver = PublishSubject<SubscriptionResult>()
    
    var requestProductObserver = PublishSubject<[ProductType:SKProduct]>()
    
    var requestRefreshObserver = PublishSubject<Void>()
    
    var requestProductType:ProductType = .promotionSubscription
    
    var bag = DisposeBag()
    
    //============================================================
    // MARK: - SKProductsRequestDelegate
    //============================================================
    
    /**
     상품정보 조회
     - 콜백형태로 제공
     - PublishSubject로 콜백 관리
     */
    func requestProducts(completion: @escaping ([ProductType:SKProduct])->Void) {
        self.showProgress()
        let productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers.map { $0.identifier }))
        productsRequest.delegate = self
        productsRequest.start()
        requestProductObserver
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: completion)
            .disposed(by: self.bag)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        self.requestProductObserver.onNext(self.productCollection)
        self.dismissProgress()
    }
    
    
    //============================================================
    // MARK: - SKPaymentTransactionObserver
    //============================================================
    
    /**
     SKPaymentQueue 에 SKPaymentTransactionObserver 설정
     - AppDelegate 에서 앱이 시작할때 설정
        - func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
     - 설정하지 않으면 paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) 이 실행되지 않음.
     */
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }

    /**
     SKPaymentQueue 에 SKPaymentTransactionObserver 해제
     - AppDelegate 에서 앱이 죽을때 해제
        - func applicationWillTerminate(_ application: UIApplication)
     */
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    /**
     구독상품 구매 시작
     - 콜백형태로 제공
     - PublishSubject로 콜백 관리
     */
    func purchaseSubscriptionReturnObservable(productType:ProductType, completion: @escaping (SubscriptionResult)->Void)  {
        self.showProgress()
        self.purchaseSubscription(productType:productType)
        self.requestObserver
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: completion)
            .disposed(by: self.bag)
    }
    
    func purchaseSubscription(productType:ProductType) {
        self.requestProductType = productType
        guard let product = self.productCollection[productType] else { return }
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var lastTransaction:SKPaymentTransactionState? = nil
        for transaction in transactions {
            lastTransaction = transaction.transactionState
            switch transaction.transactionState {
            case .purchased, .failed, .restored, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                DLog("purchasing 구독 진행중")
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
        
        switch lastTransaction {
        case .purchased:
            // 구독 구매가 완료된 경우 처리할 코드 작성
            DLog("lastTransaction purchased ")
            self.requestObserver.onNext(.success)
            self.dismissProgress()
        case .failed:
            // 구독 구매 실패 시 처리할 코드 작성
            DLog("lastTransaction failed")
            self.requestObserver.onNext(.success)
            self.dismissProgress()
        case .restored:
            // 구독 복원 처리 코드 작성
            DLog("lastTransaction restored")
            Util.delayAction(dDelay: 1) {
                self.purchaseSubscription(productType: self.requestProductType)
            }
        case .purchasing:
            DLog("lastTransaction purchasing")
        case .deferred:
            DLog("lastTransaction deferred")
            self.requestObserver.onNext(.failed)
            self.dismissProgress()
        default:
            DLog("lastTransaction default")
            self.requestObserver.onNext(.failed)
            self.dismissProgress()
        }
    }
    
    /// 이전에 구매한 모든 상품이 성공적으로 복원되었을 때 호출되는 메서드
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DLog("paymentQueueRestoreCompletedTransactionsFinished 호출")
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        self.refreshReceipt()
    }
    
    /// 이전에 구매한 모든 상품을 복원하는 데 실패했을 때 호출되는 메서드
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        GET_APPDELEGATE().dismissProgress()
        DLog(error)
    }
    
    //============================================================
    // MARK: - 로컬 영수증 복구 관련
    //============================================================
    
    func refreshReceipt(completion: @escaping ()->() = {}) {
        self.showProgress()
        let request = SKReceiptRefreshRequest(receiptProperties: nil)
        request.delegate = self
        request.start()
        self.requestRefreshObserver
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: completion)
            .disposed(by: bag)
    }
    
    func requestDidFinish(_ request: SKRequest) {
        self.dismissProgress()
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            // 영수증이 존재하지 않음
            return
        }
        DLog("requestDidFinish : \(receiptURL)")
        self.requestRefreshObserver.onNext(())
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        self.dismissProgress()
        DLog("request 호출 에러")
    }
    
    
    //============================================================
    // MARK: - ETC
    //============================================================
    
    func showProgress() {
        DispatchQueue.main.async { GET_APPDELEGATE().showProgress() }
    }
    
    func dismissProgress() {
        DispatchQueue.main.async { GET_APPDELEGATE().dismissProgress() }
    }
}

extension SubscriptionManager {
    
    /**
     로컬에 있는 영수증 데이터로 Apple 서버에서 결제내역 조회
     - 로컬 영수증이 없는경우 서버에서 영수증 데이터 갱신 요청후 다시 조회
     */
    func checkSubscriptionStatus(completion: @escaping (Bool)->Void) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: receiptURL.path) else {
            self.refreshReceipt {
                self.checkSubscriptionStatus(completion: completion)
            }
            DLog("인앱 구매 영수증이 없습니다.")
            return
        }
        do {
            self.showProgress()
            let receiptData = try Data(contentsOf: receiptURL)
            let receiptString = receiptData.base64EncodedString(options: [])
            
            let requestData = [
                "receipt-data": receiptString,
                "password": "a10dd657073d4583823681209f8509fc"
            ]
            let requestDataJson = try JSONSerialization.data(withJSONObject: requestData, options: [])

            let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")! // 테스트 Url
//            let url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")! // 실제 운영 Url
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = requestDataJson
            
            URLSession
                .shared
                .rx
                .data(request: request)
                .debug()
                .subscribe(on: SerialDispatchQueueScheduler(qos: .background))
                .map({ data -> Bool in
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) else { return false }
                    guard let resultData: ModelVerifyReceipt = Mapper<ModelVerifyReceipt>().map(JSONObject: json) else { return false }
                    let latestReceiptInfo = resultData.latestReceiptInfo?.map{ model -> Date? in return model.expiresDate }.compactMap{ $0 }.sorted()
                    if let expiresDate = latestReceiptInfo?.last {
                        CommonData.shared.membershipExpireDate = expiresDate
                        if Date().timeIntervalSinceReferenceDate < expiresDate.timeIntervalSinceReferenceDate {
                            DLog("사용자는 현재 구독 중입니다.")
                            return true
                        } else {
                            DLog("사용자의 구독이 만료되었습니다.")
                            return false
                        }
                    } else {
                        DLog("구독 기록이 없습니다.")
                        CommonData.shared.membershipExpireDate = nil
                        return false
                    }
                })
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resultBool in
                    completion(resultBool)
                }, onError: { error in
                    DLog("서버 요청 중 에러가 발생했습니다. error : \(error.localizedDescription)")
                }, onCompleted: {
                    self.dismissProgress()
                }).disposed(by: bag)
        } catch {
            self.dismissProgress()
            DLog("인앱 구매 영수증을 읽어오는 중 오류가 발생했습니다.")
            return
        }
    }
}

extension SubscriptionManager {
    enum SubscriptionResult {
        case success
        case failed
    }
    
    enum ProductType {
        /// 신규 프로모션 없는 구독상품 타입 정의
        case defaultSubscription
        /// 신규 프로모션 있는 구독 상품 타입 정의
        case promotionSubscription
        
        var identifier:String {
            switch self {
            case .defaultSubscription:
                return "\(BUILD_SETTING ?? "").membership.first"
            case .promotionSubscription:
                return "\(BUILD_SETTING ?? "").membership.promotion.first"
            }
        }
        
        init(rawValue: String) {
            switch rawValue {
            case "\(BUILD_SETTING ?? "").membership.promotion.first": self = .promotionSubscription
            default: self = .defaultSubscription
            }
        }
    }
}
