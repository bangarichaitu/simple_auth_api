module ValidationRegex
  EMAIL = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  BUSINESS_TIN = /\A\d{2}-{0,1}\d{7}\z/
  ZIPCODE = /\A\d{5}\z/
  SSN = /\A\d{3}-?\d{2}-?\d{4}\z/
  MODIFIED_SSN = /(\d{3})(\d{2})(\d{3})/
  PHONE = /\A[A-z0-9()-. ]+{10}\z/
  PHONE_TEN_DIGITS = /\A\d{10}\z/
  PASSWORD_FORMAT = /\A
    (?=.*[0-9])        # Must contain a number
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol(special character)
  /x
  CITY = /\A[a-zA-Z0-9 .,'-]+\z/
end
