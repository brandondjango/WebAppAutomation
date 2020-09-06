require 'require_all'
require 'watir'
require 'selenium-webdriver'
require 'page-object'
require 'watir-scroll'
require 'yaml'


class BasePage

    include PageObject

    #untrusted cert elements:
    button(:advance_button, id: "advancedButton")
    button(:accept_risk_button, id: "exceptionDialogButton")
    button(:add_exception_button, text:"Add Exception")

    def go_to_url(url)
      @browser.goto(url)
      @browser.url
    end

    def go_to_page_url
      begin
        @browser.goto(self.url_for_page)
      rescue Selenium::WebDriver::Error::WebDriverError
        accept_risks if on_untrusted_cert_page?
        sleep 3
      end
    end

    def url_for_page
      self.class.url_for_page
    end

    def on_page?
      @browser.url == self.url_for_page
    end

    page_url(:url_for_page)

    def click_element(element)
      with_click_with_error_handling(element)
    end

    def command_click_element(element)
      with_click_with_error_handling(element) do
        element.click (:command)
      end
    end

    def shift_click_element(element)
      with_click_with_error_handling(element) do
        element.click (:shift)
      end
    end

    def check_console_log
      console_log = @browser.driver.manage.logs.get(:browser)
      puts "Console log: " + console_log
      if console_log != nil
        raise(console_log)
      end
    end

    def click_advanced_button
      click_element(advance_button_element)
    end

    def click_accept_risks_button
      click_element(accept_risk_button_element)
    end

    def click_add_exception_button
      click_element(add_exception_button_element)
    end

    def accept_risks
      click_advanced_button
      click_accept_risks_button if element_present?(accept_risk_button_element)
      click_add_exception_button if element_present?(add_exception_button_element)
    end

    def on_untrusted_cert_page?
      element_present?(advance_button_element)
    end

    def verify_image_on_page(image_name)
      @browser.screenshot.save "screenshots/#{@scenario_name}_Sikuli.png"
      #@browser.execute_script("document.body.style.zoom = 0.7")

      image_location = File.expand_path(Dir.pwd) + "/rukuli_images/" + image_name

      screen = Rukuli::Screen.new
      region = screen.find(image_location, 0.7) rescue nil
      return !region.nil?
    end

    def switch_newest_tab
      @browser.windows.last.use
    end

    def windows_available
      @browser.windows.length
    end

    def browser_tab_title
      @browser.title
    end

    def element_style_attribute(element, style_attribute)
      element.style(style_attribute)
    end

    def set_generic_element_value(element, value)

      element = element_for(element)
      element.value = value
    end

    def element_present?(element_or_name)
      element = element_for(element_or_name)

      begin
        # Element.present? seems to be bugged. Checking for existence and visibility instead
        #element.exists? && element_visible?(element)
        element.present?
      rescue Watir::Exception::UnknownObjectException, Watir::Wait::TimeoutError
        # Sometimes it makes it past the existence check but stops existing before the visible check, which then explodes
        false
      end
    end

    def element_visible?(element_or_name)
      retried = false

      # Watir normally handle stale element errors but because we are directly executing JavaScript, we have to handle them ourselves
      begin
        element = element_for(element_or_name)

        # Element.visible? sometime returns false due to shenanigans related to how the application is laid out in the DOM. Double check with JavaScript because shenanigans can be beaten with even more shenanigans.
        element.visible? || ((@browser.execute_script('return window.getComputedStyle(arguments[0],null).getPropertyValue("visibility")', element.element) == 'visible') &&
            (@browser.execute_script('return window.getComputedStyle(arguments[0],null).getPropertyValue("display")', element.element) != 'none'))
      rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
        raise(e) if retried

        retried = true
        retry
      end
    end

    def element_exists?(element_or_name)
      element = element_for(element_or_name)

      begin
        # Element.present? seems to be bugged. Checking for existence and visibility instead
        element.exists?
      rescue Watir::Exception::UnknownObjectException
        # Sometimes it makes it past the existence check but stops existing before the visible check, which then explodes
        false
      end
    end

    def set_field(element_or_name, value)
      element = element_for(element_or_name)

      case
      when element.class.to_s =~ /div/i
        set_div_value(element, value)
      when element.class.to_s =~ /select/i
        set_select_list_value(element, value)
      when element.class.to_s =~ /checkbox/i
        set_checkbox_value(element, value)
      else
        set_generic_element_value(element, value)
      end
    end

    def set_checkbox_value(element, value)
      value = value.downcase if value.is_a?(String)

      case value
      when 'no', 'check', true
        check_element(element)
      when 'yes', 'uncheck', false
        uncheck_element(element)
      else
        raise(ArgumentError, "Unknown checkbox state '#{value}'")
      end
    end

    def set_select_list_value(element, value)
      element.select(value)
    end

    def set_div_value(element, value)
      element.send_keys(value)
    end

    def check_element(element_or_name)
      element = element_for(element_or_name)

      element.check unless check_option_selected?(element_or_name)
    end

    def uncheck_element(element_or_name)
      element = element_for(element_or_name)

      element.uncheck if check_option_selected?(element_or_name)
    end

    def check_option_selected?(element_or_name)
      element = element_for(element_or_name)

      element.checked?
    end

    def js_set_field(element_or_name, value)
      element = element_for(element_or_name)

      @browser.execute_script('arguments[0].value = arguments[1]', element.element, value)
    end

    #We'll see if we can use this
    def set_field_with_retry(element_or_name, value, attempts: 2)
      element = element_for(element_or_name)

      attempts.times do
        set_field(element, value)
        match = if value.is_a?(Regexp)
                  get_field(element) =~ value
                else
                  get_field(element) == value
                end

        break if match
        sleep 1
      end

      match = if value.is_a?(Regexp)
                get_field(element) =~ value
              else
                get_field(element) == value
              end

      raise("Could not set '#{element_or_name}' to '#{value}' after #{attempts} attempts") unless match
    end

    def wait_to_be_on_page(seconds = 30)
      message = "Expected to be on this page: -- #{self.class} -- but was not.\nCurrent URL: -- #{@browser.url} --"
      wait_until(seconds, message) { on_page? }
    end

    def wait_for_element(element_or_name)
      element = element_for(element_or_name)
      @browser.wait_until { element.present? }
    end

    def element_collection_to_array(collection)
      array_to_return = []

      collection.each do |element|
        array_to_return.push(element)
      end

      return array_to_return
    end

    ####################################################################################
    # ##################################################################################
    ####################################################################################
    private
    ####################################################################################
    # ##################################################################################
    # ##################################################################################

    def with_click_with_error_handling(element)
      retries = 0
      scroll_position = [:bottom, :center, :top] # Scrolling through several positions because at least one of them should have less chance that some part of the UI is covering the view area of the element


      begin
        element.click
      #todo fix this to not take all exceptions
      rescue Exception => e
        # Sometimes stuff is still transitioning and in the way but might go away after a moment.
        if e.message =~ /element would receive the click|not clickable|element click intercepted/
          raise("Was not able to click on element after #{retries} attempts") if retries > 20

          sleep 0.25

          # Sometimes elements are not in view and need to be scrolled to
          scroll_position.rotate!
          scroll_to_element(element, scroll_position.first)
          retries += 1

          retry
        end

        raise e
      end
    end

    def element_for(element_or_name, plural = false)
      begin
        element = resolve_element(element_or_name, plural)
      rescue NoMethodError => e
        # When appropriate, give a class specific error message instead of having everything being a attributed to the browser object
        raise(e.class, e.message.sub(/for #<.*>/, "for #{self.class}")) if e.message =~ /Watir::Browser/

        raise e
      end

      raise(ArgumentError, "No element returned for '#{element_or_name}'") unless element


      element
    end

    def resolve_element(element_or_name, plural)
      # Could have been given the name of an element or an element object
      if element_or_name.is_a?(String) || element_or_name.is_a?(Symbol)
        send("#{element_or_name}_element#{plural ? 's' : ''}")
      else
        element_or_name
      end
    end

    def scroll_to_element(element_or_name, position = :top)
      element = element_for(element_or_name)
      element.scroll.to(position)
    end
end


