class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.pdf do
        open_as_pdf
      end
    end
  end

  private

  def open_as_pdf
    filename = controller_name
    tmp = Tempfile.new("pdf-chrome-#{filename}")
    browser = Ferrum::Browser.new
    browser.go_to("http://localhost:3000/home/index")
    sleep(0.3)
    browser.pdf(
      path: tmp.path,
      format: "A4".to_sym,
      landscape: false,
      # margin: {top: 36, right: 36, bottom: 36, left: 36},
      # preferCSSPageSize: true,
      # printBackground: true
    )
    browser.quit
    pdf_data = File.read(tmp.path)
    pdf_filename = "#{filename}123.pdf"
    send_data(pdf_data, filename: pdf_filename, type: "application/pdf", disposition: "inline")
  end
end
