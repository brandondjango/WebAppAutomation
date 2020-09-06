class GoogleHomePage < BasePage


    ###########################################
    # ##End of Elements
    # #########################################
    text_field(:search_bar, name: 'q')
    link(:about_link, text: 'About')


    ###########################################
    # ##End of Elements
    # #########################################
    def url_for_page
      "google.com"
    end

    def search_for_term(query)
      set_generic_element_value(search_bar_element, query)
    end
end


