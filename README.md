# ToastView Sample App

The ToastView Sample App is a simple iOS application that demonstrates the usage of a custom ToastView to display toast messages with various configurations. The ToastView allows you to present messages in a non-intrusive way, and this app provides examples of two usage scenarios: using a single shared instance and using multiple isolated instances.

## Features

1. **Shared Instance Usage**
   - Utilizes a single shared instance of ToastView.
   - Calls `ToastView.shared.showToast(...)` to display toast messages.
   - Convenient for scenarios where a single global toast view is sufficient.

2. **Isolated Instance Usage**
   - Uses multiple instances of ToastView.
   - Calls `ToastView().showToast(...)` to display toast messages.
   - Useful when you need separate and independent toast views.

3. **Customizable Themes**
   - Provides a `ToastViewTheme` class for customizing the appearance of toast messages.
   - Easily adjust primary and secondary text colors, surface colors, and message font.

## Usage

### Shared Instance Usage

```swift
ToastView.shared.showToast(
    message: "Your message here",
    on: parentView,
    position: .aboveTopAnchor,
    autoHide: true,
    mode: .showProgress,
    haptic: nil
)
```

### Isolated Instance Usage

```swift
ToastView().showToast(
    message: "Your message here",
    on: parentView,
    position: .aboveTopAnchor,
    autoHide: true,
    mode: .showProgress,
    haptic: nil
)
```

### Customizing Themes

```swift
// Example: Customizing the ToastView theme
ToastViewTheme.primaryTextColor = .systemBlue
ToastViewTheme.primarySurfaceColor = .systemBackground
ToastViewTheme.secondaryTextColor = .label
ToastViewTheme.secondarySurfaceColor = .systemFill
ToastViewTheme.messageFont = UIFont.systemFont(ofSize: 15, weight: .light)
```

## ToastView Functions

### showToast Function

```swift
func showToast(
    message: String,
    on uiView: UIView,
    position: Position = .aboveTopAnchor,
    autoHide: Bool = false,
    mode: Mode = .showProgress,
    animationTime: TimeInterval = 0.25,
    haptic type: UINotificationFeedbackGenerator.FeedbackType?
)
```

- **Parameters:**
  - `message`: The message to be displayed in the toast.
  - `uiView`: The UIView on which the toast will be presented.
  - `position`: The position at which the toast will be displayed (default is `.aboveTopAnchor`).
  - `autoHide`: Boolean indicating whether the toast should automatically hide after being displayed (default is `false`).
  - `mode`: The mode of the toast, such as showing progress or displaying a prefix image (default is `.showProgress`).
  - `animationTime`: The duration of the toast animation (default is `0.25` seconds).
  - `haptic type`: The type of haptic feedback to be triggered (optional).

- **Description:**
  - The `showToast` function is responsible for presenting the toast message with the specified configuration.

## Customizing Themes with ToastViewTheme

### ToastViewTheme Class

```swift
public class ToastViewTheme {
    public static var primaryTextColor: UIColor = .label
    public static var primarySurfaceColor: UIColor = .systemFill
    public static var secondaryTextColor: UIColor = .label
    public static var secondarySurfaceColor: UIColor = .systemFill
    
    public static var messageFont: UIFont = .systemFont(ofSize: 15, weight: .light)
    
    public init(primaryTextColor: UIColor, primarySurfaceColor: UIColor, secondaryTextColor: UIColor, secondarySurfaceColor: UIColor, messageFont: UIFont) {
        Self.primaryTextColor = primaryTextColor
        Self.primarySurfaceColor = primarySurfaceColor
        Self.secondaryTextColor = secondaryTextColor
        Self.secondarySurfaceColor = secondarySurfaceColor
        Self.messageFont = messageFont
    }
}
```

- **Description:**
  - The `ToastViewTheme` class allows you to customize the appearance of toast messages by adjusting primary and secondary text colors, surface colors, and message font.

## License

This sample app is provided under the MIT License. Feel free to use and modify the code as needed.

**Enjoy using the ToastView Sample App!**
