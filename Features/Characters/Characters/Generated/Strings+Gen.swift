// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {

  public enum Details {
    /// Experiência
    public static let experience = Strings.tr("Localizable", "Details.experience")
    /// %i xp
    public static func experienceValue(_ p1: Int) -> String {
      return Strings.tr("Localizable", "Details.experienceValue", p1)
    }
    /// Altura
    public static let height = Strings.tr("Localizable", "Details.height")
    /// %i m
    public static func heightValue(_ p1: Int) -> String {
      return Strings.tr("Localizable", "Details.heightValue", p1)
    }
    /// Informações
    public static let informations = Strings.tr("Localizable", "Details.informations")
    /// Atributos
    public static let stats = Strings.tr("Localizable", "Details.stats")
    /// Peso
    public static let weight = Strings.tr("Localizable", "Details.weight")
    /// %i kg
    public static func weightValue(_ p1: Int) -> String {
      return Strings.tr("Localizable", "Details.weightValue", p1)
    }
  }

  public enum List {
    /// Pokédex
    public static let title = Strings.tr("Localizable", "List.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
