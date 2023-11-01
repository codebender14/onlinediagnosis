
import Foundation
import UIKit
import JitsiMeetSDK
import WebKit

public class CallVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var container: UIView!
    fileprivate var jitsiMeetView: JitsiMeetView?
    var options: JitsiMeetConferenceOptions? = nil
    weak var delegate: JitsiMeetViewControllerDelegate?
    fileprivate var pipViewCoordinator: PiPViewCoordinator?

   
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::viewDidLoad");
        openJitsiMeet();
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::viewWillTransition");
    }

    
    func openJitsiMeet() {
        cleanUp()

        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::openJitsiMeet");

        // create and configure the absorbPointerView and jitsimeet view
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        jitsiMeetView.join(options)

        // Enable jitsimeet view to be a view that can be displayed
        // on top of all the things, and let the coordinator to manage
        // the view state and interactions
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: container)

        // animate in
        jitsiMeetView.alpha = 1
        pipViewCoordinator?.show()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::viewDidDisappear");
        cleanUp();
    }

    fileprivate func cleanUp() {
        self.leave()
        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::cleanUp");
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
    }

    public func leave() {
        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::leave");
  
        self.jitsiMeetView?.hangUp()
    }
}

protocol JitsiMeetViewControllerDelegate: AnyObject {
    func onConferenceJoined()

    func onConferenceLeft()
}

// MARK: JitsiMeetViewDelegate
extension CallVC: JitsiMeetViewDelegate {

    @objc public func conferenceJoined(_ data: [AnyHashable : Any]!) {
        delegate?.onConferenceJoined()
        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::conference joined.");
    }

    @objc public func ready(toClose: [AnyHashable : Any]!) {
        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::ready to close");
        delegate?.onConferenceLeft()
        self.cleanUp()

        self.dismiss(animated: true, completion: nil); // e.g. user ends the call. This is preferred over conferenceLeft to shorten the white screen while exiting the room
    }

    @objc public func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        print("[Jitsi Plugin Native iOS]: JitsiMeetViewController::conference terminated");
        delegate?.onConferenceLeft()
        self.cleanUp()

        self.dismiss(animated: true, completion: nil); // e.g. user ends the call. This is preferred over conferenceLeft to shorten the white screen while exiting the room
    }
}
