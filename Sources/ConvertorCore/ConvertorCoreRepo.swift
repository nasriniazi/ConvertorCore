import Network
import Foundation
import RxSwift

public typealias ResponseTuple<T> = (value : T?,error : Error?)

public protocol CoinConvertorRepositoryProtocol{
    func getBitCoinPrice(uuid:String ,referenceCurrencyUuid :String?,timeStamp:Double? ) ->
    Observable<ResponseTuple<Models.SimpleResponse<Models.GetPrice>>>
}
public class CoinConvertorRepository:CoinConvertorRepositoryProtocol{
    static let shared : CoinConvertorRepositoryProtocol = {
        ///create our modules
        let networking = NetworkService(config: NetworkConfig.defaultConfig)
        ///create our data manager
        let networkManager = NetworkManager(network: networking)
        ///initialize repository
        return CoinConvertorRepository(networkManager: networkManager )
    }()
    
    private var _networkConfigWithToken = NetworkConfig.defaultConfig
    private var networkConfigWithToken : NetworkConfig {
        get {
            ///append api key header to requests--get from  plist config
            guard let token = Bundle.main.infoDictionary?["API_KEY"] as? String else {
                return _networkConfigWithToken
            }
            if(!token.isEmpty){
                _networkConfigWithToken.defaulHeaders.updateValue("\(token)", forKey: "x-access-token")
            }
            return _networkConfigWithToken
        }
        set {
            _networkConfigWithToken = newValue
        }
    }
    private let _networkManager : NetworkManager
    
    /// initialize our repository with our datamanager
    /// - Parameter dataManager: Data Manager Object
    public init(networkManager :  NetworkManager) {
        _networkManager = networkManager
        ///set default headers
        self.addDefaultHeaders()
    }
    private func addDefaultHeaders(){
        networkConfigWithToken.baseUrl = APIConfigs.baseUrl
    }
    public func getBitCoinPrice(uuid:String ,referenceCurrencyUuid :String? = nil,timeStamp:Double? = nil) ->
    Observable<ResponseTuple<Models.SimpleResponse<Models.GetPrice>>> {
        let observable = Observable<ResponseTuple<Models.SimpleResponse<Models.GetPrice>>>.create{
            observer in
            var params:[String:Any] = [:]
            if let refrenceUuid = referenceCurrencyUuid { params["referenceCurrencyUuid"] = refrenceUuid }
            if let timeStamp = timeStamp {
                params["timeStamp"] = timeStamp
            }
            let endPointUrl = self.getBitCoinPrice_Path(uuid)
            let request : NetworkRequestProtocol = NetworkRequest()
                .add(path: endPointUrl)
                .setConfig(config: self.networkConfigWithToken)
            DispatchQueue.global(qos: .utility).async {
                self._networkManager.checkCacheThenGetNetwork(request: request) {(result) in
                    ///if there is an error, tell subsribers
                    if let error = result.error {
                        ///in case of connecting error or any other server error we don't show the details , instead generate a general server error
                        let err = ServerError(ErrorTypes.globalError.rawValue)
                        observer.onError(err)
                    }
                    ///else go and pass the result
                    else {
                        do{
                            let model : Models.SimpleResponse<Models.GetPrice> = try JSONDecoder().decode(Models.SimpleResponse.self, from: result.response!)
                            /// check if status == success, emit onNext
                            if  model.status == "success"{
                                observer.onNext((model, nil))
                            }
                            else{
                                do {
                                    let model :Models.SimpleResponse<Models.serverErrorResponse> = try JSONDecoder().decode(Models.SimpleResponse.self, from: result.response!)
                                    if model.status == "fail" {
                                        let serverError = ServerError(model.data?.message ?? "")
                                        observer.onError(serverError)
                                    }
                                }catch{
                                    observer.onError(ErrorTypes.jsonParseError)
                                }
                            }
                        }catch{
                            observer.onError(ErrorTypes.jsonParseError)
                        }
                    }
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        return observable
    }
    fileprivate func getBitCoinPrice_Path(_ uuid: String) -> String{
        let urlPath = "/coin/\(uuid)/price"
        return urlPath
    }
}

public enum ErrorTypes :String,LocalizedError {
    case jsonParseError
    case cointNotFound = "COIN_NOT_FOUND"
    case validationError = "VALIDATION_ERROR"
    case refrenceUnavailable = "REFERENCE_UNAVAILABLE"
    case globalError = "Server Error"
    
    public var description: String { return NSLocalizedString(self.rawValue, comment: "Convertor") }
}

public class ServerError:Error{
    public var message:String = ""
    public  var retry:Bool = true
    public init(_ msg:String,retry:Bool?=true) {
        self.message = msg
        self.retry = retry ?? true
    }
}
