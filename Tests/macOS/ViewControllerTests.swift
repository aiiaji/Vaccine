import XCTest
import Vaccine
import Cocoa

class ViewControllerTests: XCTestCase {
  let utilities = Utilities()

  class ViewControllerMock: NSViewController {
    override func loadView() {
      super.view = NSView()
    }
  }

  class ParentViewControllerMock: NSViewController {
    lazy var dummyView = NSView()
    lazy var dummyLayer = CALayer()
    lazy var childViewController = ViewControllerMock()
    var timesInvoked: Int = 0

    override func loadView() {
      self.view = NSView()
      self.view.wantsLayer = true
    }

    override func viewDidLoad() {
      super.viewDidLoad()
      Injection.add(observer: self, with: #selector(injected(_:)))
      view.addSubview(dummyView)
      view.layer?.addSublayer(dummyLayer)
      addChildViewController(childViewController)
      timesInvoked += 1
    }
  }

  func testAddingInjection() {
    let viewController = ParentViewControllerMock()
    let _ = viewController.view
    XCTAssertEqual(viewController.timesInvoked, 1)
    utilities.triggerInjection(viewController)
    XCTAssertEqual(viewController.timesInvoked, 2)
    XCTAssertEqual(viewController.childViewControllers.count, 1)
    XCTAssertEqual(viewController.view.subviews.count, 1)
    XCTAssertEqual(viewController.view.layer?.sublayers?.count, 1)
  }
}
