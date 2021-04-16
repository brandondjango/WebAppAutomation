class VercelPage < BasePage

  include PageObject

  ###########################################
  # ##Start of Elements
  # #########################################
  text_field(:vercel_password_text_field, name: "_vercel_password")
  button(:vercel_login_button, text: "Log in")

  def login_vercel
    set_field(vercel_password_text_field_element, "W3lcom3!")
    click_element(vercel_login_button_element)
  end

end
