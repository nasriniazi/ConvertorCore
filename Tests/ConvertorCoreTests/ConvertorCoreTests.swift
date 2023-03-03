import XCTest
import OHHTTPStubs
import Alamofire
import Network
@testable import ConvertorCore


final class ConvertorCoreTests: XCTestCase {
    private var sut: CoinConvertorRepository!
    var expectedResultsResponse: Models.GetPrice?
    
    
    override func setUp() {
        super.setUp()
        
        let network = NetworkService(config: NetworkConfig.defaultConfig)
        let networkManager = NetworkManager(network: network)
        sut = CoinConvertorRepository(networkManager: networkManager)
    }
    override func tearDown() {
        sut = nil
    }
    func testFetchBitCoinUnitPrice(){
        let fakeJSONObject = JSONMocking.shared.fakeBitCoinPrice
        let exception = self.expectation(description: "Fetch Price Failed")
        StubRequests.shared.stubJSONrespone(jsonObject: fakeJSONObject, header: nil, statusCode: 200, absoluteStringWord: APIConfigs.baseUrl)
        sut.getBitCoinPrice(uuid: "razxDUgYGNAdQ").asSingle().subscribe (onSuccess: { (retrievedData, error:Error?) in
            self.expectedResultsResponse = retrievedData?.data
            XCTAssertEqual(retrievedData?.status, "success")
            exception.fulfill()
        }){(error) in
            XCTAssertNotNil(error)
        }
        //            .disposed(by: DisposeBag())
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNotNil(expectedResultsResponse)
        
    }
}






