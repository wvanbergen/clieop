class String
  # 0x3000: fullwidth whitespace
  NON_WHITESPACE_REGEXP = %r![^\s#{[0x3000].pack("U")}]!

  # A string is blank if it's empty or contains whitespaces only:
  #
  #   "".blank?                 # => true
  #   "   ".blank?              # => true
  #   "　".blank?               # => true
  #   " something here ".blank? # => false
  #
  def blank?
    self !~ NON_WHITESPACE_REGEXP
  end
  
  def present?
    !blank?
  end  
end