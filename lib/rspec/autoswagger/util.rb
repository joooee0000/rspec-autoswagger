class Util
  def self.detect_uuid(sentense)
    sentense.match(/^([a-zA-Z0-9]+-[a-zA-Z0-9]+-[a-zA-Z0-9]++-[a-zA-Z0-9]+-[a-zA-Z0-9]+)$/)
  end

  def self.detect_integer_id(sentense)
    sentense.match(/^(\d+)$/)
  end
end
