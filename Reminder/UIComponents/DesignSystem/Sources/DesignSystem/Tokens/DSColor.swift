import SwiftUI

public enum DSColor {
  public enum Palette {
    public static let accent = Color.accentColor
    public static let accentO_8 = Color.accentColor.opacity(0.8)
    public static let accentO_7 = Color.accentColor.opacity(0.7)
    public static let accentO_3 = Color.accentColor.opacity(0.3)
    public static let accentO_25 = Color.accentColor.opacity(0.25)
    public static let accentO_12 = Color.accentColor.opacity(0.12)
    
    public static let blue = Color.blue
    public static let blueO_3 = Color.blue.opacity(0.3)
    public static let indigo = Color.indigo
    
    public static let red = Color.red
    public static let redO_85 = Color.red.opacity(0.85)
    public static let redO_2 = Color.red.opacity(0.2)
    
    public static let orange = Color.orange
    
    public static let green = Color.green
    
    public static let gray = Color.gray
    
    public static let systemBackground = Color(.systemBackground)
    public static let secondarySystemBackground = Color(.secondarySystemBackground)
    public static let systemGroupedBackground = Color(.systemGroupedBackground)
    public static let secondarySystemGroupedBackground = Color(.secondarySystemGroupedBackground)
    
    public static let blackO_1 = Color.black.opacity(0.1)
    public static let blackO_08 = Color.black.opacity(0.08)
    public static let blackO_06 = Color.black.opacity(0.06)
    public static let blackO_05 = Color.black.opacity(0.05)
    
    public static let primary = Color.primary
    public static let primaryO_08 = Color.primary.opacity(0.08)
    
    public static let secondary = Color.secondary
    public static let secondaryO_2 = Color.secondary.opacity(0.2)
    public static let white = Color.white
  }
  
  public enum Background {
    public static let primary = Palette.systemBackground
    public static let secondary = Palette.secondarySystemBackground
    public static let grouped = Palette.systemGroupedBackground
    public static let groupedSecondary = Palette.secondarySystemGroupedBackground
    public static let accent = Palette.accent
  }

  public enum Shadow {
    public static let blackO_05 = Palette.blackO_05
    public static let blackO_06 = Palette.blackO_06
    public static let blackO_08 = Palette.blackO_08
    public static let blackO_1 = Palette.blackO_1
    public static let blueO_3 = Palette.blueO_3
    public static let redO_2 = Palette.redO_2
    public static let accentO_3 = Palette.accentO_3
    public static let accentO_25 = Palette.accentO_25
  }

  public enum Text {
    public static let primary = Palette.primary
    public static let secondary = Palette.secondary
    public static let white = Palette.white
    public static let accent = Palette.accent
    public static let error = Palette.red
  }
  
  public enum Foreground {
    public static let white = Palette.white
    public static let accent = Palette.accent
    public static let blue = Palette.blue
  }
  
  public enum ProgressViewTint {
    public static let white = Palette.white
  }
  
  public enum Stroke {
    public static let primaryO_08 = Palette.primaryO_08
    public static let secondary = Palette.secondary
    public static let secondaryO_2 = Palette.secondaryO_2
    public static let accent = Palette.accent
  }
  
  public enum Icon {
    public static let white = Palette.white
    public static let red = Palette.red
    public static let orange = Palette.orange
    public static let green = Palette.green
    public static let gray = Palette.gray
    public static let accent = Palette.accent
  }
  
  public enum Gradient {
    public static let blueStart = Palette.blue
    public static let blueEnd = Palette.indigo
    
    public static let redStart = Palette.redO_85
    public static let redEnd = Palette.red
    
    public static let accentStart = Palette.accent
    public static let accentEnd = Palette.accentO_7
  }
  
  public enum Fill {
    public static let accent = Palette.accent
    public static let accentO_12 = Palette.accentO_12
  }
}
