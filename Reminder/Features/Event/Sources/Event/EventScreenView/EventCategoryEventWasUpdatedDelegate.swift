import DomainContracts

public protocol EventCategoryEventWasUpdatedDelegate: AnyObject {
  func popScreen()
  @MainActor
  func categoryEventWasUpdated(newCategoryId: Identifier?)
}
