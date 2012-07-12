class StripAccent < String
  
  #@keywords is array of string
  #@return is copy array of accent stripped strings
  def self.strip_accents keyword
    return nil if keyword == nil
    stripped = keyword.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s
    return stripped
  end
  
end