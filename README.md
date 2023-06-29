# study-UIKit
UIKit을 복습하는 레포입니다.

### 1. 타이머와 슬라이더

<img src="https://github.com/yurrrri/study-UIKit/assets/37764504/ca9a70fc-b47f-454a-8a1c-2439fd8753e7" width="200"/>

#### 배운점 및 회고
1. 'embed In View' 기능을 통해서 뷰를 한꺼번에 스택뷰로 묶을 수 있다.
2. 클로저는 강한참조 사이클을 신경쓰자.

```swift
    var timer: Timer? // 왜 weak으로 했을까? -> timer안에서 클로저를 호출하기때문에 강한 참조 사이클이 발생할 수 있음
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        timer?.invalidate()
        timer = Timer(timeInterval: 0.1, repeats: true) { [self] _ in
            self.doSomethingAfterSecond()
        }
    }
```
   
- 이 코드에서는 ViewController 인스턴스가 timer 인스턴스 속성을 가지고 있고, timer는 클로저를 가리키며 클로저는 ViewController 인스턴스를 가리키게 됨으로써 강한참조 사이클 발생
- 여기서는 timer앞에 weak을 붙이거나 클로저의 캡쳐리스트를 약한 참조로 함으로써 [weak self]를 붙이는 방법을 통해 강한 참조 사이클을 해결할 수 있는데, weak self의 경우 self가 옵셔널로 가리킴으로 인해 번거로울 수 있으니 weak var timer: Timer?로 하게되면 강한 참조 사이클이 일어나지 않는다.
