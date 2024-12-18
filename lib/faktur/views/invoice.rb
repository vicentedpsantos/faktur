module Faktur
  module Views
    class Invoice
      Result = Struct.new(:path, :filename)

      def initialize(invoice, client_config, options)
        @format = options[:format]
        @invoice = invoice
        @client_config = client_config
      end

      def process
        rendered =
          case @format
          when "html"
            Faktur::Views::Invoices::HTML.new(@invoice, @client_config).render
          when "pdf"
            Faktur::Views::Invoices::PDF.new(@invoice, @client_config).render
          else
            raise "Invalid format"
          end

        write_file(rendered)
      end

      private

      def write_file(rendered)
        File.open(filename, "wb") do |file|
          file.write(rendered)
        end

        build_result
      end

      def build_result
        Result.new(Dir.pwd, filename)
      end

      def filename
        "invoice.#{@format}"
      end
    end
  end
end
