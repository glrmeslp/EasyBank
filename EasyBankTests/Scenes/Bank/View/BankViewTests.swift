import XCTest
@testable import EasyBank

final class BankViewTests: XCTestCase {
    private lazy var sut: BankView = BankView(frame: CGRect.init(x: 0, y: 0,
                                                                 width: 320,
                                                                 height: 500))

    func test_collectionViewNumberOfItemsInSection_whenBankMenuIsNil_shouldReturnZero() {
        let result = sut.collectionView(UICollectionView(frame: CGRect.zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout.init()), numberOfItemsInSection: 0)
        XCTAssertEqual(0, result)
    }

    func test_collectionViewNumberOfItemsInSection_whenBankMenuIsNotNil_shouldReturnThree() {
        sut.setup(BankMenu().bankMenu)
        let result = sut.collectionView(UICollectionView(frame: CGRect.zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout.init()), numberOfItemsInSection: 0)
        XCTAssertEqual(3, result)
    }

    func test_collectionViewCellForItemAt_givenIndexPathZero_shouldReturnMenuCollectionViewCell() {
        sut.setup(BankMenu().bankMenu)
        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "menuCollectionCell")
        let result = sut.collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(result is MenuCollectionViewCellOld)
    }

    func test_tableViewNumberOfRowsInSection_whenAccountsIsNil_shouldReturnZero() {
        let result = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(0, result)
    }

    func test_tableViewNumberOfRowsInSection_givenOneAccount_shouldReturnOne() {
        sut.setup([Account(balance: 0, userName: "")])
        let result = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(1, result)
    }

    func test_tableViewCellForRowAt_givenIndexPathZero_shouldReturnAccountTableViewCell() {
        sut.setup([Account(balance: 0, userName: "")])
        let tableView = UITableView()
        tableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "accountTableViewCell")
        let result = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(result is AccountTableViewCell)
    }

    func test_numberOfSections_shouldReturnOne() {
        let result = sut.numberOfSections(in: UITableView())
        XCTAssertEqual(1, result)
    }

    func test_heightForHeaderInSection_shouldReturnThirty() {
        let result = sut.tableView(UITableView(), heightForHeaderInSection: 0)
        XCTAssertEqual(30, result)
    }

    func test_titleForHeaderInSection_shouldReturnAccounts() {
        let result = sut.tableView(UITableView(), titleForHeaderInSection: 0)
        XCTAssertEqual("Accounts", result)
    }
}
