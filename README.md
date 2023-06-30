# study-UIKit

앨런 Swift 문법 마스터스쿨 강의를 수강하며 다시한번 UIKit 전반에 대해 복습하고, 관련해서 배운 점과 고민한 내용에 대해 정리하는 레포입니다.

## 1. 타이머와 슬라이더

<img src="https://github.com/yurrrri/study-UIKit/assets/37764504/ca9a70fc-b47f-454a-8a1c-2439fd8753e7" width="200"/>

### 배운점 및 회고

**1. 스토리보드 우측 하단 'embed In View' 기능을 통해서 뷰를 한꺼번에 스택뷰로 묶을 수 있다.** <br/>
**2. 클로저는 강한참조 사이클 문제를 신경쓰자.**

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

## 2. 텍스트필드를 활용한 간단한 로그인 UI

<img src="https://github.com/yurrrri/study-UIKit/assets/37764504/9bc8d52f-221b-407b-81c2-9b3e43023fcf " width="200"/>

### 배운점 및 회고 
**1. 클로저 vs Then 라이브러리를 활용한 UI 인스턴스 초기화**
- 그저 편하니까 Then 라이브러리를 썼는데 Then 라이브러리가 어떤 이점이 있는지 알아보았다.

**클로저 활용**
```swift
let emailTextFieldView: UIView = {   // 각 UI에 관한 속성을 분리하는게 아니라 같이 쓸 수 있어서 깔끔함
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
```

**Then 활용**
```swift
let emailTextFieldView = UIView().then {
    $0.backgroundColor = .darkGray
    $0.layer.cornerRadius = 8
    $0.layer.masksToBounds = true
}
```

https://github.com/devxoul/Then <br/>
리드미를 보니 위 아래가 완전히 동일한 코드라고 한다. return인지 아닌지 차이? 정도 인것같다.

**2. 코드로 constraint를 줄 때는 반드시 translatesAutoresizingMaskIntoConstrains = false를 주자.**
- 이 속성을 안주면 Autoresize를 디폴트로 하기때문에 수동으로 constraint를 줄 수 없다. (스토리보드는 이게 디폴트로 false로 되어있는데 code based ui일 때는 설정해줘야 하는 부분)

**3. NSLayoutConstraint vs Snapkit**
- 코드로 레이아웃 짤 때 동료들이 모두 SnapKit을 쓰길래 나도 따라 썼던 기억이 나는데, 2가지 방식을 비교해보았다.

**NSLayoutConstraint 활용**
```swift
        NSLayoutConstraint.activate([
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8)
        ])
```

**SnapKit 활용**
```swift
    emailInfoLabel.snp.makeConstraints { make in
        make.leading.equalTo(emailTextFieldView.snp.leading).offset(8)
        make.trailing.equalTo(emailTextFieldView.snp.leading).offset(-8)
```

2가지를 모두 활용해보면서 느낀점을 정리해보자면
- NSLayoutConstraint.activate 는 배열의 constraint를 모두 활성화(isActive=true)해주는 장점이 있지만 다른 많은 뷰들도 같이 들어가게 되 면 코드 분리가 어려워질 뿐더러 코드가 길어지고 가독성이 좋지 않게 된다. <br/>
하지만 SnapKit은 뷰마다 제약을 걸어주는 것이기 때문에 코드 분리가 잘되어 가독성이 좋다.
- 일일이 제약을 거는 대상(emailInfoLabel)을 써주지 않아도 클로저를 활용해 임의로 이름을 지어서 걸어줄 수 있으니 SnapKit이 더 편리하다.
- SnapKit은 equalToSuperView() 라는 메서드가 있어서 제약을 편리하게 super view를 기준으로 걸어줄 수 있다.
- 만약에 제약을 거는 다른 뷰가 leading, trailing, top, bottom 이런식으로 다 같으면 한꺼번에 붙여쓸 수 있다.

```swift
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor),
            emailInfoLabel.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor) 
```

이 친구를

```swift
            emailInfoLabel.lading.trailing.top.equalTo(emailTextFieldView)
```

로 바꿀 수 있다는 이야기다. <br/>

**4. UIView.animate(withDuration: )을 통해 일정기간동안 뷰의 변화가 애니메이션을 통해 자연스럽게 일어날 수 있는 방법을 새롭게 접하고 적용했다.**

