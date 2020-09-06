class AcheckerPage < BasePage

    ###########################################
    # ##Start of Elements
    # #########################################
    span(:paste_html_markup_tab, text: 'Paste HTML Markup')
    button(:check_it_button, id: 'validate_paste')
    text_area(:html_markup_textarea, id: 'checkpaste')
    span(:no_error_message, id: 'AC_congrats_msg_for_errors', text: 'Congratulations! No known problems.')



    def url_for_page
      "https://achecker.ca/checker/index.php"
    end

    def check_compliance(html_markup)
      click_element(paste_html_markup_tab_element)
      js_set_field(html_markup_textarea_element, html_markup)
      click_element(check_it_button_element)
      element_present?(no_error_message_element)
    end
end

