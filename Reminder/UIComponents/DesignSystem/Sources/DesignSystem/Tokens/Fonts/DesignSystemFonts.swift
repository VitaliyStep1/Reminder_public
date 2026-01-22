import CoreText
import SwiftUI

public enum DSFontName: CaseIterable {
  case black
  case bold
  case extraBold
  case extraLight
  case light
  case medium
  case regular
  case semiBold
  
  var resourceName: String {
    switch self {
    case .black: return "Inter_24pt-Black"
    case .bold: return "Inter_24pt-Bold"
    case .extraBold: return "Inter_24pt-ExtraBold"
    case .extraLight: return "Inter_24pt-ExtraLight"
    case .light: return "Inter_24pt-Light"
    case .medium: return "Inter_24pt-Medium"
    case .regular: return "Inter_24pt-Regular"
    case .semiBold: return "Inter_24pt-SemiBold"
    }
  }
  
  var defaultPostScriptName: String {
    switch self {
    case .black: return "Inter-Black"
    case .bold: return "Inter-Bold"
    case .extraBold: return "Inter-ExtraBold"
    case .extraLight: return "Inter-ExtraLight"
    case .light: return "Inter-Light"
    case .medium: return "Inter-Medium"
    case .regular: return "Inter-Regular"
    case .semiBold: return "Inter-SemiBold"
    }
  }
}

public enum DesignSystemFonts {

  

  private static var registeredNames: [DSFontName: String] = [:]
  private static let fontExtension = "ttf"

  public static func registerFonts() {
    DSFontName.allCases.forEach { fontName in
      guard registeredNames[fontName] == nil else { return }
      registeredNames[fontName] = registerFont(fontName: fontName)
    }
  }

  public static func font(_ fontName: DSFontName, size: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) -> Font {
    if registeredNames.isEmpty {
      registerFonts()
    }

    let name = registeredNames[fontName] ?? fontName.defaultPostScriptName

    if let textStyle {
      return Font.custom(name, size: size, relativeTo: textStyle)
    } else {
      return Font.custom(name, size: size)
    }
  }

  @discardableResult
  private static func registerFont(fontName: DSFontName) -> String {
    guard let url = Bundle.module.url(forResource: fontName.resourceName, withExtension: fontExtension) else {
      return fontName.defaultPostScriptName
    }
    
    var registrationError: Unmanaged<CFError>?
    let wasRegistered = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &registrationError)
    
    if !wasRegistered, let error = registrationError?.takeUnretainedValue() {
      let nsError = error as Error
      if (nsError as NSError).code != Int(CTFontManagerError.alreadyRegistered.rawValue) {
        return fontName.defaultPostScriptName
      }
    }
    
    if let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor],
       let descriptor = descriptors.first,
       let postScriptName = CTFontDescriptorCopyAttribute(descriptor, kCTFontNameAttribute) as? String {
      return postScriptName
    }
    
    return fontName.defaultPostScriptName
  }
}
