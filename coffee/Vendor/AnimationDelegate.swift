//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//

import QuartzCore

class AnimationDelegate: NSObject, CAAnimationDelegate {
    fileprivate let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    dynamic func animationDidStop(_: CAAnimation, finished: Bool) {
        completion()
    }
}
