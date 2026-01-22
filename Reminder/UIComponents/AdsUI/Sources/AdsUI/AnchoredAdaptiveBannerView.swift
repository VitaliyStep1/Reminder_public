import SwiftUI
import GoogleMobileAds
import UIKit

public enum ReminderAdUnitId {
  // Test identifiers
  public static let closestBanner = "ca-app-pub-3940256099942544/2435281174"
  public static let categoriesBanner = "ca-app-pub-3940256099942544/2435281174"
  public static let categoryBanner = "ca-app-pub-3940256099942544/2435281174"
}

public struct AnchoredAdaptiveBannerView: View {
  private let adUnitId: String
  
  @State private var adSize: AdSize = AdSizeBanner
  
  public init(adUnitId: String) {
    self.adUnitId = adUnitId
  }
  
  public var body: some View {
    GeometryReader { geometry in
      BannerViewRepresentable(
        adUnitId: adUnitId,
        availableWidth: geometry.size.width,
        adSize: $adSize
      )
      .frame(width: geometry.size.width, height: adSize.size.height)
      .frame(maxWidth: .infinity, maxHeight: adSize.size.height)
    }
    .frame(height: adSize.size.height)
  }
}

private struct BannerViewRepresentable: UIViewRepresentable {
  let adUnitId: String
  let availableWidth: CGFloat
  @Binding var adSize: AdSize
  
  func makeCoordinator() -> Coordinator { Coordinator() }
  
  func makeUIView(context: Context) -> BannerView {
    let view = BannerView(adSize: adSize)
    view.adUnitID = adUnitId
    view.rootViewController = context.coordinator.rootViewController
    return view
  }
  
  func updateUIView(_ view: BannerView, context: Context) {
    guard availableWidth > 0 else { return }
    
    let newSize = currentOrientationAnchoredAdaptiveBanner(width: availableWidth)
    
    if view.rootViewController == nil {
      view.rootViewController = context.coordinator.rootViewController
    }
    
    let adUnitChanged = (view.adUnitID != adUnitId)
    if adUnitChanged {
      view.adUnitID = adUnitId
    }
    
    let sizeChanged = updateAdSizeIfNeeded(view, newSize: newSize)
    
    if context.coordinator.shouldReloadAd(width: availableWidth,
                                          adUnitChanged: adUnitChanged,
                                          sizeChanged: sizeChanged) {
      view.load(Request())
    }
  }
  
  @discardableResult
  private func updateAdSizeIfNeeded(_ bannerView: BannerView, newSize: AdSize) -> Bool {
    let changed = (bannerView.adSize.size != newSize.size)
    if changed {
      bannerView.adSize = newSize
    }
    
    if adSize.size != newSize.size {
      Task { @MainActor in
        adSize = newSize
      }
    }
    
    return changed
  }
  
  final class Coordinator {
    private var lastWidthBucket: Int?
    private var didLoadOnce = false
    
    var rootViewController: UIViewController? {
      UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first(where: { $0.isKeyWindow })?
        .rootViewController
    }
    
    func shouldReloadAd(width: CGFloat, adUnitChanged: Bool, sizeChanged: Bool) -> Bool {
      let bucket = Int(width.rounded(.down))
      
      defer {
        lastWidthBucket = bucket
        didLoadOnce = true
      }
      
      if !didLoadOnce { return true }
      if adUnitChanged { return true }
      if sizeChanged { return true }
      
      guard let last = lastWidthBucket else { return true }
      return abs(bucket - last) >= 2
    }
  }
}
