# study-UIKit

[앨런 iOS 앱 개발 강의](https://www.inflearn.com/course/ios-uikit-15apps)를 수강하며 UIKit 전반에 대해 복습하고, 관련해서 배운 점과 고민한 내용에 대해 정리하는 레포입니다.

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
- 여기서는 timer앞에 weak을 붙이거나 클로저의 캡쳐리스트를 약한 참조로 함으로써 [weak self]를 붙이는 방법을 통해 강한 참조 사이클을 해결할 수 있는데, weak self의 경우 self가 옵셔널로 가리킴으로 인해 번거로울 수 있으니 weak var timer: Timer?로 하게되면 강한 참조 사이클이 일어나지 않는다. <br/>

**3. 클로저는 항상 weak self를 쓰면 좋을까?에 대한 고민** <br/>
https://noah0316.github.io/Swift/2022-04-08-[weak-self]-%EB%AC%B4%EC%A1%B0%EA%B1%B4-%EC%82%AC%EC%9A%A9%ED%95%98%EB%8A%94%EA%B2%8C-%EB%A7%9E%EB%8A%94%EA%B1%B8%EA%B9%8C/

- non-escaping 클로저는 메서드 실행이 끝나면 메모리에서 없어지기에 강한 참조 사이클을 발생시킬 수 없음 -> [weak self] 필요 X
- escaping 클로저는 프로퍼티로 저장되거나, 클로저 안의 객체가 클로저에 대한 강한 참조를 유지하는 경우 강한 참조 사이클이 발생할 여지가 있으므로 -> [weak self] 필요 O
- GCD와 애니메이션의 클로저는 escaping 클로저임에도 불구하고, 메모리에 잠깐 존재했다가 사라지는 개념이기 때문에 프로퍼티로 저장되지 않는 이상 -> [weak self] 필요 X 

## 2. 텍스트필드를 활용한 간단한 로그인 UI

<img src="https://github.com/yurrrri/study-UIKit/assets/37764504/9bc8d52f-221b-407b-81c2-9b3e43023fcf " width="250"/>

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

**4. UIView.animate(withDuration: )을 통해 일정기간동안 뷰의 변화가 애니메이션을 통해 자연스럽게 발생할 수 있도록 적용**

**5. Responder Chain과 firstResponder 개념 이해**

## 3. BMI 계산기(화면 전환) 

<img src="https://github.com/yurrrri/study-UIKit/assets/37764504/efe8a3ce-f6a5-4d39-b40b-e5a6e5e386d5" width="250"/>

### 배운점 및 회고

**1. 화면 전환하는 방법 3가지에 대해 다시 짚고넘어갈 수 있었다.**
- 코드로 된 VC와 스토리보드 VC로 화면 전환 및 데이터 전달
- Segue 개념 및 데이터 전달

**2. 기능 단위로 함수로 묶는 것이 코드의 가독성과 재사용성을 높인다.**
- 의미 단위가 달라지면 반드시 함수를 따로 만들자.

## 4.앱 생명주기 / 뷰 컨트롤러 생명주기 / Drawing Cycle

### 배운점 및 회고

**1. 앱 생명주기의 전반적인 cycle 이해** <br/>
**2. 뷰 컨트롤러 생명주기의 전반적인 cycle 이해 및 활용** <br/>
**3. 뷰의 Drawing Cycle 및 setNeedsDisplay / setNeedsLayout / ifLayoutNeeded 차이 이해** <br/>

## 5. Navigation / Tabbar Controller

<img src="https://github.com/yurrrri/study-UIKit/assets/37764504/c4ea57f8-06c8-47cb-b8ec-d050280f6d5d" width="250"/>

### 배운점 및 회고

**1. 네비게이션 / 탭바 컨트롤러 각각 스토리보드 / 코드 방식 구현 복습** <br/>
**2. 스토리보드 분리에 대한 이해** <br/>
- 스토리보드로 협업을 진행할 경우 자기 파트 스토리보드를 분리해서 개발함

## 6. 네트워킹(URLSession) + GCD

<img width="300" alt="image" src="https://github.com/yurrrri/study-UIKit/assets/37764504/8170eec3-48c7-4214-8739-a0433955d4eb">
<img width="300" alt="image" src="https://github.com/yurrrri/study-UIKit/assets/37764504/2c5802a7-a6e8-4c1e-8e58-78a8d098d1f5">

### 배운점 및 회고

**1. content Hugging / Resistance에 대한 이해** <br/>
- 오토레이아웃에서 intrinsicContentSize를 가진 뷰가 각각 더이상 늘어나지 않도록 / 줄어들지 않도록 제약을 가진 뷰 간에 우선순위를 조정 <br/>

**2. 값이 바뀔수도 있는 내용 (마진값이나 서버 주소 등)은 enum이나 struct의 저장속성으로 묶으면 하드 코딩으로 인한 실수가 줄 뿐더러 값이 바뀔 경우 한번의 수정으로 인해 모든 코드를 수정하지 않아도 된다는 편리함이 존재함** <br/>
- enum으로 하면 인스턴스를 생성하지 않아도 되니 편리
```swift
enum MusicApi {
    static let url = "https://itunes.apple.com/search?"
    static let param = "media=music"
}
```
- 보통 서버 주소나 key값 같은 git에 올라가지 않아야 하는 내용들을 따로 Constant로 묶어서 gitignore에 넣어서 관리하면 좋음

**3. 이미지가 있는 cell의 경우, cell의 재사용성으로 인해 잘못된 이미지가 섞여보일 수 있음을 인지하고 이에 대한 대응 방식 이해**
```swift
    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
    }
```
- 재사용되기 전에 이미지를 초기화하여 재사용했을 때 이미지를 새로 데이터를 받아와서 세팅하도록 함

```swift
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
```

- 스크롤할 때 이미지 다운로드의 경우 상대적으로 오래걸리는 작업이므로, 해당 작업이 마치기도 전에 재사용되면서 url이 바뀔 수도 있으므로 url이 바뀌었다면 이미지가 바뀌지 않도록 방지
