// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {

  public enum CustomError {
    public enum Default {
      public enum Message {
        /// Acesso negado (403).
        public static let accessDenied = Strings.tr("Localizable", "CustomError.Default.Message.accessDenied")
        /// Erro do cliente: %i.
        public static func client(_ p1: Int) -> String {
          return Strings.tr("Localizable", "CustomError.Default.Message.client", p1)
        }
        /// Conflito (409).
        public static let conflict = Strings.tr("Localizable", "CustomError.Default.Message.conflict")
        /// Erro HTTP: %i.
        public static func http(_ p1: Int) -> String {
          return Strings.tr("Localizable", "CustomError.Default.Message.http", p1)
        }
        /// Erro interno do servidor (500).
        public static let internalError = Strings.tr("Localizable", "CustomError.Default.Message.internalError")
        /// Gateway inválido (502).
        public static let invalidGateway = Strings.tr("Localizable", "CustomError.Default.Message.invalidGateway")
        /// Requisição inválida (400).
        public static let invalidRequisition = Strings.tr("Localizable", "CustomError.Default.Message.invalidRequisition")
        /// Muitas requisições (429).
        public static let manyRequisitions = Strings.tr("Localizable", "CustomError.Default.Message.manyRequisitions")
        /// Entidade não processável (422).
        public static let nonProsecutableEntity = Strings.tr("Localizable", "CustomError.Default.Message.nonProsecutableEntity")
        /// Não autorizado (401).
        public static let notAuthorized = Strings.tr("Localizable", "CustomError.Default.Message.notAuthorized")
        /// Redirecionamento: %i.
        public static func redirection(_ p1: Int) -> String {
          return Strings.tr("Localizable", "CustomError.Default.Message.redirection", p1)
        }
        /// Erro do servidor: %i.
        public static func server(_ p1: Int) -> String {
          return Strings.tr("Localizable", "CustomError.Default.Message.server", p1)
        }
        /// Tempo de resposta excedido (504).
        public static let timeout = Strings.tr("Localizable", "CustomError.Default.Message.timeout")
        /// Serviço indisponível (503).
        public static let unavailableService = Strings.tr("Localizable", "CustomError.Default.Message.unavailableService")
      }
    }
    public enum Description {
      /// Operação cancelada.
      public static let cancelled = Strings.tr("Localizable", "CustomError.Description.cancelled")
      /// Falha ao interpretar a resposta: %@.
      public static func decoding(_ p1: Any) -> String {
        return Strings.tr("Localizable", "CustomError.Description.decoding", String(describing: p1))
      }
      /// Falha ao montar o corpo da requisição: %@.
      public static func encoding(_ p1: Any) -> String {
        return Strings.tr("Localizable", "CustomError.Description.encoding", String(describing: p1))
      }
      /// Falha ao interpretar o HTTP.
      public static let invalidHttpResponse = Strings.tr("Localizable", "CustomError.Description.invalidHttpResponse")
      /// URL inválida.
      public static let invalidUrl = Strings.tr("Localizable", "CustomError.Description.invalidUrl")
      /// Resposta vazia do servidor.
      public static let noData = Strings.tr("Localizable", "CustomError.Description.noData")
      /// Recurso não encontrado (404).
      public static let notFound = Strings.tr("Localizable", "CustomError.Description.notFound")
      /// Falha de conexão: %@.
      public static func transport(_ p1: Any) -> String {
        return Strings.tr("Localizable", "CustomError.Description.transport", String(describing: p1))
      }
    }
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
