# frozen_string_literal: true
# test_via: ../backtrace.rb
module GraphQL
  class Backtrace
    # When {Backtrace} is enabled, raised errors are wrapped with {TracedError}.
    class TracedError < GraphQL::Error
      # @return [Array<String>] Printable backtrace of GraphQL error context
      attr_reader :graphql_backtrace

      # @return [GraphQL::Query::Context] The context at the field where the error was raised
      attr_reader :context

      MESSAGE_TEMPLATE = <<-MESSAGE
Unhandled error during GraphQL execution:

  %{cause_message}

Use #cause to access the original exception (including #cause.backtrace).

GraphQL Backtrace:
%{graphql_table}
MESSAGE

      def initialize(err, current_ctx)
        @context = current_ctx
        backtrace = Backtrace.new(current_ctx, value: err)
        @graphql_backtrace = backtrace.to_a

        message = MESSAGE_TEMPLATE % {
          cause_message: err.message,
          graphql_table: backtrace.inspect,
        }
        super(message)
      end
    end
  end
end