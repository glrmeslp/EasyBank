import XCTest
@testable import EasyBank

final class HomeCollectionViewCellTests: XCTestCase {
    private lazy var sut: HomeCollectionViewCell = HomeCollectionViewCell()

    func test_configure_givenQRCode() {
        sut.configure(with: .init(title: "QRCode", image: "qrcode"))
        let sutMirrored = HomeCollectionViewCellMirror(collectionViewCell: sut)
        XCTAssertEqual("QRCode", sutMirrored.titleLabel?.text)
        XCTAssertEqual(UIImage(systemName: "qrcode"), sutMirrored.imageView?.image)
    }
}
